// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyShieldLib
 * @notice SVG for Shield item
 */
library TragedyShieldLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="shield">',
            // Outer frame
            '<rect x="7" y="4" width="10" height="2" fill="#696969"/>',
            '<rect x="6" y="6" width="12" height="2" fill="#696969"/>',
            '<rect x="5" y="8" width="14" height="6" fill="#696969"/>',
            '<rect x="6" y="14" width="12" height="2" fill="#696969"/>',
            '<rect x="7" y="16" width="10" height="2" fill="#696969"/>',
            '<rect x="9" y="18" width="6" height="2" fill="#696969"/>',
            // Inner color
            '<rect x="8" y="5" width="8" height="1" fill="#2F2F2F"/>',
            '<rect x="7" y="7" width="10" height="1" fill="#2F2F2F"/>',
            '<rect x="6" y="9" width="12" height="4" fill="#2F2F2F"/>',
            '<rect x="7" y="13" width="10" height="2" fill="#2F2F2F"/>',
            '<rect x="8" y="15" width="8" height="2" fill="#2F2F2F"/>',
            '<rect x="10" y="17" width="4" height="2" fill="#2F2F2F"/>',
            // Center cross
            '<rect x="11" y="7" width="2" height="10" fill="#FFD700"/>',
            '<rect x="8" y="10" width="8" height="2" fill="#FFD700"/>',
            // Metal shine
            '<rect x="6" y="6" width="2" height="1" fill="#A9A9A9"/>',
            '<rect x="5" y="8" width="1" height="2" fill="#A9A9A9"/>',
            '<rect x="7" y="5" width="1" height="1" fill="#808080"/>',
            '</g>'
        ));
    }
}