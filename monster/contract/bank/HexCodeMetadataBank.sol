// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title HexCodeMetadataBank
 * @notice MetadataBank using 4-digit HEX code system (0000-FFFF)
 * @dev 16^4 = 65,536 unique combinations with just 4 characters!
 */
contract HexCodeMetadataBank is IMetadataBank {
    using Strings for uint256;
    
    // 16 options per slot (0-F)
    string[16] private slot1Names = [
        "Dragon", "Phoenix", "Kraken", "Titan",      // 0-3
        "Sphinx", "Hydra", "Cerberus", "Basilisk",   // 4-7
        "Chimera", "Minotaur", "Leviathan", "Behemoth", // 8-B
        "Griffin", "Wyvern", "Djinn", "Seraph"       // C-F
    ];
    
    string[16] private slot2Names = [
        "Sword", "Shield", "Staff", "Bow",           // 0-3
        "Axe", "Spear", "Hammer", "Dagger",         // 4-7
        "Orb", "Tome", "Gauntlet", "Whip",         // 8-B
        "Scythe", "Trident", "Katana", "Grimoire"  // C-F
    ];
    
    string[16] private slot3Names = [
        "Fire", "Water", "Earth", "Air",            // 0-3
        "Light", "Dark", "Thunder", "Ice",          // 4-7
        "Nature", "Void", "Chaos", "Order",         // 8-B
        "Time", "Space", "Dream", "Death"           // C-F
    ];
    
    string[16] private slot4Names = [
        "Burning", "Frozen", "Blessed", "Cursed",   // 0-3
        "Invisible", "Giant", "Swift", "Wise",      // 4-7
        "Lucky", "Doomed", "Ethereal", "Solid",     // 8-B
        "Phasing", "Reflecting", "Absorbing", "Null" // C-F
    ];
    
    // Epic combinations
    mapping(uint16 => string) public legendaryNames;
    
    constructor() {
        // Special HEX patterns
        legendaryNames[0x0000] = "Void Genesis";
        legendaryNames[0xFFFF] = "Absolute Infinity";
        legendaryNames[0x1234] = "Ascending Order";
        legendaryNames[0xABCD] = "Alphabetic Sequence";
        legendaryNames[0xDEAD] = "Death Incarnate";
        legendaryNames[0xBEEF] = "Digital Beast";
        legendaryNames[0xCAFE] = "Mystic Brew";
        legendaryNames[0xFACE] = "Mask of Power";
        legendaryNames[0x1337] = "Elite Hacker";
        legendaryNames[0xAAAA] = "Quad Apex";
        legendaryNames[0x5555] = "Perfect Balance";
    }
    
    /**
     * @notice Get metadata for index (0-65535)
     */
    function getMetadata(uint256 index) external view override returns (string memory) {
        require(index < 65536, "Index exceeds FFFF");
        
        uint16 hexCode = uint16(index);
        (uint8 h1, uint8 h2, uint8 h3, uint8 h4) = decodeHex(hexCode);
        
        string memory name = legendaryNames[hexCode];
        bool isLegendary = bytes(name).length > 0;
        
        if (!isLegendary) {
            name = string(abi.encodePacked(
                slot3Names[h3], " ",
                slot1Names[h1], " #",
                toHexString(hexCode)
            ));
        }
        
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"HEX Code: ', toHexString(hexCode), ' - ',
            isLegendary ? 'Legendary combination!' : 'Unique creature',
            '",',
            '"image":"', generateHexImage(hexCode), '",',
            '"attributes":[',
                '{"trait_type":"HEX Code","value":"', toHexString(hexCode), '"},',
                '{"trait_type":"Species","value":"', slot1Names[h1], '"},',
                '{"trait_type":"Equipment","value":"', slot2Names[h2], '"},',
                '{"trait_type":"Element","value":"', slot3Names[h3], '"},',
                '{"trait_type":"Effect","value":"', slot4Names[h4], '"}',
                isLegendary ? ',{"trait_type":"Rarity","value":"Legendary"}' : '',
                _getPatternBonus(hexCode),
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Decode HEX code into 4 nibbles
     */
    function decodeHex(uint16 code) public pure returns (uint8 h1, uint8 h2, uint8 h3, uint8 h4) {
        h1 = uint8((code >> 12) & 0xF);
        h2 = uint8((code >> 8) & 0xF);
        h3 = uint8((code >> 4) & 0xF);
        h4 = uint8(code & 0xF);
    }
    
    /**
     * @notice Convert uint16 to hex string
     */
    function toHexString(uint16 value) private pure returns (string memory) {
        bytes memory buffer = new bytes(4);
        for (uint256 i = 4; i > 0; i--) {
            uint8 digit = uint8(value & 0xF);
            buffer[i-1] = digit < 10 ? bytes1(uint8(48 + digit)) : bytes1(uint8(55 + digit));
            value >>= 4;
        }
        return string(buffer);
    }
    
    /**
     * @notice Generate image based on HEX code
     */
    function generateHexImage(uint16 code) private view returns (string memory) {
        (uint8 h1, uint8 h2, uint8 h3, uint8 h4) = decodeHex(code);
        
        // Use hex values for colors
        string memory bgColor = string(abi.encodePacked(
            toHexChar(h1), toHexChar(h1),
            toHexChar(h2), toHexChar(h2),
            toHexChar(h3), toHexChar(h3)
        ));
        
        string memory fgColor = string(abi.encodePacked(
            toHexChar(h4), toHexChar(h4),
            toHexChar(h3), toHexChar(h3),
            toHexChar(h2), toHexChar(h2)
        ));
        
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="#', bgColor, '"/>',
            '<text x="200" y="80" text-anchor="middle" font-size="64" font-weight="bold" fill="#', fgColor, '">',
            toHexString(code),
            '</text>',
            _generateHexPattern(code),
            '<text x="200" y="350" text-anchor="middle" font-size="20" fill="#', fgColor, '">',
            slot1Names[h1], ' • ', slot3Names[h3],
            '</text>',
            '</svg>'
        ));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    /**
     * @notice Generate visual pattern based on hex code
     */
    function _generateHexPattern(uint16 code) private pure returns (string memory) {
        string memory pattern = '';
        
        // Create 16 hexagons in a 4x4 grid
        for (uint8 i = 0; i < 16; i++) {
            uint8 bit = uint8((code >> i) & 1);
            uint x = 100 + (i % 4) * 50;
            uint y = 150 + (i / 4) * 50;
            
            pattern = string(abi.encodePacked(
                pattern,
                '<circle cx="', x.toString(), '" cy="', y.toString(),
                '" r="20" fill="white" opacity="', bit == 1 ? '0.8' : '0.2', '"/>'
            ));
        }
        
        return pattern;
    }
    
    /**
     * @notice Detect special patterns for bonus attributes
     */
    function _getPatternBonus(uint16 code) private pure returns (string memory) {
        // Palindrome check (e.g., ABBA)
        if ((code >> 12) == (code & 0xF) && ((code >> 8) & 0xF) == ((code >> 4) & 0xF)) {
            return ',{"trait_type":"Pattern","value":"Palindrome"}';
        }
        
        // All same digit (e.g., AAAA)
        if (code == 0x0000 || code == 0x1111 || code == 0x2222 || code == 0x3333 ||
            code == 0x4444 || code == 0x5555 || code == 0x6666 || code == 0x7777 ||
            code == 0x8888 || code == 0x9999 || code == 0xAAAA || code == 0xBBBB ||
            code == 0xCCCC || code == 0xDDDD || code == 0xEEEE || code == 0xFFFF) {
            return ',{"trait_type":"Pattern","value":"Quadruple"}';
        }
        
        // Sequential (e.g., 0123, ABCD)
        uint8 h1 = uint8((code >> 12) & 0xF);
        uint8 h2 = uint8((code >> 8) & 0xF);
        uint8 h3 = uint8((code >> 4) & 0xF);
        uint8 h4 = uint8(code & 0xF);
        
        if (h2 == h1 + 1 && h3 == h2 + 1 && h4 == h3 + 1) {
            return ',{"trait_type":"Pattern","value":"Sequential"}';
        }
        
        return '';
    }
    
    function toHexChar(uint8 value) private pure returns (bytes1) {
        if (value < 10) return bytes1(uint8(48 + value));
        return bytes1(uint8(55 + value));
    }
    
    function getMetadataCount() external pure override returns (uint256) {
        return 65536; // 0x10000
    }
    
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 index = seed % 65536;
        return this.getMetadata(index);
    }
    
    /**
     * @notice Human-readable preview of any HEX code
     */
    function previewHexCode(string memory hexString) external view returns (
        string memory species,
        string memory equipment,
        string memory element,
        string memory effect,
        bool isLegendary
    ) {
        uint16 code = parseHexString(hexString);
        (uint8 h1, uint8 h2, uint8 h3, uint8 h4) = decodeHex(code);
        
        species = slot1Names[h1];
        equipment = slot2Names[h2];
        element = slot3Names[h3];
        effect = slot4Names[h4];
        isLegendary = bytes(legendaryNames[code]).length > 0;
    }
    
    /**
     * @notice Parse hex string to uint16
     */
    function parseHexString(string memory s) private pure returns (uint16) {
        bytes memory b = bytes(s);
        require(b.length == 4, "Must be 4 hex digits");
        
        uint16 result = 0;
        for (uint i = 0; i < 4; i++) {
            uint8 digit;
            uint8 c = uint8(b[i]);
            
            if (c >= 48 && c <= 57) {
                digit = c - 48; // 0-9
            } else if (c >= 65 && c <= 70) {
                digit = c - 55; // A-F
            } else if (c >= 97 && c <= 102) {
                digit = c - 87; // a-f
            } else {
                revert("Invalid hex character");
            }
            
            result = result * 16 + digit;
        }
        
        return result;
    }
}