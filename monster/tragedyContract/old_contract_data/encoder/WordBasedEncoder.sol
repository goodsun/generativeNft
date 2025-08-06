// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAttributeEncoder.sol";

/**
 * @title WordBasedEncoder
 * @notice BASE64 encoding that creates meaningful words!
 * @dev Special word combinations have special meanings
 */
contract WordBasedEncoder is IAttributeEncoder {
    
    string private constant BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    // Special word mappings
    mapping(string => string) public specialWords;
    mapping(string => uint8) public wordRarity;
    
    constructor() {
        // 3文字の意味のある単語を登録
        _registerSpecialWord("GOD", "Divine Being", 5);
        _registerSpecialWord("ACE", "Perfect Score", 4);
        _registerSpecialWord("BAD", "Evil Incarnate", 3);
        _registerSpecialWord("CAT", "Feline Spirit", 3);
        _registerSpecialWord("DOG", "Loyal Guardian", 3);
        _registerSpecialWord("ELF", "Mystical Being", 4);
        _registerSpecialWord("FAE", "Fairy Touched", 4);
        _registerSpecialWord("GEM", "Precious Stone", 4);
        _registerSpecialWord("HEX", "Cursed Code", 4);
        _registerSpecialWord("ICE", "Frozen Heart", 3);
        _registerSpecialWord("JOY", "Pure Happiness", 3);
        _registerSpecialWord("KEY", "Master Unlocker", 4);
        _registerSpecialWord("LAW", "Order Keeper", 3);
        _registerSpecialWord("MAX", "Ultimate Power", 4);
        _registerSpecialWord("NEO", "The Chosen", 4);
        _registerSpecialWord("ORB", "Mystic Sphere", 3);
        _registerSpecialWord("PET", "Companion", 2);
        _registerSpecialWord("QED", "Proven Truth", 5);
        _registerSpecialWord("RAW", "Primal Force", 3);
        _registerSpecialWord("SUN", "Solar Power", 3);
        _registerSpecialWord("TOP", "Peak Performance", 3);
        _registerSpecialWord("UFO", "Alien Visitor", 4);
        _registerSpecialWord("VIP", "Very Important", 4);
        _registerSpecialWord("WAR", "Battle Ready", 3);
        _registerSpecialWord("XYZ", "Unknown Variable", 4);
        _registerSpecialWord("YES", "Positive Energy", 3);
        _registerSpecialWord("ZEN", "Perfect Balance", 4);
        
        // プログラミング関連
        _registerSpecialWord("API", "Interface Master", 4);
        _registerSpecialWord("BUG", "Glitch Entity", 3);
        _registerSpecialWord("CPU", "Core Processor", 4);
        _registerSpecialWord("DEV", "Developer Soul", 4);
        _registerSpecialWord("EXE", "Executable", 3);
        _registerSpecialWord("FTP", "File Transfer", 3);
        _registerSpecialWord("GIT", "Version Control", 3);
        _registerSpecialWord("IDE", "Integrated Dev", 3);
        _registerSpecialWord("JAR", "Java Archive", 3);
        _registerSpecialWord("LOG", "Record Keeper", 3);
        _registerSpecialWord("NET", "Network Node", 3);
        _registerSpecialWord("OOP", "Object Oriented", 4);
        _registerSpecialWord("PHP", "Hypertext", 3);
        _registerSpecialWord("SQL", "Query Master", 4);
        _registerSpecialWord("TCP", "Protocol Expert", 4);
        _registerSpecialWord("URL", "Link Master", 3);
        _registerSpecialWord("XML", "Markup Mage", 3);
        _registerSpecialWord("ZIP", "Compressed", 3);
        
        // 感情・状態
        _registerSpecialWord("LOL", "Laughing Spirit", 3);
        _registerSpecialWord("WOW", "Amazed Soul", 3);
        _registerSpecialWord("OMG", "Shocked Being", 3);
        _registerSpecialWord("WTF", "Confused Entity", 3);
        _registerSpecialWord("GGs", "Good Game", 3);
        _registerSpecialWord("AFK", "Away Spirit", 2);
        _registerSpecialWord("IRL", "Reality Bound", 3);
        _registerSpecialWord("TBH", "Truth Speaker", 3);
    }
    
    function _registerSpecialWord(string memory word, string memory meaning, uint8 rarity) private {
        specialWords[word] = meaning;
        wordRarity[word] = rarity;
    }
    
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure override returns (string memory) {
        require(a < 64 && b < 64 && c < 64 && d < 16, "Values out of range");
        
        // Pack into 18 bits (6+6+6)
        uint24 value = uint24(a) << 12 | uint24(b) << 6 | uint24(c);
        
        bytes memory result = new bytes(3);
        result[0] = bytes(BASE64_CHARS)[(value >> 12) & 0x3F];
        result[1] = bytes(BASE64_CHARS)[(value >> 6) & 0x3F];
        result[2] = bytes(BASE64_CHARS)[value & 0x3F];
        
        return string(result);
    }
    
    function decode(string memory code) external pure override returns (uint8 a, uint8 b, uint8 c, uint8 d) {
        bytes memory b = bytes(code);
        require(b.length == 3, "Must be 3 characters");
        
        uint24 value = uint24(indexOf(b[0])) << 12 | 
                       uint24(indexOf(b[1])) << 6 | 
                       uint24(indexOf(b[2]));
        
        a = uint8((value >> 12) & 0x3F);
        b = uint8((value >> 6) & 0x3F);
        c = uint8(value & 0x3F);
        d = 0; // Not used in word encoding
    }
    
    function indexOf(bytes1 char) private pure returns (uint8) {
        bytes memory chars = bytes(BASE64_CHARS);
        for (uint8 i = 0; i < chars.length; i++) {
            if (chars[i] == char) return i;
        }
        revert("Invalid character");
    }
    
    /**
     * @notice Check if a code is a special word
     */
    function isSpecialWord(string memory code) external view returns (bool, string memory, uint8) {
        string memory meaning = specialWords[code];
        if (bytes(meaning).length > 0) {
            return (true, meaning, wordRarity[code]);
        }
        return (false, "", 0);
    }
    
    /**
     * @notice Generate a word from attributes
     */
    function encodeToWord(uint8 a, uint8 b, uint8 c) external view returns (string memory word, bool isSpecial) {
        // Try to find nearest valid word
        bytes memory result = new bytes(3);
        result[0] = bytes(BASE64_CHARS)[a % 64];
        result[1] = bytes(BASE64_CHARS)[b % 64];
        result[2] = bytes(BASE64_CHARS)[c % 64];
        
        word = string(result);
        isSpecial = bytes(specialWords[word]).length > 0;
    }
    
    function getMaxValue() external pure override returns (uint256) {
        return 262143; // 64^3 - 1
    }
    
    function getBase() external pure override returns (uint8) {
        return 64;
    }
}

/**
 * @title WordNFTMetadataBank
 * @notice Special metadata bank for word-based NFTs
 */
contract WordNFTMetadataBank {
    using Strings for uint256;
    
    WordBasedEncoder public immutable encoder;
    
    constructor(address _encoder) {
        encoder = WordBasedEncoder(_encoder);
    }
    
    function generateWordMetadata(uint256 tokenId) external view returns (string memory) {
        require(tokenId < 262144, "Token ID too large");
        
        // Decode to get attributes
        uint8 a = uint8((tokenId >> 12) & 0x3F);
        uint8 b = uint8((tokenId >> 6) & 0x3F);
        uint8 c = uint8(tokenId & 0x3F);
        
        // Get word
        string memory code = encoder.encode(a, b, c, 0);
        (bool isSpecial, string memory meaning, uint8 rarity) = encoder.isSpecialWord(code);
        
        string memory name;
        string memory description;
        string memory rarityName;
        
        if (isSpecial) {
            name = string(abi.encodePacked(code, " - ", meaning));
            description = string(abi.encodePacked(
                "A legendary '", code, "' NFT representing ", meaning, 
                ". This is a special word with deep meaning in the digital realm."
            ));
            rarityName = getRarityName(rarity);
        } else {
            name = string(abi.encodePacked("Code: ", code));
            description = string(abi.encodePacked(
                "A unique 3-character code NFT: '", code, 
                "'. While not a special word, it's still one of 262,144 unique combinations."
            ));
            rarityName = "Common";
        }
        
        // Build JSON
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"attributes":[',
                '{"trait_type":"Code","value":"', code, '"},',
                '{"trait_type":"Is Word","value":"', isSpecial ? "Yes" : "No", '"},',
                '{"trait_type":"Rarity","value":"', rarityName, '"}',
                isSpecial ? string(abi.encodePacked(',{"trait_type":"Meaning","value":"', meaning, '"}')) : '',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    function getRarityName(uint8 rarity) private pure returns (string memory) {
        if (rarity >= 5) return "Mythic";
        if (rarity >= 4) return "Legendary";
        if (rarity >= 3) return "Epic";
        if (rarity >= 2) return "Rare";
        return "Common";
    }
}