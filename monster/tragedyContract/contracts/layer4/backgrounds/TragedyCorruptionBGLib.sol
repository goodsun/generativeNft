// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyCorruptionBGLib
 * @notice Detailed SVG for Corruption Background
 */
library TragedyCorruptionBGLib {
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
            '<radialGradient id="corruptGrad" cx="50%" cy="50%">',
            '<stop offset="0%" style="stop-color:#4B0082;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#2A0845;stop-opacity:1" />',
            '</radialGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="distort">',
            '<feTurbulence baseFrequency="0.05" numOctaves="2" result="turbulence"/>',
            '<feDisplacementMap in2="turbulence" in="SourceGraphic" scale="2"/>',
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
            // Corrupted sky
            '<rect width="24" height="24" fill="url(#corruptGrad)"/>',
            // Distorted magic circle
            '<circle cx="12" cy="12" r="6" fill="none" stroke="#8B008B" stroke-width="0.5" opacity="0.6" filter="url(#distort)"/>',
            '<polygon points="12,6 15,10 18,12 15,14 12,18 9,14 6,12 9,10" fill="none" stroke="#8B008B" stroke-width="0.3" opacity="0.5"/>',
            // Corrupted tower
            '<rect x="4" y="8" width="3" height="10" fill="#2A0845" transform="skewX(-5)"/>',
            '<polygon points="3,8 5.5,5 8,8" fill="#2A0845"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Purple lightning
            '<path d="M16 2 L14 6 L17 6 L15 10" stroke="#9370DB" stroke-width="0.5" fill="none" opacity="0.8"/>',
            '<path d="M20 4 L19 7 L21 7 L20 10" stroke="#9370DB" stroke-width="0.3" fill="none" opacity="0.6"/>',
            // Corruption aura
            '<ellipse cx="12" cy="16" rx="8" ry="3" fill="#8B008B" opacity="0.3"/>',
            '<ellipse cx="12" cy="18" rx="6" ry="2" fill="#8B008B" opacity="0.2"/>',
            // Floating crystals
            '<polygon points="7,14 8,13 9,14 8,15" fill="#9370DB" opacity="0.7"/>',
            '<polygon points="17,10 18,9 19,10 18,11" fill="#9370DB" opacity="0.6"/>'
        ));
    }
}