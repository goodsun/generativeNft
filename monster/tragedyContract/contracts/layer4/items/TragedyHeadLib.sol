// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyHeadLib
 * @notice SVG for Head item
 */
library TragedyHeadLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="head">',
            '<g transform="translate(0, 3)">',
            _getPart1(),
            _getPart2(),
            '</g>',
            '</g>'
        ));
    }
    
    function _getPart1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Hair
            '<rect x="8" y="7" width="8" height="2" fill="#2F4F4F"/>',
            '<rect x="7" y="8" width="10" height="1" fill="#2F4F4F"/>',
            '<rect x="7" y="9" width="2" height="2" fill="#2F4F4F"/>',
            '<rect x="15" y="9" width="2" height="2" fill="#2F4F4F"/>',
            // Face
            '<rect x="9" y="9" width="6" height="6" fill="#C0C0C0"/>',
            '<rect x="8" y="10" width="8" height="4" fill="#C0C0C0"/>',
            '<rect x="9" y="15" width="6" height="1" fill="#C0C0C0"/>',
            // Eyes (closed)
            '<rect x="10" y="11" width="2" height="1" fill="#000000"/>',
            '<rect x="13" y="11" width="2" height="1" fill="#000000"/>',
            // Mouth (open)
            '<rect x="11" y="13" width="3" height="1" fill="#000000"/>',
            '<rect x="11" y="14" width="3" height="1" fill="#8B0000"/>'
        ));
    }
    
    function _getPart2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Blood
            '<rect x="10" y="16" width="1" height="2" fill="#8B0000"/>',
            '<rect x="11" y="16" width="1" height="3" fill="#DC143C"/>',
            '<rect x="12" y="16" width="1" height="3" fill="#8B0000"/>',
            '<rect x="13" y="16" width="1" height="2" fill="#DC143C"/>',
            '<rect x="14" y="16" width="1" height="2" fill="#8B0000"/>',
            // Blood splatter
            '<rect x="9" y="17" width="1" height="1" fill="#DC143C"/>',
            '<rect x="15" y="17" width="1" height="1" fill="#DC143C"/>',
            // Blood from mouth
            '<rect x="12" y="15" width="1" height="2" fill="#DC143C"/>',
            // Neck cross-section
            '<rect x="10" y="16" width="5" height="1" fill="#8B0000"/>',
            // Shadow
            '<rect x="8" y="11" width="1" height="3" fill="#808080"/>',
            '<rect x="16" y="11" width="1" height="3" fill="#808080"/>'
        ));
    }
}