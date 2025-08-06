// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../libraries/Base64.sol";

// Interfaces for material banks
interface IMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

interface IItemBank {
    function getItemSVG(uint8 id) external view returns (string memory);
}

/**
 * @title TragedyArweaveComposerV2
 * @notice Enhanced SVG composer with Base64 encoding and optimized gas usage
 * @dev Implements the hybrid Arweave approach with hue rotation filters
 */
contract TragedyArweaveComposerV2 {
    
    // Arweave URLs for backgrounds
    mapping(uint8 => string) public backgroundUrls;
    
    // Arweave URLs for effects  
    mapping(uint8 => string) public effectUrls;
    
    // Filter parameters for each background theme
    struct FilterParams {
        uint16 hueRotate;    // 0-360 degrees
        uint16 saturate;     // Multiplied by 100 (150 = 1.5)
        uint16 brightness;   // Multiplied by 100 (120 = 1.2)
    }
    
    mapping(uint8 => FilterParams) public filterParams;
    
    // Material banks
    IMonsterBank public immutable monsterBank;
    IItemBank public immutable itemBank;
    
    // Owner for configuration
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(address _monsterBank, address _itemBank) {
        monsterBank = IMonsterBank(_monsterBank);
        itemBank = IItemBank(_itemBank);
        owner = msg.sender;
        
        // Initialize default filter parameters
        _initializeFilterParams();
    }
    
    /**
     * @notice Initialize default filter parameters
     */
    function _initializeFilterParams() private {
        filterParams[0] = FilterParams(0, 150, 120);     // Bloodmoon
        filterParams[1] = FilterParams(240, 130, 90);    // Abyss
        filterParams[2] = FilterParams(80, 120, 95);     // Decay
        filterParams[3] = FilterParams(280, 140, 100);   // Corruption
        filterParams[4] = FilterParams(120, 180, 110);   // Venom
        filterParams[5] = FilterParams(0, 20, 70);       // Void
        filterParams[6] = FilterParams(20, 160, 120);    // Inferno
        filterParams[7] = FilterParams(200, 140, 120);   // Frost
        filterParams[8] = FilterParams(15, 130, 85);     // Ragnarok
        filterParams[9] = FilterParams(220, 50, 60);     // Shadow
    }
    
    /**
     * @notice Set Arweave URL for a background
     */
    function setBackgroundUrl(uint8 id, string calldata url) external onlyOwner {
        require(id < 10, "Invalid ID");
        backgroundUrls[id] = url;
    }
    
    /**
     * @notice Set Arweave URL for an effect
     */
    function setEffectUrl(uint8 id, string calldata url) external onlyOwner {
        require(id < 10, "Invalid ID");
        effectUrls[id] = url;
    }
    
    /**
     * @notice Update filter parameters
     */
    function setFilterParams(
        uint8 id, 
        uint16 hueRotate, 
        uint16 saturate, 
        uint16 brightness
    ) external onlyOwner {
        require(id < 10, "Invalid ID");
        filterParams[id] = FilterParams(hueRotate, saturate, brightness);
    }
    
    /**
     * @notice Extract SVG content between tags
     */
    function extractSVGContent(string memory svg) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        uint256 start = 0;
        uint256 end = svgBytes.length;
        
        // Find first '>'
        for (uint256 i = 0; i < svgBytes.length && start == 0; i++) {
            if (svgBytes[i] == '>') {
                start = i + 1;
            }
        }
        
        // Find '</svg'
        for (uint256 i = svgBytes.length - 5; i > start; i--) {
            if (svgBytes[i] == '<' && 
                svgBytes[i+1] == '/' && 
                svgBytes[i+2] == 's' && 
                svgBytes[i+3] == 'v' && 
                svgBytes[i+4] == 'g') {
                end = i;
                break;
            }
        }
        
        // Extract content
        bytes memory content = new bytes(end - start);
        for (uint256 i = 0; i < content.length; i++) {
            content[i] = svgBytes[start + i];
        }
        
        return string(content);
    }
    
    /**
     * @notice Convert SVG to base64 data URI
     */
    function svgToBase64DataUri(string memory svg) internal pure returns (string memory) {
        string memory svgContent = extractSVGContent(svg);
        bytes memory svgBytes = bytes(svgContent);
        string memory base64Svg = Base64.encode(svgBytes);
        return string(abi.encodePacked("data:image/svg+xml;base64,", base64Svg));
    }
    
    /**
     * @notice Compose the final SVG
     */
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        // Create filter ID
        string memory filterId = string(abi.encodePacked("f", uint2str(background)));
        
        // Build SVG parts efficiently
        bytes memory svg = abi.encodePacked(
            '<svg width="240" height="240" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">',
            _generateFilterDef(background, filterId)
        );
        
        // Add background layer
        string memory bgUrl = backgroundUrls[background];
        if (bytes(bgUrl).length > 0) {
            svg = abi.encodePacked(svg, 
                '<image href="', bgUrl, '" x="0" y="0" width="24" height="24"/>'
            );
        }
        
        // Add monster layer with filter
        string memory monsterSvg = monsterBank.getSpeciesSVG(species);
        string memory monsterDataUri = svgToBase64DataUri(monsterSvg);
        svg = abi.encodePacked(svg,
            '<image href="', monsterDataUri, 
            '" x="0" y="0" width="24" height="24" filter="url(#', filterId, ')"/>'
        );
        
        // Add item layer
        string memory itemSvg = itemBank.getItemSVG(item);
        string memory itemDataUri = svgToBase64DataUri(itemSvg);
        svg = abi.encodePacked(svg,
            '<image href="', itemDataUri, '" x="0" y="0" width="24" height="24"/>'
        );
        
        // Add effect layer
        string memory effectUrl = effectUrls[effect];
        if (bytes(effectUrl).length > 0) {
            svg = abi.encodePacked(svg,
                '<image href="', effectUrl, '" x="0" y="0" width="24" height="24"/>'
            );
        }
        
        svg = abi.encodePacked(svg, '</svg>');
        
        return string(svg);
    }
    
    /**
     * @notice Generate filter definition
     */
    function _generateFilterDef(uint8 background, string memory filterId) 
        private view returns (string memory) 
    {
        FilterParams memory params = filterParams[background];
        
        return string(abi.encodePacked(
            '<defs><filter id="', filterId, '">',
            '<feColorMatrix type="hueRotate" values="', uint2str(params.hueRotate), '"/>',
            '<feColorMatrix type="saturate" values="', _formatDecimal(params.saturate), '"/>',
            '<feComponentTransfer>',
            '<feFuncR type="linear" slope="', _formatDecimal(params.brightness), '"/>',
            '<feFuncG type="linear" slope="', _formatDecimal(params.brightness), '"/>',
            '<feFuncB type="linear" slope="', _formatDecimal(params.brightness), '"/>',
            '</feComponentTransfer>',
            '</filter></defs>'
        ));
    }
    
    /**
     * @notice Format number as decimal (e.g., 150 -> "1.5")
     */
    function _formatDecimal(uint256 value) private pure returns (string memory) {
        if (value == 100) return "1";
        if (value < 100) {
            if (value < 10) {
                return string(abi.encodePacked("0.0", uint2str(value)));
            }
            return string(abi.encodePacked("0.", uint2str(value)));
        }
        
        uint256 whole = value / 100;
        uint256 decimal = value % 100;
        
        if (decimal == 0) {
            return uint2str(whole);
        } else if (decimal < 10) {
            return string(abi.encodePacked(uint2str(whole), ".0", uint2str(decimal)));
        } else {
            return string(abi.encodePacked(uint2str(whole), ".", uint2str(decimal)));
        }
    }
    
    /**
     * @notice Convert uint to string
     */
    function uint2str(uint256 _i) private pure returns (string memory) {
        if (_i == 0) return "0";
        
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}