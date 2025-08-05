// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/access/Ownable.sol";

/**
 * @title MonsterSVGStorage
 * @notice Efficient on-chain storage for Monster NFT SVG parts
 * @dev Uses packed structs and color palettes for gas optimization
 */
contract MonsterSVGStorage is Ownable {
    
    // Rect structure for pixel art (packed into single slot)
    struct Rect {
        uint8 x;
        uint8 y;
        uint8 width;
        uint8 height;
        uint8 colorIndex; // Index into color palette
        uint8 opacity;    // 0-100 (percent)
    }
    
    // Color palette (global for all assets)
    uint24[] public colorPalette;
    
    // Monster parts (10 monsters)
    mapping(uint8 => Rect[]) public monsterRects;
    mapping(uint8 => string) public monsterNames;
    
    // Item parts (12 items) 
    mapping(uint8 => Rect[]) public itemRects;
    mapping(uint8 => string) public itemNames;
    
    // Background SVG data (more complex)
    mapping(uint8 => string) public backgroundSVGs;
    mapping(uint8 => string) public backgroundNames;
    
    // Effect SVG data (with animations)
    mapping(uint8 => string) public effectSVGs;
    mapping(uint8 => string) public effectNames;
    
    // Events
    event ColorAdded(uint256 index, uint24 color);
    event MonsterAdded(uint8 id, string name, uint256 rectCount);
    event ItemAdded(uint8 id, string name, uint256 rectCount);
    event BackgroundAdded(uint8 id, string name);
    event EffectAdded(uint8 id, string name);
    
    constructor() {
        _initializeColorPalette();
    }
    
    /**
     * @notice Initialize common color palette
     */
    function _initializeColorPalette() private {
        // Common colors used across all assets
        colorPalette.push(0x000000); // 0: Black
        colorPalette.push(0xFFFFFF); // 1: White
        colorPalette.push(0xFF0000); // 2: Red
        colorPalette.push(0x00FF00); // 3: Green
        colorPalette.push(0x0000FF); // 4: Blue
        colorPalette.push(0xFFFF00); // 5: Yellow
        colorPalette.push(0xFF00FF); // 6: Magenta
        colorPalette.push(0x00FFFF); // 7: Cyan
        colorPalette.push(0x808080); // 8: Gray
        colorPalette.push(0xC0C0C0); // 9: Silver
        colorPalette.push(0x800000); // 10: Maroon
        colorPalette.push(0x808000); // 11: Olive
        colorPalette.push(0x008000); // 12: Dark Green
        colorPalette.push(0x008080); // 13: Teal
        colorPalette.push(0x000080); // 14: Navy
        colorPalette.push(0x800080); // 15: Purple
        // Add more colors as needed
    }
    
    /**
     * @notice Add color to palette
     */
    function addColor(uint24 color) external onlyOwner returns (uint256) {
        colorPalette.push(color);
        uint256 index = colorPalette.length - 1;
        emit ColorAdded(index, color);
        return index;
    }
    
    /**
     * @notice Add monster SVG data
     */
    function addMonster(
        uint8 id,
        string memory name,
        Rect[] memory rects
    ) external onlyOwner {
        require(bytes(monsterNames[id]).length == 0, "Monster already exists");
        
        monsterNames[id] = name;
        for (uint i = 0; i < rects.length; i++) {
            monsterRects[id].push(rects[i]);
        }
        
        emit MonsterAdded(id, name, rects.length);
    }
    
    /**
     * @notice Add item SVG data
     */
    function addItem(
        uint8 id,
        string memory name,
        Rect[] memory rects
    ) external onlyOwner {
        require(bytes(itemNames[id]).length == 0, "Item already exists");
        
        itemNames[id] = name;
        for (uint i = 0; i < rects.length; i++) {
            itemRects[id].push(rects[i]);
        }
        
        emit ItemAdded(id, name, rects.length);
    }
    
    /**
     * @notice Add background SVG (stored as string due to complexity)
     */
    function addBackground(
        uint8 id,
        string memory name,
        string memory svgData
    ) external onlyOwner {
        require(bytes(backgroundNames[id]).length == 0, "Background already exists");
        
        backgroundNames[id] = name;
        backgroundSVGs[id] = svgData;
        
        emit BackgroundAdded(id, name);
    }
    
    /**
     * @notice Add effect SVG (stored as string due to animations)
     */
    function addEffect(
        uint8 id,
        string memory name,
        string memory svgData
    ) external onlyOwner {
        require(bytes(effectNames[id]).length == 0, "Effect already exists");
        
        effectNames[id] = name;
        effectSVGs[id] = svgData;
        
        emit EffectAdded(id, name);
    }
    
    /**
     * @notice Generate SVG from rects
     */
    function generateRectsAsSVG(Rect[] memory rects) public view returns (string memory) {
        string memory svg = '';
        
        for (uint i = 0; i < rects.length; i++) {
            Rect memory r = rects[i];
            uint24 color = colorPalette[r.colorIndex];
            
            svg = string(abi.encodePacked(
                svg,
                '<rect x="', uint2str(r.x), 
                '" y="', uint2str(r.y),
                '" width="', uint2str(r.width),
                '" height="', uint2str(r.height),
                '" fill="#', toHexString(color), '"'
            ));
            
            if (r.opacity < 100) {
                svg = string(abi.encodePacked(
                    svg,
                    ' opacity="', uint2str(r.opacity), '%"'
                ));
            }
            
            svg = string(abi.encodePacked(svg, '/>'));
        }
        
        return svg;
    }
    
    /**
     * @notice Get monster SVG
     */
    function getMonsterSVG(uint8 id) external view returns (string memory) {
        require(bytes(monsterNames[id]).length > 0, "Monster not found");
        
        return string(abi.encodePacked(
            '<g id="monster">',
            generateRectsAsSVG(monsterRects[id]),
            '</g>'
        ));
    }
    
    /**
     * @notice Get item SVG
     */
    function getItemSVG(uint8 id) external view returns (string memory) {
        require(bytes(itemNames[id]).length > 0, "Item not found");
        
        return string(abi.encodePacked(
            '<g id="item">',
            generateRectsAsSVG(itemRects[id]),
            '</g>'
        ));
    }
    
    /**
     * @notice Assemble complete SVG
     */
    function assembleSVG(
        uint8 backgroundId,
        uint8 monsterId,
        uint8 itemId,
        uint8 effectId
    ) external view returns (string memory) {
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">';
        
        // Add background
        if (bytes(backgroundNames[backgroundId]).length > 0) {
            svg = string(abi.encodePacked(svg, backgroundSVGs[backgroundId]));
        }
        
        // Scale and center the pixel art
        svg = string(abi.encodePacked(
            svg,
            '<g transform="scale(10) translate(0, 0)">'
        ));
        
        // Add monster
        if (bytes(monsterNames[monsterId]).length > 0) {
            svg = string(abi.encodePacked(
                svg,
                generateRectsAsSVG(monsterRects[monsterId])
            ));
        }
        
        // Add item
        if (bytes(itemNames[itemId]).length > 0) {
            svg = string(abi.encodePacked(
                svg,
                generateRectsAsSVG(itemRects[itemId])
            ));
        }
        
        svg = string(abi.encodePacked(svg, '</g>'));
        
        // Add effect overlay
        if (bytes(effectNames[effectId]).length > 0) {
            svg = string(abi.encodePacked(svg, effectSVGs[effectId]));
        }
        
        svg = string(abi.encodePacked(svg, '</svg>'));
        
        return svg;
    }
    
    // Utility functions
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
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
    
    function toHexString(uint24 value) internal pure returns (string memory) {
        bytes memory buffer = new bytes(6);
        for (uint256 i = 6; i > 0; i--) {
            uint8 digit = uint8(value & 0xF);
            buffer[i-1] = digit < 10 ? bytes1(uint8(48 + digit)) : bytes1(uint8(87 + digit));
            value >>= 4;
        }
        return string(buffer);
    }
}