// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title OnchainMetadataBank
 * @notice MetadataBank implementation that generates metadata on-chain
 * @dev Returns base64 encoded JSON metadata directly
 */
contract OnchainMetadataBank is IMetadataBank {
    using Strings for uint256;
    
    // Attribute arrays
    string[10] private characters = [
        "Dragon", "Wizard", "Knight", "Beast", "Angel",
        "Demon", "Robot", "Alien", "Phoenix", "Spirit"
    ];
    
    string[10] private elements = [
        "Fire", "Water", "Earth", "Air", "Light",
        "Dark", "Thunder", "Ice", "Nature", "Void"
    ];
    
    string[10] private rarities = [
        "Common", "Common", "Common", "Common", "Uncommon",
        "Uncommon", "Uncommon", "Rare", "Epic", "Legendary"
    ];
    
    /**
     * @notice Generate metadata for a specific index
     * @param index The index to generate metadata for
     * @return Base64 encoded JSON metadata URI
     */
    function getMetadata(uint256 index) external view override returns (string memory) {
        // Generate attributes based on index
        uint256 charIndex = index % 10;
        uint256 elemIndex = (index / 10) % 10;
        uint256 rareIndex = (index / 100) % 10;
        
        // Build JSON metadata
        string memory json = string(abi.encodePacked(
            '{"name": "Creature #', index.toString(), '",',
            '"description": "Fully on-chain generated creature",',
            '"image": "', _generateSVGDataURI(charIndex, elemIndex), '",',
            '"attributes": [',
                '{"trait_type": "Character", "value": "', characters[charIndex], '"},',
                '{"trait_type": "Element", "value": "', elements[elemIndex], '"},',
                '{"trait_type": "Rarity", "value": "', rarities[rareIndex], '"}',
            ']}'
        ));
        
        // Return as base64 encoded data URI
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Generate a simple SVG image
     */
    function _generateSVGDataURI(uint256 charIndex, uint256 elemIndex) 
        private 
        view 
        returns (string memory) 
    {
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">',
            '<rect width="200" height="200" fill="#', _getColorHex(elemIndex), '"/>',
            '<text x="100" y="100" text-anchor="middle" font-size="24" fill="white">',
            characters[charIndex],
            '</text>',
            '<text x="100" y="130" text-anchor="middle" font-size="16" fill="white">',
            elements[elemIndex],
            '</text>',
            '</svg>'
        ));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    /**
     * @notice Get color hex based on element
     */
    function _getColorHex(uint256 elemIndex) private pure returns (string memory) {
        string[10] memory colors = [
            "FF4500", // Fire - Orange Red
            "1E90FF", // Water - Dodger Blue
            "8B4513", // Earth - Saddle Brown
            "87CEEB", // Air - Sky Blue
            "FFD700", // Light - Gold
            "483D8B", // Dark - Dark Slate Blue
            "FFD700", // Thunder - Yellow
            "00CED1", // Ice - Dark Turquoise
            "228B22", // Nature - Forest Green
            "4B0082"  // Void - Indigo
        ];
        return colors[elemIndex];
    }
    
    /**
     * @notice Get total metadata count (fixed at 1000)
     */
    function getMetadataCount() external pure override returns (uint256) {
        return 1000; // 10 x 10 x 10 combinations
    }
    
    /**
     * @notice Get random metadata based on seed
     */
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 index = seed % 1000;
        return this.getMetadata(index);
    }
}