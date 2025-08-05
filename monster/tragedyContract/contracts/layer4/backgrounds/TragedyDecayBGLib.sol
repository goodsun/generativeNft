// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyDecayBGLib
 * @notice Detailed SVG for Decay Background
 */
library TragedyDecayBGLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<defs>',
            _getGradients(),
            _getFilters(),
            '</defs>',
            _getElements()
        ));
    }
    
    function _getGradients() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<linearGradient id="decayGrad" x1="0%" y1="0%" x2="0%" y2="100%">',
            '<stop offset="0%" style="stop-color:#2F4F2F;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#3D5A3D;stop-opacity:1" />',
            '</linearGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="rot">',
            '<feTurbulence baseFrequency="0.5" numOctaves="1" seed="5"/>',
            '<feColorMatrix values="0 0 0 0 0.2 0 0 0 0 0.3 0 0 0 0 0.2 0 0 0 1 0"/>',
            '</filter>'
        ));
    }
    
    function _getElements() private pure returns (string memory) {
        return string(abi.encodePacked(
            _getElements1(),
            _getElements2()
        ));
    }
    
    function _getElements1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Decayed sky
            '<rect width="24" height="24" fill="url(#decayGrad)"/>',
            // Sickly sun
            '<circle cx="6" cy="6" r="3" fill="#556B2F" opacity="0.6"/>',
            '<circle cx="6" cy="6" r="2.5" fill="#6B8E23" opacity="0.4"/>',
            // Withered tree
            '<rect x="11" y="10" width="2" height="8" fill="#3C3C3C"/>',
            '<path d="M12 10 L9 8 M12 10 L15 8 M12 12 L10 11 M12 12 L14 11" stroke="#3C3C3C" stroke-width="0.8" fill="none"/>',
            '<circle cx="9" cy="8" r="0.5" fill="#556B2F" opacity="0.5"/>',
            '<circle cx="15" cy="8" r="0.5" fill="#556B2F" opacity="0.5"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Rotting swamp
            '<ellipse cx="12" cy="20" rx="10" ry="3" fill="#4A5F4A" opacity="0.8"/>',
            '<ellipse cx="8" cy="19" rx="3" ry="1" fill="#556B2F" opacity="0.6"/>',
            '<ellipse cx="16" cy="21" rx="2" ry="0.8" fill="#556B2F" opacity="0.5"/>',
            // Poison bubbles
            '<circle cx="5" cy="18" r="0.3" fill="#6B8E23" opacity="0.7"/>',
            '<circle cx="18" cy="19" r="0.4" fill="#6B8E23" opacity="0.6"/>',
            '<circle cx="10" cy="20" r="0.3" fill="#6B8E23" opacity="0.5"/>',
            // Decay mist
            '<rect x="0" y="14" width="24" height="10" fill="#556B2F" opacity="0.2" filter="url(#rot)"/>'
        ));
    }
}