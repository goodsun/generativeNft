// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./libraries/Base64.sol";

// Interfaces
interface IArweaveMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

interface IArweaveItemBank {
    function getItemSVG(uint8 id) external view returns (string memory);
}

interface IArweaveBackgroundBank {
    function getBackgroundUrl(uint8 id) external view returns (string memory);
}

interface IArweaveEffectBank {
    function getEffectUrl(uint8 id) external view returns (string memory);
}

/**
 * @title ArweaveTragedyComposerV2
 * @notice Fixed version that properly encodes complete SVGs to base64
 * @dev Implements the hybrid approach with hue rotation filters based on background themes
 */
contract ArweaveTragedyComposerV2 {
    
    // Bank contracts
    IArweaveMonsterBank public immutable monsterBank;
    IArweaveItemBank public immutable itemBank;
    IArweaveBackgroundBank public immutable backgroundBank;
    IArweaveEffectBank public immutable effectBank;
    
    // Filter parameters for each background theme
    struct FilterParams {
        uint16 hueRotate;    // 0-360 degrees
        uint16 saturate;     // Multiplied by 100 (150 = 1.5)
        uint16 brightness;   // Multiplied by 100 (120 = 1.2)
    }
    
    mapping(uint8 => FilterParams) public filterParams;
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(
        address _monsterBank,
        address _itemBank,
        address _backgroundBank,
        address _effectBank
    ) {
        monsterBank = IArweaveMonsterBank(_monsterBank);
        itemBank = IArweaveItemBank(_itemBank);
        backgroundBank = IArweaveBackgroundBank(_backgroundBank);
        effectBank = IArweaveEffectBank(_effectBank);
        owner = msg.sender;
        
        _initializeFilterParams();
    }
    
    function _initializeFilterParams() private {
        // Initialize filter parameters for each background
        filterParams[0] = FilterParams(0, 150, 120);     // Bloodmoon: enhanced red
        filterParams[1] = FilterParams(240, 130, 90);    // Abyss: deep blue-purple
        filterParams[2] = FilterParams(80, 120, 95);     // Decay: sickly yellow-green
        filterParams[3] = FilterParams(280, 140, 100);   // Corruption: purple
        filterParams[4] = FilterParams(120, 180, 110);   // Venom: bright green
        filterParams[5] = FilterParams(0, 20, 70);       // Void: desaturated dark
        filterParams[6] = FilterParams(20, 160, 120);    // Inferno: orange-red
        filterParams[7] = FilterParams(200, 140, 120);   // Frost: ice blue
        filterParams[8] = FilterParams(15, 130, 85);     // Ragnarok: dark red-orange
        filterParams[9] = FilterParams(220, 50, 60);     // Shadow: dark blue
    }
    
    /**
     * @notice Convert complete SVG to base64 data URI
     */
    function svgToBase64DataUri(string memory svg) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        string memory base64Svg = Base64.encode(svgBytes);
        return string(abi.encodePacked("data:image/svg+xml;base64,", base64Svg));
    }
    
    /**
     * @notice Main composition function - matches the expected interface
     */
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        // Create filter ID
        string memory filterId = string(abi.encodePacked("f", uint2str(background)));
        
        // Start building SVG
        bytes memory svg = abi.encodePacked(
            '<svg width="240" height="240" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">',
            _generateFilterDef(background, filterId)
        );
        
        // Layer 1: Background (from Arweave)
        string memory bgUrl = backgroundBank.getBackgroundUrl(background);
        svg = abi.encodePacked(svg, 
            '<image href="', bgUrl, '" x="0" y="0" width="24" height="24"/>'
        );
        
        // Layer 2: Monster with filter (from on-chain SVG)
        string memory monsterSvg = monsterBank.getSpeciesSVG(species);
        string memory monsterDataUri = svgToBase64DataUri(monsterSvg);
        svg = abi.encodePacked(svg,
            '<image href="', monsterDataUri, 
            '" x="0" y="0" width="24" height="24" filter="url(#', filterId, ')"/>'
        );
        
        // Layer 3: Item (from on-chain SVG)
        string memory itemSvg = itemBank.getItemSVG(item);
        string memory itemDataUri = svgToBase64DataUri(itemSvg);
        svg = abi.encodePacked(svg,
            '<image href="', itemDataUri, '" x="0" y="0" width="24" height="24"/>'
        );
        
        // Layer 4: Effect (from Arweave)
        string memory effectUrl = effectBank.getEffectUrl(effect);
        svg = abi.encodePacked(svg,
            '<image href="', effectUrl, '" x="0" y="0" width="24" height="24"/>'
        );
        
        svg = abi.encodePacked(svg, '</svg>');
        
        return string(svg);
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
     * @notice Format number as decimal (e.g., 150 -> "1.50")
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