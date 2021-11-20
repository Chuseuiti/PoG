// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HToken is ERC20 {
    
    // Minter role can create new tokens 
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    
    constructor(uint256 initialSupply) ERC20("Hunter", "H") {
        _mint(msg.sender, initialSupply);
        
        //Roles
        _setupRole(MINTER_ROLE, minter);
        _setupRole(BURNER_ROLE, burner);
    }
    
    function _mintOdinConclave() internal {
        _mint(block.coinbase, 1000); //distribution to the conclave to attrack new projects
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if (!(from == address(0) && to == block.coinbase)) {
          _mintOdinConclave();
        }
        super._beforeTokenTransfer(from, to, value);
    }
    
    function decimals() public view virtual override returns (uint8) {
      return 10;
    } 
    
    //Role based access control
    function specialThing() public onlyOwner {
        // only the owner can call specialThing()!
    }
    
    function mint(address to, uint256 amount) public {
        // Check that the calling account has the minter role
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }
    
    
}

