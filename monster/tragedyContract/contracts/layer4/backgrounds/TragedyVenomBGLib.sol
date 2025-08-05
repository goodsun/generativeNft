// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyVenomBGLib
 * @notice Detailed SVG for Venom Background
 */
library TragedyVenomBGLib {
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
            '<radialGradient id="venomGrad" cx="50%" cy="40%">',
            '<stop offset="0%" style="stop-color:#FF1493;stop-opacity:1" />',
            '<stop offset="50%" style="stop-color:#8B008B;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#4B0082;stop-opacity:1" />',
            '</radialGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="poison">',
            '<feTurbulence baseFrequency="0.8" numOctaves="1" seed="2"/>',
            '<feColorMatrix values="0 0 0 0 1 0 0 0 0 0.08 0 0 0 0 0.58 0 0 0 0.8 0"/>',
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
            // Poison sky
            '<rect width="24" height="24" fill="url(#venomGrad)"/>',
            // Poison swamp
            '<ellipse cx="12" cy="18" rx="10" ry="4" fill="#FF1493" opacity="0.4"/>',
            '<ellipse cx="8" cy="17" rx="4" ry="2" fill="#FF1493" opacity="0.3" filter="url(#poison)"/>',
            '<ellipse cx="16" cy="19" rx="3" ry="1.5" fill="#FF1493" opacity="0.3" filter="url(#poison)"/>',
            // Poison mushroom
            '<ellipse cx="6" cy="14" rx="2" ry="1" fill="#8B008B"/>',
            '<rect x="5.5" y="14" width="1" height="2" fill="#4B0082"/>',
            '<circle cx="5.5" cy="13.5" r="0.2" fill="#FF1493"/>',
            '<circle cx="6.5" cy="13.8" r="0.2" fill="#FF1493"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Large poison mushroom
            '<ellipse cx="16" cy="12" rx="3" ry="1.5" fill="#8B008B"/>',
            '<rect x="15" y="12" width="2" height="3" fill="#4B0082"/>',
            '<circle cx="15" cy="11.5" r="0.3" fill="#FF1493"/>',
            '<circle cx="17" cy="11.8" r="0.3" fill="#FF1493"/>',
            '<circle cx="16" cy="11" r="0.3" fill="#FF1493"/>',
            // Poison gas
            '<ellipse cx="12" cy="8" rx="6" ry="3" fill="#FF1493" opacity="0.2" filter="url(#poison)"/>',
            '<ellipse cx="10" cy="6" rx="4" ry="2" fill="#FF1493" opacity="0.15" filter="url(#poison)"/>',
            // Poison drops
            '<ellipse cx="9" cy="10" rx="0.3" ry="0.6" fill="#FF1493" opacity="0.8"/>',
            '<ellipse cx="14" cy="9" rx="0.3" ry="0.6" fill="#FF1493" opacity="0.7"/>'
        ));
    }
}