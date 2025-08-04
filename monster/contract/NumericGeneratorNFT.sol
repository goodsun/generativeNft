// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title NumericGeneratorNFT
 * @notice NFT that uses 4-digit decimal codes for attribute combinations
 * @dev Each digit (0-9) represents an attribute in a slot
 *      Example: 1234 = Species[1], Equipment[2], Realm[3], Curse[4]
 */
contract NumericGeneratorNFT is ERC721Enumerable {
    using Strings for uint256;
    
    address public immutable owner;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintFee = 0.01 ether;
    
    // Mode: 0 = sequential, 1 = random, 2 = predefined
    uint8 public generationMode;
    
    // For sequential mode
    uint16 public currentCode = 0;
    
    // For predefined mode
    uint16[] public predefinedCodes;
    uint256 public predefinedIndex;
    
    // Mapping tokenId to 4-digit code
    mapping(uint256 => uint16) public tokenCode;
    
    // Attribute names (10 options per slot)
    string[10] private slot1 = ["Dragon", "Wizard", "Warrior", "Beast", "Spirit", "Demon", "Angel", "Robot", "Alien", "Phoenix"];
    string[10] private slot2 = ["Sword", "Shield", "Staff", "Crown", "Ring", "Armor", "Wings", "Gun", "Book", "Orb"];
    string[10] private slot3 = ["Fire", "Water", "Earth", "Air", "Light", "Dark", "Chaos", "Order", "Time", "Space"];
    string[10] private slot4 = ["Burning", "Frozen", "Poison", "Blessed", "Cursed", "Electric", "Psychic", "Invisible", "Giant", "Tiny"];
    
    // Special combinations (4-digit code => special name)
    mapping(uint16 => string) public specialCombinations;
    
    constructor(uint8 _mode) ERC721("Numeric Generator", "NUMGEN") {
        owner = msg.sender;
        generationMode = _mode;
        
        // Register some special combinations
        specialCombinations[0000] = "Genesis";
        specialCombinations[9999] = "Omega";
        specialCombinations[1234] = "Sequential Master";
        specialCombinations[7777] = "Lucky Seven";
        specialCombinations[0150] = "Dragon Slayer"; // Dragon + Crown + Light + Blessed
    }
    
    /**
     * @notice Set predefined codes for controlled generation
     */
    function setPredefinedCodes(uint16[] memory codes) external {
        require(msg.sender == owner, "Only owner");
        require(generationMode == 2, "Not in predefined mode");
        predefinedCodes = codes;
        predefinedIndex = 0;
    }
    
    /**
     * @notice Mint with automatic code generation based on mode
     */
    function mint() public payable returns (uint256) {
        require(msg.value >= mintFee, "Insufficient fee");
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");
        
        uint256 tokenId = totalSupply() + 1;
        uint16 code = _generateCode(tokenId);
        
        require(code <= 9999, "Invalid code");
        
        tokenCode[tokenId] = code;
        _mint(msg.sender, tokenId);
        
        // Refund excess
        if (msg.value > mintFee) {
            payable(msg.sender).transfer(msg.value - mintFee);
        }
        
        return tokenId;
    }
    
    /**
     * @notice Mint with specific code (owner only)
     */
    function mintWithCode(address to, uint16 code) external returns (uint256) {
        require(msg.sender == owner, "Only owner");
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");
        require(code <= 9999, "Invalid code");
        
        uint256 tokenId = totalSupply() + 1;
        tokenCode[tokenId] = code;
        _mint(to, tokenId);
        
        return tokenId;
    }
    
    /**
     * @notice Generate code based on current mode
     */
    function _generateCode(uint256 tokenId) private returns (uint16) {
        if (generationMode == 0) {
            // Sequential: 0000, 0001, 0002...
            uint16 code = currentCode;
            currentCode++;
            if (currentCode > 9999) currentCode = 0;
            return code;
        } else if (generationMode == 1) {
            // Random based on tokenId and block data
            uint256 seed = uint256(keccak256(abi.encodePacked(
                tokenId, 
                block.timestamp, 
                block.prevrandao,
                msg.sender
            )));
            return uint16(seed % 10000);
        } else if (generationMode == 2) {
            // Predefined sequence
            require(predefinedIndex < predefinedCodes.length, "No more predefined codes");
            uint16 code = predefinedCodes[predefinedIndex];
            predefinedIndex++;
            return code;
        }
        
        revert("Invalid generation mode");
    }
    
    /**
     * @notice Decode 4-digit code into individual attributes
     */
    function decodeAttributes(uint16 code) public pure returns (
        uint8 attr1,
        uint8 attr2, 
        uint8 attr3,
        uint8 attr4
    ) {
        attr1 = uint8(code / 1000);
        attr2 = uint8((code / 100) % 10);
        attr3 = uint8((code / 10) % 10);
        attr4 = uint8(code % 10);
    }
    
    /**
     * @notice Get attribute names for a token
     */
    function getAttributeNames(uint256 tokenId) public view returns (
        string memory attr1,
        string memory attr2,
        string memory attr3,
        string memory attr4,
        string memory special
    ) {
        uint16 code = tokenCode[tokenId];
        (uint8 a1, uint8 a2, uint8 a3, uint8 a4) = decodeAttributes(code);
        
        attr1 = slot1[a1];
        attr2 = slot2[a2];
        attr3 = slot3[a3];
        attr4 = slot4[a4];
        special = specialCombinations[code];
    }
    
    /**
     * @notice Generate simple SVG based on code
     */
    function generateSVG(uint256 tokenId) public view returns (string memory) {
        uint16 code = tokenCode[tokenId];
        (uint8 a1, uint8 a2, uint8 a3, uint8 a4) = decodeAttributes(code);
        
        // Create unique colors based on attributes
        string memory bgColor = _generateColor(a1, a3);
        string memory fgColor = _generateColor(a2, a4);
        
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="#', bgColor, '"/>',
            '<text x="200" y="50" text-anchor="middle" font-size="24" fill="#', fgColor, '">',
            '#', tokenId.toString(),
            '</text>',
            '<text x="200" y="100" text-anchor="middle" font-size="48" font-weight="bold" fill="#', fgColor, '">',
            _formatCode(code),
            '</text>',
            _generatePattern(a1, a2, a3, a4, fgColor),
            '</svg>'
        ));
        
        return svg;
    }
    
    /**
     * @notice Generate visual pattern based on attributes
     */
    function _generatePattern(uint8 a1, uint8 a2, uint8 a3, uint8 a4, string memory color) 
        private 
        pure 
        returns (string memory) 
    {
        string memory pattern = '';
        
        // Create circles based on first attribute
        for (uint i = 0; i < a1 + 1; i++) {
            uint x = 50 + (i * 30);
            uint y = 200;
            pattern = string(abi.encodePacked(
                pattern,
                '<circle cx="', x.toString(), 
                '" cy="', y.toString(),
                '" r="15" fill="#', color, '" opacity="0.6"/>'
            ));
        }
        
        // Create rectangles based on second attribute  
        for (uint i = 0; i < a2 + 1; i++) {
            uint x = 50 + (i * 30);
            uint y = 250;
            pattern = string(abi.encodePacked(
                pattern,
                '<rect x="', x.toString(),
                '" y="', y.toString(), 
                '" width="20" height="20" fill="#', color, '" opacity="0.4"/>'
            ));
        }
        
        return pattern;
    }
    
    /**
     * @notice Format code as 4-digit string with leading zeros
     */
    function _formatCode(uint16 code) private pure returns (string memory) {
        if (code >= 1000) return code.toString();
        if (code >= 100) return string(abi.encodePacked("0", code.toString()));
        if (code >= 10) return string(abi.encodePacked("00", code.toString()));
        return string(abi.encodePacked("000", code.toString()));
    }
    
    /**
     * @notice Generate hex color from two attributes
     */
    function _generateColor(uint8 attr1, uint8 attr2) private pure returns (string memory) {
        uint256 r = (attr1 * 25) % 256;
        uint256 g = (attr2 * 25) % 256;
        uint256 b = ((attr1 + attr2) * 25) % 256;
        
        return string(abi.encodePacked(
            _toHexChar(r / 16), _toHexChar(r % 16),
            _toHexChar(g / 16), _toHexChar(g % 16),
            _toHexChar(b / 16), _toHexChar(b % 16)
        ));
    }
    
    function _toHexChar(uint256 value) private pure returns (bytes1) {
        if (value < 10) return bytes1(uint8(48 + value));
        return bytes1(uint8(87 + value));
    }
    
    /**
     * @notice Generate full metadata
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        
        uint16 code = tokenCode[tokenId];
        (string memory a1, string memory a2, string memory a3, string memory a4, string memory special) = getAttributeNames(tokenId);
        
        string memory name = bytes(special).length > 0 
            ? special 
            : string(abi.encodePacked("NUMGEN #", tokenId.toString()));
        
        string memory svg = generateSVG(tokenId);
        string memory svgBase64 = Base64.encode(bytes(svg));
        
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"4-digit code: ', _formatCode(code), '",',
            '"image":"data:image/svg+xml;base64,', svgBase64, '",',
            '"attributes":[',
                '{"trait_type":"Code","value":"', _formatCode(code), '"},',
                '{"trait_type":"Slot 1","value":"', a1, '"},',
                '{"trait_type":"Slot 2","value":"', a2, '"},',
                '{"trait_type":"Slot 3","value":"', a3, '"},',
                '{"trait_type":"Slot 4","value":"', a4, '"}',
                bytes(special).length > 0 
                    ? string(abi.encodePacked(',{"trait_type":"Special","value":"', special, '"}'))
                    : '',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    function _exists(uint256 tokenId) private view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
    
    function withdraw() external {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(address(this).balance);
    }
}