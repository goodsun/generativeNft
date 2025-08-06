// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockMonsterBank {
    // Simple SVG data for testing
    mapping(uint8 => string) private monsterSVGs;
    
    constructor() {
        // Initialize with simple test SVGs
        monsterSVGs[0] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="8" fill="#ff0000"/></svg>'; // Werewolf (red circle)
        monsterSVGs[1] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><rect x="6" y="6" width="12" height="12" fill="#00ff00"/></svg>'; // Goblin (green square)
        monsterSVGs[2] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><polygon points="12,4 6,20 18,20" fill="#0000ff"/></svg>'; // Vampire (blue triangle)
    }
    
    function getSpeciesSVG(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid species ID");
        if (bytes(monsterSVGs[id]).length == 0) {
            // Return a default SVG if not set
            return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="6" fill="#888888"/></svg>';
        }
        return monsterSVGs[id];
    }
}