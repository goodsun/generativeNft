// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyRagnarokBGLib
 * @notice Detailed SVG for Ragnarok Background
 */
library TragedyRagnarokBGLib {
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
            '<radialGradient id="ragnarokGrad" cx="50%" cy="30%">',
            '<stop offset="0%" style="stop-color:#FFD700;stop-opacity:1" />',
            '<stop offset="50%" style="stop-color:#FF8C00;stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#8B4513;stop-opacity:1" />',
            '</radialGradient>'
        ));
    }
    
    function _getFilters() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<filter id="apocalypse">',
            '<feTurbulence baseFrequency="0.03" numOctaves="2" seed="4"/>',
            '<feDisplacementMap in2="turbulence" in="SourceGraphic" scale="1"/>',
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
            // Apocalyptic sky
            '<rect width="24" height="24" fill="url(#ragnarokGrad)"/>',
            // Shattered sun
            '<circle cx="12" cy="8" r="4" fill="#FFD700" opacity="0.8"/>',
            '<path d="M12 8 L10 4 M12 8 L14 4 M12 8 L8 8 M12 8 L16 8 M12 8 L10 12 M12 8 L14 12" stroke="#FF8C00" stroke-width="0.5" opacity="0.9"/>'
        ));
    }
    
    function _getElements2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Collapsing earth
            '<polygon points="0,20 3,16 5,18 8,14 11,17 14,15 17,18 20,16 24,20 24,24 0,24" fill="#8B4513"/>',
            '<path d="M4 18 L6 24 M10 16 L12 24 M16 17 L18 24" stroke="#2F1B0C" stroke-width="0.5" fill="none"/>',
            // Golden lightning
            '<path d="M8 2 L6 6 L9 6 L7 10 L10 10 L8 14" stroke="#FFD700" stroke-width="0.4" fill="none" opacity="0.9" filter="url(#apocalypse)"/>',
            '<path d="M16 3 L15 7 L17 7 L16 11" stroke="#FFD700" stroke-width="0.3" fill="none" opacity="0.8"/>'
        ));
    }
    
    function _getElements3() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Burning debris
            '<rect x="2" y="19" width="2" height="3" fill="#8B4513" transform="rotate(-20 3 20.5)"/>',
            '<rect x="18" y="18" width="1.5" height="2.5" fill="#8B4513" transform="rotate(15 18.75 19.25)"/>',
            // Apocalyptic light
            '<ellipse cx="12" cy="16" rx="10" ry="4" fill="#FFD700" opacity="0.2"/>',
            '<ellipse cx="12" cy="18" rx="8" ry="3" fill="#FF8C00" opacity="0.15"/>',
            // Gold particles
            '<circle cx="5" cy="10" r="0.3" fill="#FFD700" opacity="0.7"/>',
            '<circle cx="19" cy="12" r="0.3" fill="#FFD700" opacity="0.6"/>',
            '<circle cx="12" cy="14" r="0.2" fill="#FFD700" opacity="0.8"/>'
        ));
    }
}