// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Bank interfaces
interface IMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

interface IBackgroundBank {
    function getBackgroundSVG(uint8 id) external view returns (string memory);
}

interface IItemBank {
    function getItemSVG(uint8 id) external view returns (string memory);
}

interface IEffectBank {
    function getEffectSVG(uint8 id) external view returns (string memory);
}

/**
 * @title TragedyModularSVGComposerV2
 * @notice Composes final SVG from modular banks with proper SVG tag handling
 */
contract TragedyModularSVGComposerV2 {
    // Bank addresses
    IMonsterBank public monsterBank;
    IBackgroundBank public backgroundBank;
    IItemBank public itemBank;
    IEffectBank public effectBank;
    
    constructor(
        address _monsterBank,
        address _backgroundBank,
        address _itemBank,
        address _effectBank
    ) {
        monsterBank = IMonsterBank(_monsterBank);
        backgroundBank = IBackgroundBank(_backgroundBank);
        itemBank = IItemBank(_itemBank);
        effectBank = IEffectBank(_effectBank);
    }
    
    /**
     * @notice Compose a complete NFT SVG from individual components
     * @param species Monster type (0-9)
     * @param background Background type (0-9)
     * @param item Item type (0-9)
     * @param effect Effect type (0-11)
     * @return Complete SVG as string
     */
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        // Get individual SVGs
        string memory bgSVG = backgroundBank.getBackgroundSVG(background);
        string memory monsterSVG = monsterBank.getSpeciesSVG(species);
        string memory itemSVG = itemBank.getItemSVG(item);
        string memory effectSVG = effectBank.getEffectSVG(effect);
        
        // Extract inner content from each SVG
        string memory bgContent = extractContent(bgSVG);
        string memory monsterContent = extractContent(monsterSVG);
        string memory itemContent = extractContent(itemSVG);
        string memory effectContent = extractContent(effectSVG);
        
        // Compose final SVG with proper layering
        return string(abi.encodePacked(
            '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">',
            bgContent,      // Background layer
            monsterContent, // Monster layer
            itemContent,    // Item layer
            effectContent,  // Effect layer
            '</svg>'
        ));
    }
    
    /**
     * @notice Extract inner content from SVG string
     * @dev Finds the first '>' and last '<' to extract content between SVG tags
     */
    function extractContent(string memory svg) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        uint256 startPos = 0;
        uint256 endPos = svgBytes.length;
        
        // Find first '>' (end of opening tag)
        for (uint256 i = 0; i < svgBytes.length; i++) {
            if (svgBytes[i] == '>') {
                startPos = i + 1;
                break;
            }
        }
        
        // Find last '<' (start of closing tag)
        for (uint256 i = svgBytes.length - 1; i > startPos; i--) {
            if (svgBytes[i] == '<' && i + 5 < svgBytes.length) {
                // Check if it's </svg>
                if (svgBytes[i + 1] == '/' && 
                    svgBytes[i + 2] == 's' && 
                    svgBytes[i + 3] == 'v' && 
                    svgBytes[i + 4] == 'g') {
                    endPos = i;
                    break;
                }
            }
        }
        
        // Extract content
        uint256 contentLength = endPos - startPos;
        bytes memory content = new bytes(contentLength);
        for (uint256 i = 0; i < contentLength; i++) {
            content[i] = svgBytes[startPos + i];
        }
        
        return string(content);
    }
    
    /**
     * @notice Compose SVG with optional components
     */
    function composeOptionalSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        string memory result = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">';
        
        // Add background if specified (255 = none)
        if (background != 255) {
            string memory bgSVG = backgroundBank.getBackgroundSVG(background);
            result = string(abi.encodePacked(result, extractContent(bgSVG)));
        }
        
        // Always add monster
        string memory monsterSVG = monsterBank.getSpeciesSVG(species);
        result = string(abi.encodePacked(result, extractContent(monsterSVG)));
        
        // Add item if specified
        if (item != 255) {
            string memory itemSVG = itemBank.getItemSVG(item);
            result = string(abi.encodePacked(result, extractContent(itemSVG)));
        }
        
        // Add effect if specified
        if (effect != 255) {
            string memory effectSVG = effectBank.getEffectSVG(effect);
            result = string(abi.encodePacked(result, extractContent(effectSVG)));
        }
        
        return string(abi.encodePacked(result, '</svg>'));
    }
    
    /**
     * @notice Test function to verify content extraction
     */
    function testExtractContent(string memory svg) external pure returns (string memory) {
        return extractContent(svg);
    }
}