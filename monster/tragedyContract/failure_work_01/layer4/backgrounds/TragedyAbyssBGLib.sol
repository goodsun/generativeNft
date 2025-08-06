// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyAbyssBGLib
 * @notice Detailed SVG for Abyss Background
 */
library TragedyAbyssBGLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<defs>',
            _getGradients(),
            '</defs>',
            _getElements()
        ));
    }
    
    function _getGradients() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<linearGradient id="abyssDepth" x1="0%" y1="0%" x2="0%" y2="100%">',
            '<stop offset="0%" style="stop-color:#000033;stop-opacity:1" />',
            '<stop offset="50%" style="stop-color:#000066;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#000099;stop-opacity:1" />',
            '</linearGradient>',
            '<radialGradient id="vortex" cx="50%" cy="60%">',
            '<stop offset="0%" style="stop-color:#0000CC;stop-opacity:0.8" />',
            '<stop offset="50%" style="stop-color:#000066;stop-opacity:0.9" />',
            '<stop offset="100%" style="stop-color:#000033;stop-opacity:1" />',
            '</radialGradient>'
        ));
    }
    
    function _getElements() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Deep abyss background
            '<rect width="24" height="24" fill="url(#abyssDepth)"/>',
            // Swirling abyss
            '<ellipse cx="12" cy="14" rx="8" ry="6" fill="url(#vortex)"/>',
            '<ellipse cx="12" cy="14" rx="6" ry="4.5" fill="none" stroke="#0000FF" stroke-width="0.3" opacity="0.4"/>',
            '<ellipse cx="12" cy="14" rx="4" ry="3" fill="none" stroke="#0000FF" stroke-width="0.2" opacity="0.3"/>',
            // Sinking structures
            '<rect x="2" y="5" width="3" height="8" fill="#000044" transform="rotate(-15 3.5 9)"/>',
            '<rect x="18" y="7" width="2" height="6" fill="#000044" transform="rotate(20 19 10)"/>',
            // Deep sea lights
            '<circle cx="6" cy="18" r="0.5" fill="#4169E1" opacity="0.6"/>',
            '<circle cx="16" cy="20" r="0.3" fill="#4169E1" opacity="0.5"/>',
            '<circle cx="10" cy="22" r="0.4" fill="#4169E1" opacity="0.4"/>',
            // Water ripples
            '<path d="M0 8 Q6 7 12 8 T24 8" stroke="#000099" stroke-width="0.5" fill="none" opacity="0.3"/>',
            '<path d="M0 10 Q6 9 12 10 T24 10" stroke="#000099" stroke-width="0.4" fill="none" opacity="0.25"/>'
        ));
    }
}