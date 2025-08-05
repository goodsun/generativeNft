// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyArmLib
 * @notice SVG for Arm item
 */
library TragedyArmLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="arm">',
            _getPart1(),
            _getPart2(),
            '</g>'
        ));
    }
    
    function _getPart1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Severed human arm (2/3 size, 90 degree rotation)
            '<g transform="rotate(90 12 12)">',
            // Shoulder cross-section
            '<rect x="8" y="5" width="4" height="2" fill="#8B0000"/>',
            '<rect x="9" y="6" width="2" height="1" fill="#DC143C"/>',
            // Upper arm
            '<rect x="9" y="7" width="3" height="4" fill="#F5DEB3"/>',
            '<rect x="8" y="8" width="1" height="2" fill="#DEB887"/>',
            '<rect x="12" y="8" width="1" height="2" fill="#FFE4B5"/>',
            // Elbow
            '<rect x="9" y="11" width="3" height="1" fill="#DEB887"/>',
            // Forearm
            '<rect x="10" y="12" width="3" height="4" fill="#F5DEB3"/>',
            '<rect x="9" y="13" width="1" height="2" fill="#DEB887"/>',
            '<rect x="13" y="13" width="1" height="2" fill="#FFE4B5"/>',
            // Wrist
            '<rect x="10" y="16" width="3" height="1" fill="#DEB887"/>',
            // Hand
            '<rect x="9" y="17" width="4" height="2" fill="#F5DEB3"/>',
            '<rect x="8" y="18" width="1" height="1" fill="#F5DEB3"/>',
            '<rect x="13" y="18" width="1" height="1" fill="#F5DEB3"/>',
            '<rect x="14" y="17" width="1" height="1" fill="#F5DEB3"/>',
            // Blood stains
            '<rect x="8" y="4" width="1" height="1" fill="#8B0000"/>',
            '<rect x="11" y="4" width="1" height="1" fill="#8B0000"/>',
            '<rect x="9" y="3" width="1" height="1" fill="#DC143C"/>',
            // Nails
            '<rect x="9" y="19" width="1" height="1" fill="#FFE4E1"/>',
            '<rect x="11" y="19" width="1" height="1" fill="#FFE4E1"/>',
            '<rect x="13" y="19" width="1" height="1" fill="#FFE4E1"/>',
            '</g>'
        ));
    }
    
    function _getPart2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Massive blood (positioned after rotation)
            // Blood dripping from shoulder
            '<rect x="17" y="8" width="1" height="4" fill="#8B0000"/>',
            '<rect x="17" y="12" width="1" height="3" fill="#DC143C"/>',
            '<rect x="17" y="15" width="1" height="2" fill="#8B0000"/>',
            '<rect x="17" y="17" width="1" height="1" fill="#DC143C"/>',
            '<rect x="18" y="9" width="1" height="5" fill="#DC143C"/>',
            '<rect x="18" y="14" width="1" height="4" fill="#8B0000"/>',
            '<rect x="18" y="18" width="1" height="2" fill="#DC143C"/>',
            '<rect x="16" y="10" width="1" height="3" fill="#8B0000"/>',
            '<rect x="16" y="13" width="1" height="5" fill="#DC143C"/>',
            '<rect x="16" y="18" width="1" height="1" fill="#8B0000"/>',
            // Blood pool
            '<rect x="15" y="19" width="5" height="1" fill="#8B0000"/>',
            '<rect x="15" y="20" width="4" height="1" fill="#DC143C"/>',
            // Blood splatter
            '<rect x="19" y="10" width="1" height="1" fill="#DC143C"/>',
            '<rect x="20" y="11" width="1" height="1" fill="#8B0000"/>',
            '<rect x="19" y="13" width="1" height="1" fill="#8B0000"/>',
            '<rect x="20" y="15" width="1" height="1" fill="#DC143C"/>',
            '<rect x="15" y="12" width="1" height="1" fill="#8B0000"/>',
            '<rect x="14" y="14" width="1" height="1" fill="#DC143C"/>'
        ));
    }
}