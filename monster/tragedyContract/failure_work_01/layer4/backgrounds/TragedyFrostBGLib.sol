// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyFrostBGLib
 * @notice Detailed SVG for Frost Background
 */
library TragedyFrostBGLib {
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
            '<linearGradient id="frostGrad" x1="0%" y1="0%" x2="0%" y2="100%">',
            '<stop offset="0%" style="stop-color:#87CEEB;stop-opacity:1" />',
            '<stop offset="50%" style="stop-color:#4682B4;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#191970;stop-opacity:1" />',
            '</linearGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="crystal">',
            '<feGaussianBlur in="SourceGraphic" stdDeviation="0.1"/>',
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
            // Frozen sky
            '<rect width="24" height="24" fill="url(#frostGrad)"/>',
            // Ice mountains
            '<polygon points="0,18 4,10 8,14 12,8 16,12 20,9 24,16 24,24 0,24" fill="#4682B4"/>',
            '<polygon points="0,18 4,10 8,14 12,8 16,12 20,9 24,16 24,24 0,24" fill="#87CEEB" opacity="0.4"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Icicles
            '<polygon points="3,14 2,18 4,18" fill="#87CEEB" opacity="0.8"/>',
            '<polygon points="7,12 6,16 8,16" fill="#87CEEB" opacity="0.7"/>',
            '<polygon points="15,10 14,14 16,14" fill="#87CEEB" opacity="0.8"/>',
            '<polygon points="19,11 18,15 20,15" fill="#87CEEB" opacity="0.7"/>',
            // Ice crystals
            '<g transform="translate(6,5)">',
            '<path d="M0,-2 L0,2 M-2,0 L2,0 M-1.4,-1.4 L1.4,1.4 M-1.4,1.4 L1.4,-1.4" stroke="#E0FFFF" stroke-width="0.3" opacity="0.8"/>',
            '</g>',
            '<g transform="translate(18,3)">',
            '<path d="M0,-1.5 L0,1.5 M-1.5,0 L1.5,0 M-1,-1 L1,1 M-1,1 L1,-1" stroke="#E0FFFF" stroke-width="0.2" opacity="0.7"/>',
            '</g>'
        ));
    }
    
    function _getElements3() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Snow particles
            '<circle cx="4" cy="7" r="0.2" fill="#FFFFFF" opacity="0.8"/>',
            '<circle cx="10" cy="4" r="0.2" fill="#FFFFFF" opacity="0.7"/>',
            '<circle cx="14" cy="6" r="0.2" fill="#FFFFFF" opacity="0.7"/>',
            '<circle cx="20" cy="8" r="0.2" fill="#FFFFFF" opacity="0.6"/>',
            // Frozen lake
            '<ellipse cx="12" cy="20" rx="10" ry="2" fill="#E0FFFF" opacity="0.5"/>',
            '<ellipse cx="12" cy="20" rx="8" ry="1.5" fill="#87CEEB" opacity="0.3"/>'
        ));
    }
}