// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title FourDigitMetadataBank
 * @notice MetadataBank that uses 4-digit code system (0000-9999)
 * @dev Each digit represents an attribute, creating 10,000 unique combinations
 */
contract FourDigitMetadataBank is IMetadataBank {
    using Strings for uint256;
    
    // Attribute definitions (10 options per slot)
    string[10] private slot1Names = ["Dragon", "Phoenix", "Kraken", "Titan", "Sphinx", "Hydra", "Cerberus", "Basilisk", "Chimera", "Minotaur"];
    string[10] private slot2Names = ["Sword", "Shield", "Staff", "Bow", "Axe", "Spear", "Hammer", "Dagger", "Orb", "Tome"];
    string[10] private slot3Names = ["Fire", "Water", "Earth", "Air", "Light", "Dark", "Thunder", "Ice", "Nature", "Void"];
    string[10] private slot4Names = ["Burning", "Frozen", "Blessed", "Cursed", "Invisible", "Giant", "Swift", "Wise", "Lucky", "Doomed"];
    
    // Special combinations
    mapping(uint16 => string) public specialNames;
    mapping(uint16 => string) public specialDescriptions;
    
    constructor() {
        // Register special combinations
        specialNames[0] = "Genesis Being";
        specialDescriptions[0] = "The first of all creatures";
        
        specialNames[9999] = "Omega Entity";
        specialDescriptions[9999] = "The final form of evolution";
        
        specialNames[1234] = "Sequential Master";
        specialDescriptions[1234] = "Perfect harmony of all elements";
        
        specialNames[7777] = "Fortune's Chosen";
        specialDescriptions[7777] = "Blessed by incredible luck";
        
        specialNames[666] = "Cursed One";
        specialDescriptions[666] = "Marked by darkness";
    }
    
    /**
     * @notice Get metadata for a specific index (0-9999)
     */
    function getMetadata(uint256 index) external view override returns (string memory) {
        require(index < 10000, "Index out of range");
        
        uint16 code = uint16(index);
        (uint8 d1, uint8 d2, uint8 d3, uint8 d4) = decodeDigits(code);
        
        string memory name = specialNames[code];
        string memory description = specialDescriptions[code];
        
        if (bytes(name).length == 0) {
            name = string(abi.encodePacked(
                slot3Names[d3], " ",
                slot1Names[d1], " #",
                code.toString()
            ));
        }
        
        if (bytes(description).length == 0) {
            description = string(abi.encodePacked(
                "A ", slot1Names[d1],
                " wielding ", slot2Names[d2],
                " infused with ", slot3Names[d3],
                " power and ", slot4Names[d4], " effect"
            ));
        }
        
        // Generate JSON metadata
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', generateImageURI(code), '",',
            '"attributes":[',
                '{"trait_type":"Code","value":"', formatCode(code), '"},',
                '{"trait_type":"Species","value":"', slot1Names[d1], '"},',
                '{"trait_type":"Equipment","value":"', slot2Names[d2], '"},',
                '{"trait_type":"Element","value":"', slot3Names[d3], '"},',
                '{"trait_type":"Effect","value":"', slot4Names[d4], '"}',
                _getRarityAttribute(code),
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Decode 4-digit code into individual digits
     */
    function decodeDigits(uint16 code) public pure returns (uint8 d1, uint8 d2, uint8 d3, uint8 d4) {
        d1 = uint8(code / 1000);
        d2 = uint8((code / 100) % 10);
        d3 = uint8((code / 10) % 10);
        d4 = uint8(code % 10);
    }
    
    /**
     * @notice Format code as 4-digit string with leading zeros
     */
    function formatCode(uint16 code) private pure returns (string memory) {
        if (code >= 1000) return code.toString();
        if (code >= 100) return string(abi.encodePacked("0", code.toString()));
        if (code >= 10) return string(abi.encodePacked("00", code.toString()));
        return string(abi.encodePacked("000", code.toString()));
    }
    
    /**
     * @notice Generate SVG image based on 4-digit code
     */
    function generateImageURI(uint16 code) private view returns (string memory) {
        (uint8 d1, uint8 d2, uint8 d3, uint8 d4) = decodeDigits(code);
        
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="#', getBackgroundColor(d3), '"/>',
            '<text x="200" y="50" text-anchor="middle" font-size="48" font-weight="bold" fill="white">',
            formatCode(code),
            '</text>',
            '<text x="200" y="200" text-anchor="middle" font-size="24" fill="white">',
            slot1Names[d1],
            '</text>',
            '<text x="200" y="250" text-anchor="middle" font-size="18" fill="#cccccc">',
            slot2Names[d2], ' | ', slot4Names[d4],
            '</text>',
            _generateVisualElements(d1, d2, d3, d4),
            '</svg>'
        ));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    /**
     * @notice Get background color based on element
     */
    function getBackgroundColor(uint8 element) private pure returns (string memory) {
        string[10] memory colors = [
            "B22222", // Fire - Firebrick
            "4682B4", // Water - SteelBlue
            "8B4513", // Earth - SaddleBrown
            "87CEEB", // Air - SkyBlue
            "FFD700", // Light - Gold
            "4B0082", // Dark - Indigo
            "9932CC", // Thunder - DarkOrchid
            "00CED1", // Ice - DarkTurquoise
            "228B22", // Nature - ForestGreen
            "2F4F4F"  // Void - DarkSlateGray
        ];
        return colors[element];
    }
    
    /**
     * @notice Generate visual elements based on attributes
     */
    function _generateVisualElements(uint8 d1, uint8 d2, uint8 d3, uint8 d4) private pure returns (string memory) {
        string memory elements = '';
        
        // Add circles based on first digit (species)
        for (uint i = 0; i <= d1; i++) {
            uint x = 100 + (i * 20);
            uint y = 320;
            elements = string(abi.encodePacked(
                elements,
                '<circle cx="', x.toString(), '" cy="', y.toString(), 
                '" r="8" fill="white" opacity="0.6"/>'
            ));
        }
        
        return elements;
    }
    
    /**
     * @notice Get rarity attribute for special codes
     */
    function _getRarityAttribute(uint16 code) private view returns (string memory) {
        if (bytes(specialNames[code]).length > 0) {
            return ',{"trait_type":"Rarity","value":"Legendary"}';
        }
        
        // Palindromes are rare
        if (code / 1000 == code % 10 && (code / 100) % 10 == (code / 10) % 10) {
            return ',{"trait_type":"Rarity","value":"Rare"}';
        }
        
        // Repeating digits are uncommon
        if (code % 1111 == 0) {
            return ',{"trait_type":"Rarity","value":"Epic"}';
        }
        
        return ',{"trait_type":"Rarity","value":"Common"}';
    }
    
    /**
     * @notice Get total metadata count (always 10,000)
     */
    function getMetadataCount() external pure override returns (uint256) {
        return 10000;
    }
    
    /**
     * @notice Get random metadata based on seed
     */
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 index = seed % 10000;
        return this.getMetadata(index);
    }
    
    /**
     * @notice Preview what attributes a specific code will have
     */
    function previewCode(uint16 code) external view returns (
        string memory species,
        string memory equipment,
        string memory element,
        string memory effect,
        bool isSpecial
    ) {
        (uint8 d1, uint8 d2, uint8 d3, uint8 d4) = decodeDigits(code);
        species = slot1Names[d1];
        equipment = slot2Names[d2];
        element = slot3Names[d3];
        effect = slot4Names[d4];
        isSpecial = bytes(specialNames[code]).length > 0;
    }
}