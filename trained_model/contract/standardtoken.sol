pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }



/**
 * @title AstroBabyCoinToken
 * @dev Implements the AstroBabyCoinToken generated by the standard erc20, 
 * including the implementation and special functional requirements of the erc20 interface
 */

contract StandardToken is Ownable {
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;  // 18 是建议的默认值
    uint256 public totalSupply;
    uint256 buyPrice;
    uint256 sellPrice;

    mapping (address => uint256) public balanceOf;  // The account address corresponds to the number of tokens
    mapping (address => mapping (address => uint256)) public allowance;     //
    mapping (address => bool) frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    
    event FrozenAcount(address FrozenAddress , bool frozen);

    event Burn(address indexed from, uint256 value);


    function StandardToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }
    

   /**
   * @dev Function to transfer token between accounts
   * @param _from Token transfer address
   * @param _to Token receiving address
   */
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(frozenAccount[_from]);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        totalSupply -= _value;
        Burn(_from, _value);
        return true;
    }
}