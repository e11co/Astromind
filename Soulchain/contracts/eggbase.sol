pragma solidity ^0.4.19;

import "./accesscontrol.sol";

/// @title Base contract for egg. Holds all common structs, events and base variables.
/// @author jonzhou
/// @dev 

contract EggBase is AccessControl {
    
    // using SafeMath for uint256;
    // Event when new egg is generated
    event NewEgg(uint eggId,string name,uint dna,uint32 shipPrice);
    //  the new Generate egg cooling time
    event NewCooldownTime(uint time);
    // Egg trade between users
    event EggTransfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    // Administrator sends an egg event    
    event SendEgg(address _to,uint _tokenId);
    
    event EggApproval();
    
    event LotteryEnroll(address _applyAccount,uint32 _lotteryNumber);
    event LotteryWinning(address _lucker);
    
    // The number of DNA
    uint dnaDigits = 32;
    // Make sure to get the dnaDigits number from the generated random number; dnaModulus = 10 ** dnaDigits;
    uint dnaModulus = 10 ** dnaDigits;
    // AstroEgg generates cooldown time, which is also the cooldown of the draw.
    /*uint cooldownTime = 10 minutes;
    uint lotteryCoolDownTime = 10 minutes;*/
    uint cooldownTime = 10 seconds;
    uint lotteryCoolDownTime = 10 seconds;
    // When the current time is less than this value, you can not give birth to an egg. 
    uint readyTime = now ;
    uint lotteryReadyTime = now + lotteryReadyTime;
    
    // Global variable, record the subscript of the lottery (lotterySet[lotteryCount]). 
    // Each additional participant, lotteryCount plus one, is reassigned to 0 after each round of lottery                           .
    uint32 lotteryCount = 1;
    
    address[] public lotteryer;
    uint32 luckNumber ;
    
    // address winner;
    
    struct Egg {
        // The name of the egg, the default name is AstroEgg, the user can spend ABC to modify.
        // Reverts to the default name when the user makes an purchase of an authorized egg.
        string name;
        // Egg owner address, when the egg is generated, the owner points to the 0x0 empty address
        address owner;
        // Whether egg is authorized for sale; 
        // false: no authorization; true: authorized sale；Default: false
        bool shipFlag;
        // The number of times egg was collected
        uint16 collectionCount;
        // The number of times egg was like
        uint16 likeCount;
        // Egg sale price, the price is 1 ABC by default,
        // the user can authorize the sale and customize the price after owning the egg
        uint32 shipPrice;
        // Random 64-bit integer with egg generation
        uint dna;
        
    }
    
     // Store all eggs
    Egg[] public eggs;
    
     // Map the egg (the index in the array) to the key-value pair of the owner's address
    mapping (uint => address) public eggToOwner;
    // Map owner's address and hold egg number
    mapping (address => uint) ownerToEggCount;
    // Map the lottery's serial number (lotteryCount) to the participant's address. 
    // The winner is the address corresponding to the random lucky number, and a random number of "robot participants" may be added to this collection.
    mapping (address => uint32) lotterySet;   
    
    //Allow eggs to be purchased for an address user
    mapping (uint => address) eggApprovals;
    
    //Only allow the owner of the incoming egg
    modifier onlyEggOwnerOf (uint _eggId){
        require(msg.sender == eggToOwner[_eggId]);
        _;
    }
    
    modifier onlyAllowedToSell(uint _tokenId){
        require(eggs[_tokenId].shipFlag);
        _;
    }
    
}
