// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyWineLib
 * @notice SVG for Wine item
 */
library TragedyWineLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="wine">',
            // Glass bowl part - using integer coordinates
            '<rect x="8" y="6" width="8" height="1" fill="#E0E0E0"/>',
            '<rect x="7" y="7" width="10" height="1" fill="#E0E0E0"/>',
            '<rect x="7" y="8" width="10" height="5" fill="#E0E0E0"/>',
            '<rect x="8" y="13" width="8" height="1" fill="#E0E0E0"/>',
            '<rect x="8" y="14" width="8" height="1" fill="#E0E0E0"/>',
            // Wine
            '<rect x="8" y="10" width="8" height="3" fill="#DC143C"/>',
            '<rect x="8" y="9" width="8" height="1" fill="#FF1744"/>',
            // Stem (leg)
            '<rect x="11" y="15" width="2" height="3" fill="#E0E0E0"/>',
            // Base
            '<rect x="10" y="18" width="4" height="1" fill="#E0E0E0"/>',
            '<rect x="9" y="19" width="6" height="1" fill="#E0E0E0"/>',
            // Highlight
            '<rect x="8" y="7" width="2" height="2" fill="#FFF"/>',
            '<rect x="8" y="10" width="2" height="2" fill="#FFE0E0"/>',
            '</g>'
        ));
    }
}