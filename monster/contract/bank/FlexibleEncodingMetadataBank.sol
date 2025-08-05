// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "../encoder/IAttributeEncoder.sol";
import "../composer/ISVGComposer.sol";
import "../composer/ITextComposer.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title FlexibleEncodingMetadataBank
 * @notice MetadataBank that supports multiple encoding systems
 * @dev Can switch between DEC, HEX, OCT, BASE64, BIN
 */
contract FlexibleEncodingMetadataBank is IMetadataBank {
    using Strings for uint256;
    
    // Components
    IAttributeEncoder public encoder;
    ISVGComposer public immutable svgComposer;
    ITextComposer public immutable textComposer;
    
    // Configuration
    uint8 public maxAttributeValue;
    string public encodingType;
    
    // Events
    event EncoderChanged(address indexed newEncoder, string encodingType);
    
    constructor(
        address _encoder,
        address _svgComposer,
        address _textComposer,
        string memory _encodingType
    ) {
        encoder = IAttributeEncoder(_encoder);
        svgComposer = ISVGComposer(_svgComposer);
        textComposer = ITextComposer(_textComposer);
        encodingType = _encodingType;
        maxAttributeValue = encoder.getBase() - 1;
    }
    
    /**
     * @notice Update encoder (owner only in production)
     */
    function setEncoder(address _encoder, string memory _encodingType) external {
        encoder = IAttributeEncoder(_encoder);
        encodingType = _encodingType;
        maxAttributeValue = encoder.getBase() - 1;
        emit EncoderChanged(_encoder, _encodingType);
    }
    
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId <= encoder.getMaxValue(), "Invalid token ID");
        
        // Decode based on current encoding system
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        // Get encoded representation
        string memory code = encoder.encode(s, e, r, c);
        
        // Compose elements
        string memory name = string(abi.encodePacked(
            encodingType, " ", code, " #", tokenId.toString()
        ));
        string memory description = textComposer.composeDescription(s, e, r, c);
        string memory image = svgComposer.composeSVG(r, s, e, c);
        
        // Build metadata
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', image, '",',
            '"attributes":[',
                '{"trait_type":"Code","value":"', code, '"},',
                '{"trait_type":"Encoding","value":"', encodingType, '"},',
                '{"trait_type":"Species","value":"', s.toString(), '"},',
                '{"trait_type":"Equipment","value":"', e.toString(), '"},',
                '{"trait_type":"Realm","value":"', r.toString(), '"},',
                '{"trait_type":"Curse","value":"', c.toString(), '"}',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    function decodeTokenId(uint256 tokenId) public view returns (uint8 s, uint8 e, uint8 r, uint8 c) {
        // Different decoding based on max values
        uint8 base = encoder.getBase();
        
        if (base == 10) {
            // Decimal: 0000-9999
            s = uint8(tokenId / 1000);
            e = uint8((tokenId / 100) % 10);
            r = uint8((tokenId / 10) % 10);
            c = uint8(tokenId % 10);
        } else if (base == 16) {
            // Hex: 0000-FFFF
            s = uint8((tokenId >> 12) & 0xF);
            e = uint8((tokenId >> 8) & 0xF);
            r = uint8((tokenId >> 4) & 0xF);
            c = uint8(tokenId & 0xF);
        } else if (base == 8) {
            // Octal: 0000-7777
            s = uint8(tokenId / 512);      // 8^3
            e = uint8((tokenId / 64) % 8); // 8^2
            r = uint8((tokenId / 8) % 8);  // 8^1
            c = uint8(tokenId % 8);        // 8^0
        } else if (base == 64) {
            // Base64: more complex mapping
            s = uint8(tokenId / 4096) % 64;    // 64^2
            e = uint8((tokenId / 64) % 64);    // 64^1
            r = uint8(tokenId % 64);           // 64^0
            c = uint8((tokenId / 262144) % 4); // Limited to 4 for equipment
        } else {
            // Default: use modulo
            s = uint8(tokenId % base);
            e = uint8((tokenId / base) % base);
            r = uint8((tokenId / (base * base)) % base);
            c = uint8((tokenId / (base * base * base)) % base);
        }
    }
    
    function getMetadataCount() external view override returns (uint256) {
        return encoder.getMaxValue() + 1;
    }
    
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 maxValue = encoder.getMaxValue();
        return this.getMetadata(seed % (maxValue + 1));
    }
}

/**
 * @title MultiEncodingShowcase
 * @notice Showcase contract demonstrating all encoding systems
 */
contract MultiEncodingShowcase {
    
    struct EncodingInfo {
        string name;
        address encoder;
        uint256 maxCombinations;
        string example;
    }
    
    EncodingInfo[] public encodings;
    
    constructor() {
        // Deploy all encoders
        address dec = address(new DecimalEncoder());
        address hex = address(new HexEncoder());
        address oct = address(new OctalEncoder());
        address b64 = address(new Base64Encoder());
        address bin = address(new BinaryEncoder());
        
        // Register encodings
        encodings.push(EncodingInfo({
            name: "DECIMAL",
            encoder: dec,
            maxCombinations: 10000,
            example: "1234"
        }));
        
        encodings.push(EncodingInfo({
            name: "HEX",
            encoder: hex,
            maxCombinations: 65536,
            example: "DEAD"
        }));
        
        encodings.push(EncodingInfo({
            name: "OCTAL",
            encoder: oct,
            maxCombinations: 4096,
            example: "7531"
        }));
        
        encodings.push(EncodingInfo({
            name: "BASE64",
            encoder: b64,
            maxCombinations: 262144,
            example: "A+/"
        }));
        
        encodings.push(EncodingInfo({
            name: "BINARY",
            encoder: bin,
            maxCombinations: 65536,
            example: "1010110111001101"
        }));
    }
    
    /**
     * @notice Compare the same attributes in different encodings
     */
    function compareEncodings(uint8 a, uint8 b, uint8 c, uint8 d) external view returns (string[] memory) {
        string[] memory results = new string[](encodings.length);
        
        for (uint i = 0; i < encodings.length; i++) {
            try IAttributeEncoder(encodings[i].encoder).encode(a, b, c, d) returns (string memory code) {
                results[i] = string(abi.encodePacked(
                    encodings[i].name, ": ", code
                ));
            } catch {
                results[i] = string(abi.encodePacked(
                    encodings[i].name, ": (out of range)"
                ));
            }
        }
        
        return results;
    }
}