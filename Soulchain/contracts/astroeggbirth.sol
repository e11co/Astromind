pragma solidity ^0.4.19;

import "./eggbase.sol";

/*
 * @title AstroEggFactory 
 * @author jon 
 * @dev This is the birth method of astroegg
*/
contract AstroEggBirth is EggBase{
    
    ///@dev Egg birth method
    ///     Every egg is born will trigger an event
    function _createEgg(string _name, uint _dna) internal {
        uint eggId = eggs.push(Egg(_name,address(0),false,0,0,1,_dna)) - 1;
        eggToOwner[eggId] = address(0);
        ownerToEggCount[address(0)]++;
        emit NewEgg(eggId, _name, _dna,1);
    }
    
   
    /// @return Return dnaModulus random uint numbers
    /// @dev Have input characters, current time, and current caller address to 
    ///         generate random numbers
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand =uint(keccak256(uint(keccak256(_str)) + uint(keccak256(now)) 
            + uint(keccak256(msg.sender))));
        return uint(rand % dnaModulus);
    }
    
    
    ///@dev 
    function createRandomEgg(string _name) public onlyAdmin  {
       
        require( now >= readyTime );
        uint randDna = _generateRandomDna(_name);
        _createEgg(_name, randDna);
        readyTime = now+cooldownTime;
    }
    
    //set cooldownTime 
    function setCooldownTime(uint _time) public onlyAdmin  {
        cooldownTime = _time;
        emit NewCooldownTime(_time);
    }
    
    // user only test
    function getOwnerFromEggId(uint _eggId) public view returns(address) {
        return eggToOwner[_eggId];
    }
    
    //@dev Get some egg information
    function getEggInfo(uint _eggId) public view returns(
        string name,
        address owner,
        bool shipFlag,
        uint16 collectionCount,
        uint16 likeCount,
        uint32 shipPrice,
        uint dna) {
            return (eggs[_eggId].name,eggs[_eggId].owner,eggs[_eggId].shipFlag,
            eggs[_eggId].collectionCount,eggs[_eggId].likeCount,
            eggs[_eggId].shipPrice,eggs[_eggId].dna);           
        }
}