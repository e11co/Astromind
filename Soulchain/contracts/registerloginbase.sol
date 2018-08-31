pragma solidity ^0.4.19;

import "./accesscontrol.sol";

///@title register and login data contract
///@author zhou
///@dev Provide data to use when registering and logging in

contract RegisterLoginBase is AccessControl {
    
    // login and resigter event
    event Login(string username);
    event Register(string username,uint userId);
    
    // User structure
    struct User{
    
        // User's name
        string username;
        
        // User's email 
        // Will be used to retrieve the password 
        string email;
        
        // User's password 
        // Should be the data encrypted by keccak256
        bytes32 password;
    }
    
    // User set , save all users
    User[]  users;
    
    // user's wallet address
    mapping(uint32 => address[]) userToWalletAddress;
    
    mapping(string => bytes32)  nameToPassword;
   
    
    
}