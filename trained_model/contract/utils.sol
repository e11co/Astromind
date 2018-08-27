pragma solidity ^0.4.19;

contract Utils {
    
    
    ///@dev Compare strings for equality 
    ///     Equality returns true
    function compareString(string _s1,string _s2) public pure returns(bool){
        bytes memory s1 = bytes(_s1);
        bytes memory s2 = bytes(_s2);
        
        if(s1.length != s2.length){
            
            return false;
        }    
            
        for (uint j = 0; j < s1.length; j++){
            if (s1[j] != s2[j]){
               return false;
            }
           
        }
        return true;
    }
    
    function compareBytes32(bytes32 _s1,bytes32 _s2) public pure returns(bool){
    
        for (uint j = 0; j < _s1.length; j++){
            if (_s1[j] != _s2[j]){
               return false;
            }
           
        }
        return true;
    }
}