// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyPoisonLib
 * @notice SVG for Poison item
 */
library TragedyPoisonLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="poison">',
            // Cork stopper
            '<rect x="10" y="5" width="4" height="2" fill="#2F2F2F"/>',
            '<rect x="11" y="7" width="2" height="1" fill="#2F2F2F"/>',
            // Bottle neck
            '<rect x="11" y="8" width="2" height="2" fill="#808080"/>',
            // Bottle body
            '<rect x="9" y="10" width="6" height="1" fill="#808080"/>',
            '<rect x="8" y="11" width="8" height="6" fill="#808080"/>',
            '<rect x="9" y="17" width="6" height="1" fill="#808080"/>',
            // Poison liquid
            '<rect x="9" y="12" width="6" height="4" fill="#32CD32"/>',
            '<rect x="10" y="11" width="4" height="1" fill="#32CD32"/>',
            '<rect x="10" y="16" width="4" height="1" fill="#32CD32"/>',
            // Poison bubbles
            '<rect x="10" y="12" width="1" height="1" fill="#7CFC00"/>',
            '<rect x="13" y="13" width="1" height="1" fill="#7CFC00"/>',
            '<rect x="11" y="14" width="1" height="1" fill="#7CFC00"/>',
            // Poison gas
            '<rect x="11" y="4" width="1" height="1" fill="#32CD32"/>',
            '<rect x="13" y="3" width="1" height="1" fill="#7CFC00"/>',
            '<rect x="10" y="3" width="1" height="1" fill="#228B22"/>',
            // Skull mark
            '<rect x="11" y="13" width="2" height="1" fill="#000000"/>',
            '<rect x="11" y="14" width="2" height="1" fill="#000000"/>',
            // Glass reflection
            '<rect x="9" y="11" width="1" height="2" fill="#C0C0C0"/>',
            '<rect x="8" y="12" width="1" height="1" fill="#A9A9A9"/>',
            '</g>'
        ));
    }
}