pragma solidity^0.4.19;
import "./erc20interface.sol";
import "./accesscontrol.sol";

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract Token is ERC20Interface , AccessControl{

  /* Public variables of the token */
  string public standard;
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 _totalSupply;
  
//   address public crowdsaleContractAddress;

  /* Private variables of the token */
//   uint256 supply = 0;
  mapping (address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowed;
  
    ////@dev Map of whether the account and account status are frozen
    ///     Normal state is false
    mapping(address => bool) frozenAddrToStatus ;
    
  /* Events */
    event FrozenAccount(address frozenAddr,uint time);
    event UnFrozenAccount(address unFrozenAddr,uint time);
    event EthToToken(address targeAddr , uint amount);
    event TokenToEth(address targeAddr , uint amount);
    event Mint(address indexed _to, uint256 _value);
      
    modifier onlyNotFrozen(address _frozen){
        require(_frozen != address(0));
        require(!frozenAddrToStatus[_frozen]);
        _;
    }
        
    /* Returns total supply of issued tokens */
    function totalSupply() public constant returns (uint256) {
        return _totalSupply;
    }
    
      /* Returns balance of address */
      function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
      }
    
        function _transfer(address _from, address _to, uint256 _value) private onlyNotFrozen(_from){
            require(_to != 0x0 && _to != address(this));
            uint256 _preSum = balances[msg.sender].add(balances[_to]);
            balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
            balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
            // allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);  // Deduct allowance for this address
            /// Ensure the total amount of tokens before and after the transaction
            /// remains unchanged
            require(_preSum == balances[msg.sender].add(balances[_to])); 
            emit Transfer(_from, _to, _value);                                               // Raise Transfer event
        }
    
      /* Transfers tokens from your address to other */
      function transfer(address _to, uint256 _value) public returns (bool success) {
        
        _transfer(msg.sender,_to,_value);
        return true;
      }
      
      function transferFromTo(address _from, address _to, uint256 _value) public {
          _transfer(_from,_to,_value);
      }
    
      /* Approve other address to spend tokens on your account */
      function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;        // Set allowance
        emit Approval(msg.sender, _spender, _value);           // Raise Approval event
        return true;
      }
    
      /* Approve and then communicate the approved contract in a single tx */
      function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        ApproveAndCallFallBack spender = ApproveAndCallFallBack(_spender);            // Cast spender to tokenRecipient contract
        approve(_spender, _value);                                      // Set approval to contract for _value
        spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
        return true;
      }
    
      /* A contract attempts to get the coins */
      function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != 0x0 && _to != address(this));
        require(allowed[_from][msg.sender] >= _value);
        balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
        balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);  // Deduct allowance for this address
        emit Transfer(_from, _to, _value);                                               // Raise Transfer event
        return true;
      }
    
      function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
      }
    
        ///@dev Add  tokens outside the total token to an address
      function mintTokens(address _to, uint256 _amount) public {
        _totalSupply = _totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(msg.sender, _to, _amount);
      }
    
        function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
            return ERC20Interface(tokenAddress).transfer(ceoAddress, tokens);
        }
    
}