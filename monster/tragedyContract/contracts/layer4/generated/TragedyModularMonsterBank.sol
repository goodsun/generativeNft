// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Library interface
interface IMonsterLib {
    function getSVG() external pure returns (string memory);
}

/**
 * @title TragedyModularMonsterBank
 * @notice Monster bank that doesn't import libraries, uses external calls instead
 */
contract TragedyModularMonsterBank {
    // Pre-deployed library addresses
    address[10] public monsterLibraries;
    
    constructor(address[10] memory _libraries) {
        monsterLibraries = _libraries;
    }
    
    function getSpeciesSVG(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid species ID");
        address lib = monsterLibraries[id];
        require(lib != address(0), "Library not set");
        
        // External call to library contract
        return IMonsterLib(lib).getSVG();
    }
    
    function setLibrary(uint8 id, address lib) external {
        require(id < 10, "Invalid species ID");
        monsterLibraries[id] = lib;
    }
}