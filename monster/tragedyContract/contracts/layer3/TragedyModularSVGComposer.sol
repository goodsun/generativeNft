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
 * @title TragedyModularSVGComposer
 * @notice Composes final SVG from modular banks (deployed version)
 */
contract TragedyModularSVGComposer {
    
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
        
        // Extract inner content from each SVG (remove outer <svg> tags)
        string memory bgContent = extractSVGContent(bgSVG);
        string memory monsterContent = extractSVGContent(monsterSVG);
        string memory itemContent = extractSVGContent(itemSVG);
        string memory effectContent = extractSVGContent(effectSVG);
        
        // Compose final SVG
        return string(abi.encodePacked(
            '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">',
            '<g id="background">', bgContent, '</g>',
            '<g id="monster">', monsterContent, '</g>',
            '<g id="item">', itemContent, '</g>',
            '<g id="effect">', effectContent, '</g>',
            '</svg>'
        ));
    }
    
    /**
     * @notice Compose SVG with optional components
     * @param species Monster type (0-9)
     * @param background Background type (0-9, 255 for none)
     * @param item Item type (0-9, 255 for none)
     * @param effect Effect type (0-11, 255 for none)
     */
    function composeOptionalSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        string memory result = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">';
        
        // Add background if specified
        if (background != 255) {
            string memory bgSVG = backgroundBank.getBackgroundSVG(background);
            result = string(abi.encodePacked(
                result,
                '<g id="background">', extractSVGContent(bgSVG), '</g>'
            ));
        }
        
        // Always add monster
        string memory monsterSVG = monsterBank.getSpeciesSVG(species);
        result = string(abi.encodePacked(
            result,
            '<g id="monster">', extractSVGContent(monsterSVG), '</g>'
        ));
        
        // Add item if specified
        if (item != 255) {
            string memory itemSVG = itemBank.getItemSVG(item);
            result = string(abi.encodePacked(
                result,
                '<g id="item">', extractSVGContent(itemSVG), '</g>'
            ));
        }
        
        // Add effect if specified
        if (effect != 255) {
            string memory effectSVG = effectBank.getEffectSVG(effect);
            result = string(abi.encodePacked(
                result,
                '<g id="effect">', extractSVGContent(effectSVG), '</g>'
            ));
        }
        
        return string(abi.encodePacked(result, '</svg>'));
    }
    
    /**
     * @notice Extract inner content from SVG (remove outer <svg> tags)
     * @dev This is a simplified version - in production, use a more robust parser
     */
    function extractSVGContent(string memory svg) internal pure returns (string memory) {
        // For now, return the full SVG as inner content
        // In a real implementation, you would parse and extract the inner elements
        return svg;
    }
    
    // Update bank addresses if needed
    function updateBanks(
        address _monsterBank,
        address _backgroundBank,
        address _itemBank,
        address _effectBank
    ) external {
        monsterBank = IMonsterBank(_monsterBank);
        backgroundBank = IBackgroundBank(_backgroundBank);
        itemBank = IItemBank(_itemBank);
        effectBank = IEffectBank(_effectBank);
    }
}