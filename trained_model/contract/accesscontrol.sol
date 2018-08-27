pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";
import "./utils.sol";

/// @title A facet of egg/baby that manages special access privileges.
/// @author jonzhou
/// @dev Control of contract access rights and suspension of contracts

contract AccessControl is Ownable,Utils{
    
    using SafeMath for uint256;
    
    ///@dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContractAddress);
    
    ///@dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public paused = false;
    
    ///@dev The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public ceoAddress;
    address public adminAddress;
    
    ///@dev An intermediate account used to transfer tokens to other accounts
    address public tokenPoolAccount;
    
    ///@dev Add deployment address to ceo during contract deployment
    constructor() public {
        ceoAddress = msg.sender;
    }
    
    ///@dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }
    
    modifier onlyAdmin(){
        require(msg.sender == adminAddress);
        _;
    }
    
    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }
    
    function setAdmin(address _newAdmin) external onlyCEO {
       // require(_newAdmin != address(0));
        adminAddress = _newAdmin;
        
    }
    
    function setTokenPoolAccount(address _tokenPool) onlyCEO{
        tokenPoolAccount = _tokenPool;
    }
    
    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }
    

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function pause() external onlyCEO whenNotPaused {
        paused = true;
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }    
}