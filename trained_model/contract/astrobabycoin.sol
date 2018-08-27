pragma solidity^0.4.19;

import "./token.sol";


// interface ABCInstance {
//     function lottery();
// }

contract AstroBabyCoin is Token {
    
    uint sellTokenPrice;
    uint buyTokenPrice;
    
    // mapping (string => address) contractAddress;
    constructor(
        string _symbol,
        string _name , 
        uint _total,
        uint _sellTokenPrice,
        uint _buyTokenPrice) 
        public {
        symbol = _symbol;
        name = _name;
        decimals = 18;
        _totalSupply = _total * 10**uint(decimals);
        balances[ceoAddress] = _totalSupply.div(2);
        balances[tokenPoolAccount] =_totalSupply.sub(_totalSupply.div(2));
        sellTokenPrice = _sellTokenPrice;
        buyTokenPrice = _buyTokenPrice;
        // abc = ABCInstance(_abiAddresss);
        // contractAddress["ABCInstance"] = _abiAddresss;
        emit Transfer(address(0), owner, _totalSupply);
    }
    
    ///@dev 
    // ABCInstance abc = ABCInstance(contractAddress["ABCInstance"]);
    
    function setSellTokenPrice(uint _newPrice) onlyCEO {
        sellTokenPrice = _newPrice;
    }
    
    function setBuyTokenPrice(uint _newPrice) onlyCEO {
        buyTokenPrice = _newPrice;
    }
    
    ///@dev frozen a account 
    function frozenAccount(address _targeAddr,bool _forzen) public onlyAdmin onlyNotFrozen(_targeAddr) {
        require(_targeAddr != address(0));
        frozenAddrToStatus[_targeAddr] = _forzen;
        emit FrozenAccount(_targeAddr,now);
    }
    
    ///@dev unfrozen a account
    function unFrozenAccount(address _targeAddr,bool _forzen) public onlyAdmin {
        require(frozenAddrToStatus[_targeAddr]);
        require(_targeAddr != address(0));
        frozenAddrToStatus[_targeAddr] = _forzen;
        emit FrozenAccount(_targeAddr,now);
    }
    
    ///@dev Use eth to redeem abc token
    function ethToToken(uint _amount,address _targeAddr) public payable{
        require(msg.value.mul(buyTokenPrice) >= _amount);
        transferFrom(tokenPoolAccount,_targeAddr,_amount);
        emit EthToToken(_targeAddr,_amount);
    }
    
    ///@dev Use abc to redeem eth
    function tokenTOEth(uint _amount) public{
        require(_amount <= (this.balance).mul(sellTokenPrice));
        transferFrom(msg.sender,tokenPoolAccount,_amount);
        msg.sender.transfer(_amount);
    }
    
   
    function withdraw() onlyCEO{
        ceoAddress.transfer(this.balance);
    }
    
    
    ///@dev fallback function
    function() public payable {
        
    }
}