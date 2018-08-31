pragma solidity ^0.4.19;
import "./astroeggbirth.sol";
import "./erc721interface.sol";
import "./astrobabycoin.sol";

///@title Egg transaction
///@author jon
///@dev Inherit erc721 standard token
contract EggOwnerShip is AstroEggBirth , AstroBabyCoin {
    
    // constructor ("ABC","AstroBabyCoin",10000000000,0.001,0.002){
        
    // }
    
    ///@dev Get the number of eggs owned by an address
    function getEggCount(address _owner) external view returns (uint256){
        return ownerToEggCount[_owner];
    }
    
    function ownerOf(uint256 _tokenId) external view returns (address){
        return eggToOwner[_tokenId];
    }
    
    // function safeTransferFrom(address _from, address _to, uint256 _tokenId,
    //  bytes data) external payable{
    // }
    
    // function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
    //  external payable{
    // }
    
    function _eggTransfer(
        address _from, 
        address _to, 
        uint256 _tokenId) 
        private {
        ownerToEggCount[_to] = ownerToEggCount[_to].add(1);
        ownerToEggCount[msg.sender] = ownerToEggCount[msg.sender].sub(1);
        eggToOwner[_tokenId] = _to;
        eggs[_tokenId].owner = _to;
        emit EggTransfer(_from, _to, _tokenId);
    }
    
    function eggTransfer(
        address _to, 
        uint256 _tokenId) 
        external 
        payable 
        onlyEggOwnerOf(_tokenId) {
        _eggTransfer(msg.sender,_to,_tokenId);
    }
    
    // function eggTransferFrom(
    //     address _from, 
    //     address _to, 
    //     uint256 _tokenId) 
    //     external 
    //     payable 
    //     onlyEggOwnerOf(_tokenId) {
    //     _eggTransfer(_from,_to,_tokenId);
    // }
    
    function eggApprove(
        address _approved, 
        uint32 _eggPrivce,
        uint256 _tokenId) 
        external onlyEggOwnerOf(_tokenId){
            
            require(eggApprovals[_tokenId] != address(1));
            
            eggs[_tokenId].shipPrice = _eggPrivce;
            eggs[_tokenId].shipFlag = true;
            eggApprovals[_tokenId] = _approved;
            emit Approval(msg.sender, _approved, _tokenId);
    }
    
     function eggTakeOwnership(
         uint256 _tokenId,
         uint _amount)  
         public 
         onlyAllowedToSell(_tokenId) {
        require(eggApprovals[_tokenId] == msg.sender);
        eggApprovals[_tokenId] == address(1);
        address owner = eggToOwner[_tokenId];
        transferFrom(msg.sender,owner,_amount);
        _eggTransfer(owner, msg.sender, _tokenId);
    }
    
    function sendEgg(address _to,uint256 _tokenId) public onlyAdmin{
        require(eggToOwner[_tokenId] == address(0));
        eggs[_tokenId].owner = _to;
        eggToOwner[_tokenId] = _to;
        ownerToEggCount[_to] += 1;
        emit SendEgg(_to,_tokenId);
    }
    
    ///@dev Shelf shop
    ///     Set your egg to a saleable state and indicate the sale price
    function shelf(
        uint _tokenId,
        uint32 _sellPrice) 
        public 
        onlyEggOwnerOf(_tokenId){
            eggs[_tokenId].shipFlag = true;
            eggs[_tokenId].shipPrice = _sellPrice;
        
    }
    
    ///@dev Removed egg from the store
    function Obtained(
        uint _tokenId) 
        public
        onlyEggOwnerOf(_tokenId) 
        onlyAllowedToSell(_tokenId){
            
            eggs[_tokenId].shipFlag = false;
    }
    
    function buyFromStore(
        uint _tokenId,
        uint _amount) 
        public
        onlyAllowedToSell(_tokenId){
        require(balances[msg.sender] >= _amount);
        transfer(eggToOwner[_tokenId],_amount);
        _eggTransfer(eggToOwner[_tokenId], msg.sender, _tokenId);
    }
    
    function getLikeCount(uint _tokenId) public view returns(uint16){
        return eggs[_tokenId].likeCount;
    }
    
    ///@dev return collection
    function getCollectionCount(uint _tokenId) public view returns(uint16){
        return eggs[_tokenId].collectionCount;
    }
    
    ///@dev Change the number that is like
    function setLikeCount(uint _tokenId) internal {
        // require(eggs[_tokenId].likeCount >= 0);
        eggs[_tokenId].likeCount++;
    }
    ///@dev Change the number that is collection
    function setCollectionCount(uint _tokenId) internal{
       eggs[_tokenId].collectionCount++;
    }
    
    ///@dev  Egg lottery settlement will generate a lucky value
    function lotterySettlement()  public onlyAdmin {
        require(now >= lotteryReadyTime);
        require(lotteryCount > 0);
        // luckNumber = uint32(keccak256(now/3,adminAddress,ceoAddress,block.number))%lotteryCount;
        luckNumber = 1;
        address lucker = lotteryer[luckNumber - 1];
        require(lucker != address(0));
        // uint[]  emptyEgg;
        // for(uint i = 0; i < eggs.length; i++){
        //     if(eggs[i].owner == address(0)){
        //         // sendEgg(lucker,i);
        //         // break;
        //         emptyEgg.push(i);
        //     }
        // }
        sendEgg(lucker,0);
        
        for(uint j = 0 ; j < lotteryer.length;j++){
            if(lotteryer[j] != lucker){
                transferFromTo(tokenPoolAccount,lotteryer[j],1);
            }
        }
        lotteryReadyTime = lotteryReadyTime.add(lotteryCoolDownTime);
        lotteryer.length = 0;
        // emptyEgg.length = 0;
        
        emit LotteryWinning(lucker);

    }
    
    ///@dev First step of the lottery
    ///     Sign up for eggs
    function lotteryEnroll() public {
        require(balances[msg.sender] >= 1);
        // An address can only be taken once
        require(lotterySet[msg.sender] == 0);
        require(isFirstEnroll(msg.sender));
        
        transfer(tokenPoolAccount,1);
        lotteryCount = uint32(lotteryer.push(msg.sender));
        
        // lotterySet[msg.sender] = lotteryCount;
        //lotteryer[lotteryCount - 1] = msg.sender; 
        emit LotteryEnroll(msg.sender,lotteryCount);
    }
    
    
    function isFirstEnroll(address _applyer)  public view returns(bool){
        for(uint i = 0 ;i < lotteryer.length;i++){
            if(_applyer == lotteryer[i]){
                return false;
            }
        }
        return true;
    }
    
    ///@dev Destroy an id of an id
    function destroyEgg(uint _eggId) public returns(uint){
        
    }
    
}


