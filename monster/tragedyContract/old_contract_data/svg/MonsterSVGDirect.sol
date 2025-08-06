// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MonsterSVGDirect
 * @notice Direct SVG storage in Solidity - simpler approach
 * @dev All SVG data is hardcoded as strings
 */
contract MonsterSVGDirect {
    
    // Monster SVGs (24x24 pixel art)
    function getDemonSVG() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="demon">',
            '<rect x="8" y="4" width="8" height="4" fill="#ff0000"/>', // horns
            '<rect x="10" y="8" width="4" height="4" fill="#000000"/>', // eyes
            '<rect x="8" y="12" width="8" height="6" fill="#800000"/>', // body
            '<rect x="6" y="18" width="4" height="2" fill="#000000"/>', // left foot
            '<rect x="14" y="18" width="4" height="2" fill="#000000"/>', // right foot
            '<rect x="10" y="10" width="1" height="1" fill="#ff0000"/>', // left eye glow
            '<rect x="13" y="10" width="1" height="1" fill="#ff0000"/>', // right eye glow
            '</g>'
        ));
    }
    
    function getVampireSVG() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="vampire">',
            '<rect x="10" y="2" width="4" height="2" fill="#000000"/>', // hair
            '<rect x="8" y="4" width="8" height="6" fill="#ffffff"/>', // face
            '<rect x="10" y="6" width="1" height="1" fill="#ff0000"/>', // left eye
            '<rect x="13" y="6" width="1" height="1" fill="#ff0000"/>', // right eye
            '<rect x="11" y="9" width="2" height="1" fill="#ffffff"/>', // fangs
            '<rect x="8" y="10" width="8" height="8" fill="#000000"/>', // cape
            '<rect x="10" y="18" width="4" height="2" fill="#000000"/>', // feet
            '</g>'
        ));
    }
    
    function getDragonSVG() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="dragon">',
            '<rect x="6" y="6" width="12" height="8" fill="#008000"/>', // body
            '<rect x="4" y="8" width="2" height="4" fill="#008000"/>', // left wing
            '<rect x="18" y="8" width="2" height="4" fill="#008000"/>', // right wing
            '<rect x="8" y="4" width="8" height="4" fill="#00ff00"/>', // head
            '<rect x="10" y="5" width="1" height="1" fill="#ff0000"/>', // left eye
            '<rect x="13" y="5" width="1" height="1" fill="#ff0000"/>', // right eye
            '<rect x="10" y="14" width="4" height="6" fill="#008000"/>', // tail
            '</g>'
        ));
    }
    
    // Item SVGs
    function getSwordSVG() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="sword">',
            '<rect x="11" y="4" width="2" height="10" fill="#c0c0c0"/>', // blade
            '<rect x="10" y="14" width="4" height="2" fill="#ffd700"/>', // guard
            '<rect x="11" y="16" width="2" height="4" fill="#8b4513"/>', // handle
            '</g>'
        ));
    }
    
    function getCrownSVG() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="crown">',
            '<rect x="8" y="2" width="8" height="2" fill="#ffd700"/>', // base
            '<rect x="8" y="0" width="2" height="2" fill="#ffd700"/>', // left peak
            '<rect x="11" y="0" width="2" height="2" fill="#ffd700"/>', // center peak
            '<rect x="14" y="0" width="2" height="2" fill="#ffd700"/>', // right peak
            '<rect x="11" y="1" width="2" height="1" fill="#ff0000"/>', // center gem
            '</g>'
        ));
    }
    
    function getShieldSVG() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="shield">',
            '<rect x="9" y="8" width="6" height="8" fill="#808080"/>', // shield body
            '<rect x="10" y="9" width="4" height="6" fill="#c0c0c0"/>', // inner shield
            '<rect x="11" y="10" width="2" height="4" fill="#ff0000"/>', // center stripe
            '</g>'
        ));
    }
    
    // Background SVGs (simplified)
    function getInfernoBackground() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<defs>',
                '<linearGradient id="inferno" x1="0%" y1="0%" x2="0%" y2="100%">',
                    '<stop offset="0%" style="stop-color:#ff4500;stop-opacity:1" />',
                    '<stop offset="100%" style="stop-color:#8b0000;stop-opacity:1" />',
                '</linearGradient>',
            '</defs>',
            '<rect width="240" height="240" fill="url(#inferno)"/>',
            '<circle cx="60" cy="180" r="30" fill="#ff6347" opacity="0.6">',
                '<animate attributeName="r" values="30;35;30" dur="3s" repeatCount="indefinite"/>',
            '</circle>',
            '<circle cx="180" cy="200" r="25" fill="#ff4500" opacity="0.5">',
                '<animate attributeName="r" values="25;30;25" dur="2s" repeatCount="indefinite"/>',
            '</circle>'
        ));
    }
    
    function getBloodmoonBackground() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect width="240" height="240" fill="#1a0000"/>',
            '<circle cx="120" cy="60" r="50" fill="#8b0000"/>',
            '<circle cx="120" cy="60" r="45" fill="#dc143c" opacity="0.8"/>'
        ));
    }
    
    // Effect SVGs
    function getLightningEffect() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g opacity="0.8">',
                '<path d="M120,0 L100,80 L140,80 L120,240" stroke="#ffff00" stroke-width="4" fill="none">',
                    '<animate attributeName="opacity" values="0;1;0" dur="0.5s" repeatCount="indefinite"/>',
                '</path>',
            '</g>'
        ));
    }
    
    function getBatsEffect() public pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="bats">',
                '<text x="40" y="40" font-size="20" fill="#000000">',
                    '<animateTransform attributeName="transform" type="translate" values="0,0; 20,-20; 0,0" dur="4s" repeatCount="indefinite"/>',
                    '🦇',
                '</text>',
                '<text x="160" y="60" font-size="16" fill="#000000">',
                    '<animateTransform attributeName="transform" type="translate" values="0,0; -20,-10; 0,0" dur="3s" repeatCount="indefinite"/>',
                    '🦇',
                '</text>',
            '</g>'
        ));
    }
    
    /**
     * @notice Get monster SVG by ID
     */
    function getMonsterSVG(uint8 id) public pure returns (string memory) {
        if (id == 0) return getDemonSVG();
        if (id == 1) return getDragonSVG();
        if (id == 6) return getVampireSVG();
        // Add more monsters...
        return "";
    }
    
    /**
     * @notice Get item SVG by ID
     */
    function getItemSVG(uint8 id) public pure returns (string memory) {
        if (id == 0) return getCrownSVG();
        if (id == 1) return getSwordSVG();
        if (id == 2) return getShieldSVG();
        // Add more items...
        return "";
    }
    
    /**
     * @notice Get background SVG by ID
     */
    function getBackgroundSVG(uint8 id) public pure returns (string memory) {
        if (id == 0) return getBloodmoonBackground();
        if (id == 6) return getInfernoBackground();
        // Add more backgrounds...
        return '<rect width="240" height="240" fill="#222222"/>'; // default
    }
    
    /**
     * @notice Get effect SVG by ID
     */
    function getEffectSVG(uint8 id) public pure returns (string memory) {
        if (id == 1) return getLightningEffect();
        if (id == 4) return getBatsEffect();
        // Add more effects...
        return "";
    }
    
    /**
     * @notice Assemble complete monster SVG
     */
    function assembleMonsterSVG(
        uint8 backgroundId,
        uint8 monsterId,
        uint8 itemId,
        uint8 effectId
    ) public pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">',
            getBackgroundSVG(backgroundId),
            '<g transform="scale(10) translate(0, 0)">', // Scale up pixel art
            getMonsterSVG(monsterId),
            getItemSVG(itemId),
            '</g>',
            getEffectSVG(effectId),
            '</svg>'
        ));
    }
}