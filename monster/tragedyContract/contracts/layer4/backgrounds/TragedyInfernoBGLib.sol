// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyInfernoBGLib
 * @notice Detailed SVG for Inferno Background
 */
library TragedyInfernoBGLib {
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
            '<radialGradient id="infernoGrad" cx="50%" cy="70%">',
            '<stop offset="0%" style="stop-color:#FF4500;stop-opacity:1" />',
            '<stop offset="50%" style="stop-color:#FF6347;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#8B0000;stop-opacity:1" />',
            '</radialGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="flame">',
            '<feTurbulence baseFrequency="0.05" numOctaves="2" seed="3"/>',
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
            // Hell sky
            '<rect width="24" height="24" fill="url(#infernoGrad)"/>',
            // Lava ground
            '<path d="M0 16 Q4 15 8 16 T16 16 Q20 15 24 16 L24 24 L0 24 Z" fill="#8B0000"/>',
            '<path d="M0 18 Q3 17 6 18 T12 18 Q15 17 18 18 T24 18 L24 24 L0 24 Z" fill="#B22222" opacity="0.8"/>',
            // Fire pillars
            '<path d="M6 20 L5 16 L7 16 Z" fill="#FF4500" filter="url(#flame)"/>',
            '<path d="M5.5 16 L5 12 L6 12 Z" fill="#FF6347" opacity="0.8" filter="url(#flame)"/>',
            '<path d="M18 22 L17 18 L19 18 Z" fill="#FF4500" filter="url(#flame)"/>',
            '<path d="M17.5 18 L17 14 L18 14 Z" fill="#FF6347" opacity="0.8" filter="url(#flame)"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Large flame
            '<path d="M12 18 L10 10 L14 10 Z" fill="#FF4500" filter="url(#flame)"/>',
            '<path d="M12 14 L11 8 L13 8 Z" fill="#FF6347" opacity="0.7" filter="url(#flame)"/>',
            // Fire sparks
            '<circle cx="4" cy="8" r="0.3" fill="#FFD700" opacity="0.8"/>',
            '<circle cx="8" cy="6" r="0.2" fill="#FFD700" opacity="0.7"/>',
            '<circle cx="16" cy="7" r="0.3" fill="#FFD700" opacity="0.7"/>',
            '<circle cx="20" cy="9" r="0.2" fill="#FFD700" opacity="0.6"/>',
            // Smoke
            '<ellipse cx="12" cy="4" rx="8" ry="3" fill="#8B0000" opacity="0.3"/>',
            '<ellipse cx="10" cy="2" rx="6" ry="2" fill="#8B0000" opacity="0.2"/>'
        ));
    }
}