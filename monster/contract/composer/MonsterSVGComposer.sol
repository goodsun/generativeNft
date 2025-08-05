// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ISVGComposer.sol";
import "../bank/MaterialBank.sol";

/**
 * @title MonsterSVGComposer
 * @notice Composes Monster SVG images from MaterialBank
 * @dev Handles all SVG assembly logic
 */
contract MonsterSVGComposer is ISVGComposer {
    
    IMaterialBank public immutable materialBank;
    
    constructor(address _materialBank) {
        materialBank = IMaterialBank(_materialBank);
    }
    
    /**
     * @notice Compose complete SVG image
     */
    function composeSVG(
        uint8 backgroundId,
        uint8 characterId,
        uint8 itemId,
        uint8 effectId
    ) external view override returns (string memory) {
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">';
        
        // Add background
        svg = string(abi.encodePacked(svg, composeBackground(backgroundId)));
        
        // Add character and item with scaling
        svg = string(abi.encodePacked(
            svg,
            '<g transform="scale(10)">',
            composeCharacter(characterId),
            composeItem(itemId),
            '</g>'
        ));
        
        // Add effect overlay
        svg = string(abi.encodePacked(svg, composeEffect(effectId)));
        
        svg = string(abi.encodePacked(svg, '</svg>'));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    /**
     * @notice Compose background layer
     */
    function composeBackground(uint8 id) public view override returns (string memory) {
        if (materialBank.isMaterialExists(IMaterialBank.MaterialType.BACKGROUND, id)) {
            return materialBank.getMaterial(IMaterialBank.MaterialType.BACKGROUND, id);
        }
        // Default background
        return '<rect width="240" height="240" fill="#1a1a1a"/>';
    }
    
    /**
     * @notice Compose character layer
     */
    function composeCharacter(uint8 id) public view override returns (string memory) {
        if (materialBank.isMaterialExists(IMaterialBank.MaterialType.SPECIES, id)) {
            return materialBank.getMaterial(IMaterialBank.MaterialType.SPECIES, id);
        }
        // Placeholder character
        return '<circle cx="12" cy="12" r="8" fill="#666"/>';
    }
    
    /**
     * @notice Compose item layer with positioning
     */
    function composeItem(uint8 id) public view override returns (string memory) {
        if (!materialBank.isMaterialExists(IMaterialBank.MaterialType.EQUIPMENT, id)) {
            return '';
        }
        
        string memory item = materialBank.getMaterial(IMaterialBank.MaterialType.EQUIPMENT, id);
        
        // Apply item-specific positioning
        if (id == 0) { // Crown - position on head
            return string(abi.encodePacked(
                '<g transform="translate(0, -2)">',
                item,
                '</g>'
            ));
        } else if (id == 1 || id == 6) { // Sword/Scythe - position in hand
            return string(abi.encodePacked(
                '<g transform="translate(2, 0)">',
                item,
                '</g>'
            ));
        }
        
        return item;
    }
    
    /**
     * @notice Compose effect overlay
     */
    function composeEffect(uint8 id) public view override returns (string memory) {
        if (materialBank.isMaterialExists(IMaterialBank.MaterialType.EFFECT, id)) {
            return materialBank.getMaterial(IMaterialBank.MaterialType.EFFECT, id);
        }
        return '';
    }
}

/**
 * @title AdvancedSVGComposer
 * @notice Advanced SVG composition with layering and effects
 */
contract AdvancedSVGComposer is MonsterSVGComposer {
    
    constructor(address _materialBank) MonsterSVGComposer(_materialBank) {}
    
    /**
     * @notice Compose with custom layering
     */
    function composeLayeredSVG(
        uint8[] memory layers,
        uint8[] memory ids,
        string[] memory transforms
    ) external view returns (string memory) {
        require(layers.length == ids.length && layers.length == transforms.length, "Array mismatch");
        
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">';
        
        for (uint i = 0; i < layers.length; i++) {
            string memory element = '';
            
            if (layers[i] == 0) {
                element = composeBackground(ids[i]);
            } else if (layers[i] == 1) {
                element = composeCharacter(ids[i]);
            } else if (layers[i] == 2) {
                element = composeItem(ids[i]);
            } else if (layers[i] == 3) {
                element = composeEffect(ids[i]);
            }
            
            if (bytes(element).length > 0 && bytes(transforms[i]).length > 0) {
                svg = string(abi.encodePacked(
                    svg,
                    '<g transform="', transforms[i], '">',
                    element,
                    '</g>'
                ));
            } else {
                svg = string(abi.encodePacked(svg, element));
            }
        }
        
        svg = string(abi.encodePacked(svg, '</svg>'));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    /**
     * @notice Apply color filter to SVG
     */
    function applyColorFilter(
        string memory svg,
        string memory filterColor
    ) external pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">',
            '<defs>',
                '<filter id="colorize">',
                    '<feFlood flood-color="', filterColor, '" flood-opacity="0.5"/>',
                    '<feComposite in2="SourceGraphic" operator="multiply"/>',
                '</filter>',
            '</defs>',
            '<g filter="url(#colorize)">',
            svg,
            '</g>',
            '</svg>'
        ));
    }
}