// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyTorchLib
 * @notice SVG for Torch item
 */
library TragedyTorchLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="torch">',
            _getPart1(),
            _getPart2(),
            '</g>'
        ));
    }
    
    function _getPart1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Torch handle
            '<rect x="11" y="10" width="2" height="8" fill="#8B4513"/>',
            '<rect x="10" y="11" width="1" height="6" fill="#654321"/>',
            '<rect x="13" y="11" width="1" height="6" fill="#A0522D"/>',
            // Cloth wrapping
            '<rect x="10" y="9" width="4" height="1" fill="#2F2F2F"/>',
            '<rect x="10" y="8" width="4" height="1" fill="#4A4A4A"/>',
            '<rect x="10" y="7" width="4" height="1" fill="#2F2F2F"/>',
            // Flame outer
            '<rect x="10" y="6" width="4" height="2" fill="#FF4500"/>',
            '<rect x="9" y="5" width="6" height="1" fill="#FF4500"/>',
            '<rect x="8" y="4" width="8" height="1" fill="#FF4500"/>',
            '<rect x="8" y="3" width="3" height="1" fill="#FF4500"/>',
            '<rect x="13" y="3" width="3" height="1" fill="#FF4500"/>',
            '<rect x="9" y="2" width="2" height="1" fill="#FF4500"/>',
            '<rect x="13" y="2" width="2" height="1" fill="#FF4500"/>',
            '<rect x="10" y="1" width="1" height="1" fill="#FF4500"/>',
            '<rect x="13" y="1" width="1" height="1" fill="#FF4500"/>'
        ));
    }
    
    function _getPart2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Flame inner
            '<rect x="11" y="6" width="2" height="2" fill="#FFA500"/>',
            '<rect x="10" y="5" width="4" height="1" fill="#FFA500"/>',
            '<rect x="10" y="4" width="4" height="1" fill="#FFA500"/>',
            '<rect x="11" y="3" width="2" height="1" fill="#FFA500"/>',
            // Flame center
            '<rect x="11" y="6" width="2" height="1" fill="#FFFF00"/>',
            '<rect x="11" y="5" width="2" height="1" fill="#FFE4B5"/>',
            // Sparks
            '<rect x="7" y="1" width="1" height="1" fill="#FF6347"/>',
            '<rect x="16" y="1" width="1" height="1" fill="#FF6347"/>',
            '<rect x="8" y="0" width="1" height="1" fill="#FFA500"/>',
            '<rect x="15" y="0" width="1" height="1" fill="#FFA500"/>',
            '<rect x="11" y="0" width="1" height="1" fill="#FFD700"/>',
            '<rect x="6" y="3" width="1" height="1" fill="#FF8C00"/>',
            '<rect x="17" y="3" width="1" height="1" fill="#FF8C00"/>',
            // Handle bottom
            '<rect x="10" y="18" width="4" height="1" fill="#2F2F2F"/>'
        ));
    }
}