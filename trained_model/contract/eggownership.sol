pragma solidity ^0.4.19;
import "./astroeggbirth.sol";
import "./erc721interface.sol";
import "./astrobabycoin.sol";

///@title Egg transaction
///@author jon
///@dev Inherit erc721 standard token
contract EggOwnerShip is AstroEggBirth , AstroBabyCoin {
    

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
    
    function sendEgg(uint256 _tokenId,address _to) onlyAdmin{
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
        onlyEggOwnerOf(_tokenId) 
        public {
            eggs[_tokenId].shipFlag = true;
            eggs[_tokenId].shipPrice = _sellPrice;
        
    }
    
    ///@dev Removed egg from the store
    function Obtained(
        uint _tokenId) 
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
    
    function getCollectionCount(uint _tokenId) public view returns(uint16){
        return eggs[_tokenId].collectionCount;
    }
    
    function setLikeCount(uint _tokenId) public {
        // require(eggs[_tokenId].likeCount >= 0);
        eggs[_tokenId].likeCount++;
    }
    function setCollectionCount(uint _tokenId) public{
       eggs[_tokenId].collectionCount++;
    }

}


