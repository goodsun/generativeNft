// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockItemBank {
    // Simple SVG data for testing
    mapping(uint8 => string) private itemSVGs;
    
    constructor() {
        // Initialize with simple test SVGs
        itemSVGs[0] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2 L16 8 L12 14 L8 8 Z" fill="#FFD700"/></svg>'; // Crown (gold diamond)
        itemSVGs[1] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><rect x="11" y="4" width="2" height="16" fill="#C0C0C0"/></svg>'; // Sword (silver line)
        itemSVGs[2] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3" fill="#8B4513"/></svg>'; // Shield (brown circle)
    }
    
    function getItemSVG(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid item ID");
        if (bytes(itemSVGs[id]).length == 0) {
            // Return a default SVG if not set
            return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><rect x="10" y="10" width="4" height="4" fill="#666666"/></svg>';
        }
        return itemSVGs[id];
    }
}