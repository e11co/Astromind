pragma solidity ^0.4.19;

import "./register.sol";
///@title login test  
///@author jonzhou   
///@dev User data is hardcoded and registration is not yet available...

contract Login is Register{
 
    
    function ln(string _name,string _pd) public view returns(uint8 logSuccess) {
        
        bytes memory _bName = bytes(_name);
        bytes32 cryptoPd = keccak256(abi.encodePacked(_pd));
        
        require( _bName.length > 0);
        
        // require(isExist(_name));
        bytes32 _passwod = nameToPassword[_name];
     
            if(cryptoPd != _passwod){
                
                return 0;
            }

        return 1;
    }
    
    
        ///@dev Get the username by userId
    function getUserInfo(uint _userId) public view returns(string username){
        
        return users[_userId].username;
        
    }
    
    function getPassword(string _username) public view returns (bytes32){
        
        return nameToPassword[_username];
        
    }
    
    
    function() payable public{
        
    }
    
}

