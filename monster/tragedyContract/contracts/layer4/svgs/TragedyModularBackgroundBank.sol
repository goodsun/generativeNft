// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// SVG contract interface
interface ISVGContract {
    function getSVG() external pure returns (string memory);
}

/**
 * @title TragedyModularBackgroundBank
 * @notice Background bank that uses external calls to individual SVG contracts
 */
contract TragedyModularBackgroundBank {
    // Pre-deployed contract addresses
    address[10] public svgContracts;
    
    constructor(address[10] memory _contracts) {
        svgContracts = _contracts;
    }
    
    function getBackgroundSVG(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid ID");
        address svgContract = svgContracts[id];
        require(svgContract != address(0), "Contract not set");
        
        // External call to SVG contract
        return ISVGContract(svgContract).getSVG();
    }
    
    function setContract(uint8 id, address contractAddress) external {
        require(id < 10, "Invalid ID");
        svgContracts[id] = contractAddress;
    }
}