// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyAmuletLib
 * @notice SVG for Amulet item
 */
library TragedyAmuletLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="amulet">',
            // Chain part (silver) - bottom half only
            '<rect x="8" y="5" width="1" height="1" fill="#C0C0C0"/>',
            '<rect x="15" y="5" width="1" height="1" fill="#C0C0C0"/>',
            '<rect x="8" y="6" width="1" height="1" fill="#C0C0C0"/>',
            '<rect x="15" y="6" width="1" height="1" fill="#C0C0C0"/>',
            // Amulet body (outer frame: gold)
            '<rect x="9" y="7" width="6" height="1" fill="#FFD700"/>',
            '<rect x="8" y="8" width="8" height="1" fill="#FFD700"/>',
            '<rect x="7" y="9" width="10" height="1" fill="#FFD700"/>',
            '<rect x="7" y="10" width="10" height="1" fill="#FFD700"/>',
            '<rect x="7" y="11" width="10" height="1" fill="#FFD700"/>',
            '<rect x="8" y="12" width="8" height="1" fill="#FFD700"/>',
            '<rect x="9" y="13" width="6" height="1" fill="#FFD700"/>',
            '<rect x="11" y="14" width="2" height="1" fill="#FFD700"/>',
            // Center gem (purple)
            '<rect x="10" y="9" width="4" height="1" fill="#9370DB"/>',
            '<rect x="9" y="10" width="6" height="1" fill="#9370DB"/>',
            '<rect x="10" y="11" width="4" height="1" fill="#9370DB"/>',
            // Gem highlight (light purple)
            '<rect x="11" y="10" width="2" height="1" fill="#DDA0DD"/>',
            // Metal highlight
            '<rect x="9" y="8" width="2" height="1" fill="#FFFFE0"/>',
            '<rect x="8" y="9" width="1" height="1" fill="#FFFFE0"/>',
            // Shadow (dark gold)
            '<rect x="14" y="12" width="1" height="1" fill="#DAA520"/>',
            '<rect x="15" y="11" width="1" height="1" fill="#DAA520"/>',
            '<rect x="12" y="13" width="2" height="1" fill="#DAA520"/>',
            '</g>'
        ));
    }
}