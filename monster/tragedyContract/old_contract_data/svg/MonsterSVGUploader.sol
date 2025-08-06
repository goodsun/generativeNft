// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MonsterSVGStorage.sol";

/**
 * @title MonsterSVGUploader
 * @notice Helper contract to upload SVG data in batches
 * @dev Converts SVG rect elements to packed structs
 */
contract MonsterSVGUploader {
    
    MonsterSVGStorage public immutable svgStorage;
    
    constructor(address _svgStorage) {
        svgStorage = MonsterSVGStorage(_svgStorage);
    }
    
    /**
     * @notice Upload demon monster data
     * @dev Example implementation - actual data would come from parsed SVG
     */
    function uploadDemon() external {
        MonsterSVGStorage.Rect[] memory rects = new MonsterSVGStorage.Rect[](5);
        
        // Example demon pixel data (simplified)
        // In reality, this would be parsed from the actual demon.svg file
        rects[0] = MonsterSVGStorage.Rect(8, 4, 8, 4, 2, 100);   // Red horns
        rects[1] = MonsterSVGStorage.Rect(10, 8, 4, 4, 0, 100);  // Black eyes
        rects[2] = MonsterSVGStorage.Rect(8, 12, 8, 6, 10, 100); // Maroon body
        rects[3] = MonsterSVGStorage.Rect(6, 18, 4, 2, 0, 100);  // Left foot
        rects[4] = MonsterSVGStorage.Rect(14, 18, 4, 2, 0, 100); // Right foot
        
        svgStorage.addMonster(0, "demon", rects);
    }
    
    /**
     * @notice Upload vampire monster data
     */
    function uploadVampire() external {
        MonsterSVGStorage.Rect[] memory rects = new MonsterSVGStorage.Rect[](6);
        
        // Vampire pixel data
        rects[0] = MonsterSVGStorage.Rect(10, 2, 4, 2, 0, 100);  // Black hair
        rects[1] = MonsterSVGStorage.Rect(8, 4, 8, 6, 1, 100);   // White face
        rects[2] = MonsterSVGStorage.Rect(10, 6, 4, 2, 2, 100);  // Red eyes
        rects[3] = MonsterSVGStorage.Rect(11, 9, 2, 1, 1, 100);  // Fangs
        rects[4] = MonsterSVGStorage.Rect(8, 10, 8, 8, 0, 100);  // Black cape
        rects[5] = MonsterSVGStorage.Rect(10, 18, 4, 2, 0, 100); // Feet
        
        svgStorage.addMonster(6, "vampire", rects);
    }
    
    /**
     * @notice Upload sword item data
     */
    function uploadSword() external {
        MonsterSVGStorage.Rect[] memory rects = new MonsterSVGStorage.Rect[](3);
        
        // Sword pixel data
        rects[0] = MonsterSVGStorage.Rect(11, 4, 2, 10, 9, 100);  // Silver blade
        rects[1] = MonsterSVGStorage.Rect(10, 14, 4, 2, 11, 100); // Gold guard
        rects[2] = MonsterSVGStorage.Rect(11, 16, 2, 4, 10, 100); // Brown handle
        
        svgStorage.addItem(1, "sword", rects);
    }
    
    /**
     * @notice Upload crown item data
     */
    function uploadCrown() external {
        MonsterSVGStorage.Rect[] memory rects = new MonsterSVGStorage.Rect[](4);
        
        // Crown pixel data
        rects[0] = MonsterSVGStorage.Rect(8, 2, 8, 2, 11, 100);  // Gold base
        rects[1] = MonsterSVGStorage.Rect(8, 0, 2, 2, 11, 100);  // Left peak
        rects[2] = MonsterSVGStorage.Rect(11, 0, 2, 2, 11, 100); // Center peak
        rects[3] = MonsterSVGStorage.Rect(14, 0, 2, 2, 11, 100); // Right peak
        
        svgStorage.addItem(0, "crown", rects);
    }
    
    /**
     * @notice Upload inferno background
     * @dev Complex backgrounds are stored as complete SVG strings
     */
    function uploadInfernoBackground() external {
        string memory svg = string(abi.encodePacked(
            '<defs>',
                '<radialGradient id="inferno">',
                    '<stop offset="0%" stop-color="#ff0000"/>',
                    '<stop offset="100%" stop-color="#800000"/>',
                '</radialGradient>',
            '</defs>',
            '<rect width="240" height="240" fill="url(#inferno)"/>',
            '<circle cx="120" cy="200" r="40" fill="#ff4500" opacity="0.6"/>',
            '<circle cx="60" cy="180" r="30" fill="#ff6347" opacity="0.5"/>',
            '<circle cx="180" cy="190" r="35" fill="#ff4500" opacity="0.5"/>'
        ));
        
        svgStorage.addBackground(6, "inferno", svg);
    }
    
    /**
     * @notice Upload lightning effect
     * @dev Effects include animations
     */
    function uploadLightningEffect() external {
        string memory svg = string(abi.encodePacked(
            '<g opacity="0.8">',
                '<path d="M120,0 L100,80 L140,80 L120,240" stroke="#ffff00" stroke-width="4" fill="none">',
                    '<animate attributeName="opacity" values="0;1;0" dur="0.5s" repeatCount="indefinite"/>',
                '</path>',
                '<path d="M80,40 L70,120 L90,120 L80,200" stroke="#ffffff" stroke-width="2" fill="none">',
                    '<animate attributeName="opacity" values="0;1;0" dur="0.7s" repeatCount="indefinite"/>',
                '</path>',
            '</g>'
        ));
        
        svgStorage.addEffect(1, "lightning", svg);
    }
    
    /**
     * @notice Batch upload multiple monsters
     */
    function batchUploadMonsters(
        uint8[] memory ids,
        string[] memory names,
        MonsterSVGStorage.Rect[][] memory rectsArray
    ) external {
        require(ids.length == names.length && ids.length == rectsArray.length, "Array length mismatch");
        
        for (uint i = 0; i < ids.length; i++) {
            svgStorage.addMonster(ids[i], names[i], rectsArray[i]);
        }
    }
}