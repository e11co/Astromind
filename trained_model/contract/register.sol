pragma solidity ^0.4.19;
import "./registerloginbase.sol";


///@title  User registration via email,
///@author zhou
///@dev register
contract Register is RegisterLoginBase{
    
     
    ///@dev Register's main function, the registered user name cannot be the same
    ///     but... it is not possible to register with an email now.
    ///     and create wallet address function temporarily not done
    /// Return value status：
    ///             0:register success;
    ///             1:username is null 
    ///             2:username is exist
    ///@param _username User's name
    ///@param _password User's _password
    function register(string _username,string _password,string _email) external payable returns(uint8 registerSuccess){
        
        require((bytes(_password).length >= 0));
        
        require(!isExist(_username));
        
        
        bytes32 cryptoPd = keccak256(abi.encodePacked(_password));
        
        uint userId = users.push(User(_username,_email,cryptoPd));
        
        nameToPassword[_username] = cryptoPd;
        // emit Register(_username,userId);
        
        return 1;
        
    } 
    

    ///@dev Determine if the user exists
    /// The same username exists, returns true, does not exist the same username, returns false
    function isExist(string _username) public view returns(bool isexist){
        bytes memory _u0 = bytes(_username);
        
        for(uint i = 0 ; i < users.length;i++){
            
            bool sameFlag =  true;
            
            bytes memory _u1 = bytes(users[i].username);
            
            if( _u0.length !=  _u1.length){
                break;
            } else {
            
                for (uint j = 0; j < _u0.length; j++){
                    if (_u0[j] != _u1[j]){
                        
                        sameFlag = false;
                        break;
                    }
                   
                }
                
                
                if(sameFlag){
                    return true;
                }
            }
               
        }
        return false;
    }
    
}