// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyShoulderLib
 * @notice SVG for Shoulder item
 */
library TragedyShoulderLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="shoulder">',
            _getPart1(),
            _getPart2(),
            '</g>'
        ));
    }
    
    function _getPart1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Main plate (dark metal)
            '<rect x="8" y="6" width="8" height="1" fill="#696969"/>',
            '<rect x="7" y="7" width="10" height="1" fill="#696969"/>',
            '<rect x="6" y="8" width="12" height="1" fill="#696969"/>',
            '<rect x="6" y="9" width="12" height="1" fill="#696969"/>',
            '<rect x="6" y="10" width="12" height="1" fill="#696969"/>',
            '<rect x="7" y="11" width="10" height="1" fill="#696969"/>',
            '<rect x="8" y="12" width="8" height="1" fill="#696969"/>',
            '<rect x="9" y="13" width="6" height="1" fill="#696969"/>',
            // Highlight (silver)
            '<rect x="9" y="7" width="2" height="1" fill="#C0C0C0"/>',
            '<rect x="8" y="8" width="2" height="1" fill="#C0C0C0"/>',
            '<rect x="7" y="9" width="1" height="1" fill="#C0C0C0"/>'
        ));
    }
    
    function _getPart2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Spike decoration (top)
            '<rect x="10" y="5" width="1" height="1" fill="#808080"/>',
            '<rect x="13" y="5" width="1" height="1" fill="#808080"/>',
            '<rect x="10" y="4" width="1" height="1" fill="#A9A9A9"/>',
            '<rect x="13" y="4" width="1" height="1" fill="#A9A9A9"/>',
            // Rivets (metal fasteners)
            '<rect x="8" y="10" width="1" height="1" fill="#4B4B4B"/>',
            '<rect x="15" y="10" width="1" height="1" fill="#4B4B4B"/>',
            '<rect x="10" y="12" width="1" height="1" fill="#4B4B4B"/>',
            '<rect x="13" y="12" width="1" height="1" fill="#4B4B4B"/>',
            // Edge shadow
            '<rect x="16" y="8" width="1" height="1" fill="#2F2F2F"/>',
            '<rect x="17" y="9" width="1" height="1" fill="#2F2F2F"/>',
            '<rect x="16" y="10" width="1" height="1" fill="#2F2F2F"/>',
            '<rect x="14" y="13" width="1" height="1" fill="#2F2F2F"/>',
            // Strap (leather strap)
            '<rect x="10" y="14" width="1" height="1" fill="#8B4513"/>',
            '<rect x="13" y="14" width="1" height="1" fill="#8B4513"/>',
            '<rect x="10" y="15" width="4" height="1" fill="#8B4513"/>'
        ));
    }
}