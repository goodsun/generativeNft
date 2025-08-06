// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyShadowBGLib
 * @notice Detailed SVG for Shadow Background
 */
library TragedyShadowBGLib {
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
            '<radialGradient id="shadowGrad" cx="50%" cy="50%">',
            '<stop offset="0%" style="stop-color:#4A4A4A;stop-opacity:1" />',
            '<stop offset="50%" style="stop-color:#2D2D2D;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#0A0A0A;stop-opacity:1" />',
            '</radialGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="blur">',
            '<feGaussianBlur in="SourceGraphic" stdDeviation="0.5"/>',
            '</filter>'
        ));
    }
    
    function _getElements() private pure returns (string memory) {
        return string(abi.encodePacked(
            _getElements1(),
            _getElements2(),
            _getElements3()
        ));
    }
    
    function _getElements1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Shadow background
            '<rect width="24" height="24" fill="url(#shadowGrad)"/>',
            // Dark moon
            '<circle cx="18" cy="6" r="3" fill="#2D2D2D"/>',
            '<circle cx="18" cy="6" r="2.5" fill="#4A4A4A" opacity="0.7"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Shadow forest
            '<path d="M2 14 L2 20 M2 17 L1 16 M2 17 L3 16" stroke="#1A1A1A" stroke-width="1.2" fill="none"/>',
            '<path d="M6 12 L6 20 M6 15 L5 14 M6 15 L7 14 M6 17 L5 16 M6 17 L7 16" stroke="#1A1A1A" stroke-width="1.5" fill="none"/>',
            '<path d="M11 13 L11 20 M11 16 L10 15 M11 16 L12 15 M11 18 L10 17 M11 18 L12 17" stroke="#1A1A1A" stroke-width="1.3" fill="none"/>',
            '<path d="M16 14 L16 20 M16 17 L15 16 M16 17 L17 16" stroke="#1A1A1A" stroke-width="1" fill="none"/>',
            '<path d="M20 15 L20 20 M20 18 L19 17 M20 18 L21 17" stroke="#1A1A1A" stroke-width="1" fill="none"/>'
        ));
    }
    
    function _getElements3() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Shadow creature
            '<ellipse cx="8" cy="10" rx="1.5" ry="0.5" fill="#000000" opacity="0.8" filter="url(#blur)"/>',
            '<circle cx="7.5" cy="10" r="0.3" fill="#5A5A5A" opacity="0.8"/>',
            '<circle cx="8.5" cy="10" r="0.3" fill="#5A5A5A" opacity="0.8"/>',
            // Ground shadows
            '<ellipse cx="12" cy="20" rx="12" ry="3" fill="#000000" opacity="0.6"/>',
            '<ellipse cx="12" cy="21" rx="10" ry="2" fill="#000000" opacity="0.4"/>',
            // Floating shadows
            '<path d="M14 5 Q16 7 14 9 Q12 7 14 5" fill="#3A3A3A" opacity="0.7" filter="url(#blur)"/>',
            '<path d="M4 8 Q6 10 4 12 Q2 10 4 8" fill="#3A3A3A" opacity="0.6" filter="url(#blur)"/>',
            // Shadow particles
            '<circle cx="3" cy="4" r="0.4" fill="#4A4A4A" opacity="0.6"/>',
            '<circle cx="10" cy="3" r="0.3" fill="#4A4A4A" opacity="0.5"/>',
            '<circle cx="21" cy="10" r="0.4" fill="#4A4A4A" opacity="0.5"/>'
        ));
    }
}