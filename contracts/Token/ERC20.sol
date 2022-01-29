pragma solidity 0.8.7;
import "./IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract Neutron is ERC20PresetMinterPauser ("Neutron","NTN"){
        bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    address owner;
    address loaner;
    constructor (address _owner,address _loaner){
        owner= _owner;
        loaner=_loaner;
        _setupRole(MINTER_ROLE,loaner);
        _setupRole(BURNER_ROLE,loaner);
        _setupRole(PAUSER_ROLE,loaner);
    }
    
modifier onlyOwner(){
    require(msg.sender==owner);
_;}
function burn(address to, uint256 amount) public virtual {
        require(hasRole(BURNER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have burner role to burn");
        _burn(to,amount);
}

}


