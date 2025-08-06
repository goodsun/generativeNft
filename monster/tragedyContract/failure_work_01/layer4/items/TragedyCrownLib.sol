// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyCrownLib
 * @notice SVG for Crown item
 */
library TragedyCrownLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="crown">',
            // Crown body (gold)
            '<rect x="7" y="2" width="2" height="4" fill="#FFD700"/>',
            '<rect x="11" y="0" width="2" height="6" fill="#FFD700"/>',
            '<rect x="15" y="2" width="2" height="4" fill="#FFD700"/>',
            '<rect x="7" y="6" width="10" height="2" fill="#FFD700"/>',
            '<rect x="9" y="4" width="2" height="2" fill="#FFD700"/>',
            '<rect x="13" y="4" width="2" height="2" fill="#FFD700"/>',
            // Gem parts (red)
            '<rect x="7" y="0" width="2" height="2" fill="#DC143C"/>',
            '<rect x="11" y="0" width="2" height="1" fill="#DC143C"/>',
            '<rect x="15" y="0" width="2" height="2" fill="#DC143C"/>',
            // Gem borders (silver)
            '<rect x="6" y="0" width="1" height="2" fill="#C0C0C0"/>',
            '<rect x="9" y="0" width="1" height="2" fill="#C0C0C0"/>',
            '<rect x="10" y="0" width="1" height="1" fill="#C0C0C0"/>',
            '<rect x="13" y="0" width="1" height="1" fill="#C0C0C0"/>',
            '<rect x="14" y="0" width="1" height="2" fill="#C0C0C0"/>',
            '<rect x="17" y="0" width="1" height="2" fill="#C0C0C0"/>',
            // Decoration
            '<rect x="10" y="5" width="1" height="1" fill="#FFF"/>',
            '<rect x="13" y="5" width="1" height="1" fill="#FFF"/>',
            // Highlight
            '<rect x="8" y="3" width="1" height="1" fill="#FFFFE0"/>',
            '<rect x="12" y="1" width="1" height="2" fill="#FFFFE0"/>',
            '</g>'
        ));
    }
}