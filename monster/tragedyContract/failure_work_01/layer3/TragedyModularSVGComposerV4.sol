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
 * @title TragedyModularSVGComposerV4
 * @notice Fixed composer with proper SVG content extraction
 */
contract TragedyModularSVGComposerV4 {
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
     * @notice Extract content between SVG tags
     */
    function extractSVGContent(string memory svg) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        
        // Find first '>'
        uint256 startPos = 0;
        for (uint256 i = 0; i < svgBytes.length; i++) {
            if (svgBytes[i] == '>') {
                startPos = i + 1;
                break;
            }
        }
        
        // Find '</svg'
        uint256 endPos = svgBytes.length;
        for (uint256 i = svgBytes.length - 6; i > startPos; i--) {
            if (svgBytes[i] == '<' && 
                svgBytes[i + 1] == '/' &&
                svgBytes[i + 2] == 's' &&
                svgBytes[i + 3] == 'v' &&
                svgBytes[i + 4] == 'g' &&
                svgBytes[i + 5] == '>') {
                endPos = i;
                break;
            }
        }
        
        // Create result
        bytes memory result = new bytes(endPos - startPos);
        for (uint256 i = 0; i < endPos - startPos; i++) {
            result[i] = svgBytes[startPos + i];
        }
        
        return string(result);
    }
    
    /**
     * @notice Compose complete SVG
     */
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        // Get all SVGs
        string memory bgSVG = backgroundBank.getBackgroundSVG(background);
        string memory monsterSVG = monsterBank.getSpeciesSVG(species);
        string memory itemSVG = itemBank.getItemSVG(item);
        string memory effectSVG = effectBank.getEffectSVG(effect);
        
        // Extract content from each
        string memory bgContent = extractSVGContent(bgSVG);
        string memory monsterContent = extractSVGContent(monsterSVG);
        string memory itemContent = extractSVGContent(itemSVG);
        string memory effectContent = extractSVGContent(effectSVG);
        
        // Combine
        return string(abi.encodePacked(
            '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">',
            bgContent,
            monsterContent,
            itemContent,
            effectContent,
            '</svg>'
        ));
    }
    
    /**
     * @notice Test extraction function
     */
    function testExtract(string memory svg) external pure returns (string memory) {
        return extractSVGContent(svg);
    }
}