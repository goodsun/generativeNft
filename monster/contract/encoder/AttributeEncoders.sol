// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAttributeEncoder.sol";

/**
 * @title DecimalEncoder
 * @notice 4-digit decimal encoding (0000-9999)
 * @dev 10^4 = 10,000 combinations
 */
contract DecimalEncoder is IAttributeEncoder {
    
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure override returns (string memory) {
        require(a < 10 && b < 10 && c < 10 && d < 10, "Values must be < 10");
        
        bytes memory result = new bytes(4);
        result[0] = bytes1(uint8(48 + a));
        result[1] = bytes1(uint8(48 + b));
        result[2] = bytes1(uint8(48 + c));
        result[3] = bytes1(uint8(48 + d));
        
        return string(result);
    }
    
    function decode(string memory code) external pure override returns (uint8 a, uint8 b, uint8 c, uint8 d) {
        bytes memory b = bytes(code);
        require(b.length == 4, "Must be 4 digits");
        
        a = uint8(b[0]) - 48;
        b = uint8(b[1]) - 48;
        c = uint8(b[2]) - 48;
        d = uint8(b[3]) - 48;
        
        require(a < 10 && b < 10 && c < 10 && d < 10, "Invalid decimal");
    }
    
    function getMaxValue() external pure override returns (uint256) {
        return 9999;
    }
    
    function getBase() external pure override returns (uint8) {
        return 10;
    }
}

/**
 * @title HexEncoder
 * @notice 4-digit hexadecimal encoding (0000-FFFF)
 * @dev 16^4 = 65,536 combinations
 */
contract HexEncoder is IAttributeEncoder {
    
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure override returns (string memory) {
        require(a < 16 && b < 16 && c < 16 && d < 16, "Values must be < 16");
        
        bytes memory result = new bytes(4);
        result[0] = toHexChar(a);
        result[1] = toHexChar(b);
        result[2] = toHexChar(c);
        result[3] = toHexChar(d);
        
        return string(result);
    }
    
    function decode(string memory code) external pure override returns (uint8 a, uint8 b, uint8 c, uint8 d) {
        bytes memory b = bytes(code);
        require(b.length == 4, "Must be 4 hex digits");
        
        a = fromHexChar(b[0]);
        b = fromHexChar(b[1]);
        c = fromHexChar(b[2]);
        d = fromHexChar(b[3]);
    }
    
    function toHexChar(uint8 value) private pure returns (bytes1) {
        if (value < 10) return bytes1(uint8(48 + value)); // 0-9
        return bytes1(uint8(55 + value)); // A-F (65-70)
    }
    
    function fromHexChar(bytes1 char) private pure returns (uint8) {
        uint8 c = uint8(char);
        if (c >= 48 && c <= 57) return c - 48; // 0-9
        if (c >= 65 && c <= 70) return c - 55; // A-F
        if (c >= 97 && c <= 102) return c - 87; // a-f
        revert("Invalid hex character");
    }
    
    function getMaxValue() external pure override returns (uint256) {
        return 65535; // 0xFFFF
    }
    
    function getBase() external pure override returns (uint8) {
        return 16;
    }
}

/**
 * @title OctalEncoder
 * @notice 4-digit octal encoding (0000-7777)
 * @dev 8^4 = 4,096 combinations
 */
contract OctalEncoder is IAttributeEncoder {
    
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure override returns (string memory) {
        require(a < 8 && b < 8 && c < 8 && d < 8, "Values must be < 8");
        
        bytes memory result = new bytes(4);
        result[0] = bytes1(uint8(48 + a));
        result[1] = bytes1(uint8(48 + b));
        result[2] = bytes1(uint8(48 + c));
        result[3] = bytes1(uint8(48 + d));
        
        return string(result);
    }
    
    function decode(string memory code) external pure override returns (uint8 a, uint8 b, uint8 c, uint8 d) {
        bytes memory b = bytes(code);
        require(b.length == 4, "Must be 4 digits");
        
        a = uint8(b[0]) - 48;
        b = uint8(b[1]) - 48;
        c = uint8(b[2]) - 48;
        d = uint8(b[3]) - 48;
        
        require(a < 8 && b < 8 && c < 8 && d < 8, "Invalid octal");
    }
    
    function getMaxValue() external pure override returns (uint256) {
        return 4095; // 7777 in octal
    }
    
    function getBase() external pure override returns (uint8) {
        return 8;
    }
}

/**
 * @title Base64Encoder
 * @notice 3-character Base64 encoding
 * @dev 64^3 = 262,144 combinations!
 */
contract Base64Encoder is IAttributeEncoder {
    
    string private constant BASE64_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure override returns (string memory) {
        require(a < 64 && b < 64 && c < 64 && d < 16, "Values out of range");
        
        // Combine into single value (d is limited to 16 to fit in 3 chars)
        uint24 value = uint24(a) << 10 | uint24(b) << 4 | uint24(d);
        
        bytes memory result = new bytes(3);
        result[0] = bytes(BASE64_CHARS)[value >> 12];
        result[1] = bytes(BASE64_CHARS)[(value >> 6) & 0x3F];
        result[2] = bytes(BASE64_CHARS)[value & 0x3F];
        
        return string(result);
    }
    
    function decode(string memory code) external pure override returns (uint8 a, uint8 b, uint8 c, uint8 d) {
        bytes memory b = bytes(code);
        require(b.length == 3, "Must be 3 base64 chars");
        
        uint24 value = uint24(indexOf(b[0])) << 12 | 
                       uint24(indexOf(b[1])) << 6 | 
                       uint24(indexOf(b[2]));
        
        a = uint8(value >> 10);
        b = uint8((value >> 4) & 0x3F);
        c = 0; // Not used in 3-char encoding
        d = uint8(value & 0xF);
    }
    
    function indexOf(bytes1 char) private pure returns (uint8) {
        bytes memory chars = bytes(BASE64_CHARS);
        for (uint8 i = 0; i < chars.length; i++) {
            if (chars[i] == char) return i;
        }
        revert("Invalid base64 character");
    }
    
    function getMaxValue() external pure override returns (uint256) {
        return 262143; // 64^3 - 1
    }
    
    function getBase() external pure override returns (uint8) {
        return 64;
    }
}

/**
 * @title BinaryEncoder
 * @notice 16-bit binary encoding
 * @dev 2^16 = 65,536 combinations (same as HEX)
 */
contract BinaryEncoder is IAttributeEncoder {
    
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure override returns (string memory) {
        require(a < 16 && b < 16 && c < 16 && d < 16, "Values must be < 16");
        
        uint16 value = uint16(a) << 12 | uint16(b) << 8 | uint16(c) << 4 | uint16(d);
        
        bytes memory result = new bytes(16);
        for (uint8 i = 0; i < 16; i++) {
            result[i] = ((value >> (15 - i)) & 1) == 1 ? '1' : '0';
        }
        
        return string(result);
    }
    
    function decode(string memory code) external pure override returns (uint8 a, uint8 b, uint8 c, uint8 d) {
        bytes memory b = bytes(code);
        require(b.length == 16, "Must be 16 bits");
        
        uint16 value = 0;
        for (uint8 i = 0; i < 16; i++) {
            if (b[i] == '1') {
                value |= uint16(1) << (15 - i);
            } else if (b[i] != '0') {
                revert("Invalid binary character");
            }
        }
        
        a = uint8(value >> 12);
        b = uint8((value >> 8) & 0xF);
        c = uint8((value >> 4) & 0xF);
        d = uint8(value & 0xF);
    }
    
    function getMaxValue() external pure override returns (uint256) {
        return 65535;
    }
    
    function getBase() external pure override returns (uint8) {
        return 2;
    }
}