// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedySuccubusLib
 * @notice Detailed SVG for Succubus
 */
library TragedySuccubusLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="succubus">',
            _getPart1(),
            _getPart2(),
            _getPart3(),
            _getPart4(),
            _getPart5(),
            '</g>'
        ));
    }
    
    function _getPart1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Horns and dark red accents
            '<rect x="8" y="2" width="1" height="1" fill="#8B0000"/>',
            '<rect x="15" y="2" width="1" height="1" fill="#8B0000"/>',
            '<rect x="8" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="10" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="13" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="15" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="9" y="14" width="5" height="3" fill="#8B0000"/>',
            '<rect x="8" y="15" width="1" height="2" fill="#8B0000"/>',
            '<rect x="14" y="15" width="1" height="2" fill="#8B0000"/>',
            '<rect x="13" y="17" width="1" height="1" fill="#8B0000"/>',
            '<rect x="16" y="17" width="1" height="1" fill="#8B0000"/>',
            '<rect x="9" y="18" width="4" height="1" fill="#8B0000"/>'
        ));
    }
    
    function _getPart2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Light red accents
            '<rect x="7" y="3" width="2" height="1" fill="#DC143C"/>',
            '<rect x="15" y="3" width="2" height="1" fill="#DC143C"/>',
            '<rect x="9" y="9" width="1" height="1" fill="#DC143C"/>',
            '<rect x="10" y="11" width="2" height="1" fill="#DC143C"/>',
            '<rect x="13" y="11" width="1" height="1" fill="#DC143C"/>',
            '<rect x="19" y="18" width="1" height="1" fill="#DC143C"/>'
        ));
    }
    
    function _getPart3() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Purple hair/clothing
            '<rect x="6" y="4" width="12" height="2" fill="#4B0082"/>',
            '<rect x="5" y="5" width="1" height="9" fill="#4B0082"/>',
            '<rect x="18" y="5" width="1" height="8" fill="#4B0082"/>',
            '<rect x="6" y="6" width="1" height="1" fill="#4B0082"/>',
            '<rect x="8" y="6" width="1" height="1" fill="#4B0082"/>',
            '<rect x="10" y="6" width="1" height="1" fill="#4B0082"/>',
            '<rect x="12" y="6" width="1" height="1" fill="#4B0082"/>',
            '<rect x="14" y="6" width="1" height="1" fill="#4B0082"/>',
            '<rect x="16" y="6" width="2" height="1" fill="#4B0082"/>',
            '<rect x="4" y="7" width="1" height="6" fill="#4B0082"/>',
            '<rect x="17" y="7" width="1" height="1" fill="#4B0082"/>',
            '<rect x="19" y="7" width="1" height="6" fill="#4B0082"/>',
            '<rect x="6" y="12" width="1" height="3" fill="#4B0082"/>',
            '<rect x="17" y="12" width="1" height="3" fill="#4B0082"/>',
            '<rect x="7" y="13" width="3" height="1" fill="#4B0082"/>',
            '<rect x="15" y="13" width="2" height="2" fill="#4B0082"/>',
            '<rect x="7" y="14" width="2" height="1" fill="#4B0082"/>',
            '<rect x="14" y="14" width="1" height="1" fill="#4B0082"/>',
            '<rect x="17" y="16" width="1" height="2" fill="#4B0082"/>'
        ));
    }
    
    function _getPart4() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Skin (light pink)
            '<rect x="7" y="6" width="1" height="7" fill="#FFE4E1"/>',
            '<rect x="9" y="6" width="1" height="2" fill="#FFE4E1"/>',
            '<rect x="11" y="6" width="1" height="4" fill="#FFE4E1"/>',
            '<rect x="13" y="6" width="1" height="2" fill="#FFE4E1"/>',
            '<rect x="15" y="6" width="1" height="2" fill="#FFE4E1"/>',
            '<rect x="6" y="7" width="1" height="5" fill="#FFE4E1"/>',
            '<rect x="8" y="7" width="1" height="1" fill="#FFE4E1"/>',
            '<rect x="10" y="7" width="1" height="1" fill="#FFE4E1"/>',
            '<rect x="12" y="7" width="1" height="3" fill="#FFE4E1"/>',
            '<rect x="14" y="7" width="1" height="1" fill="#FFE4E1"/>',
            '<rect x="16" y="7" width="1" height="5" fill="#FFE4E1"/>',
            '<rect x="8" y="10" width="3" height="1" fill="#FFE4E1"/>',
            '<rect x="13" y="10" width="3" height="1" fill="#FFE4E1"/>',
            '<rect x="8" y="11" width="2" height="2" fill="#FFE4E1"/>',
            '<rect x="14" y="11" width="2" height="1" fill="#FFE4E1"/>',
            '<rect x="10" y="12" width="5" height="1" fill="#FFE4E1"/>',
            '<rect x="10" y="13" width="3" height="1" fill="#FFE4E1"/>',
            '<rect x="6" y="15" width="2" height="3" fill="#FFE4E1"/>',
            '<rect x="15" y="15" width="2" height="2" fill="#FFE4E1"/>',
            '<rect x="8" y="17" width="1" height="5" fill="#FFE4E1"/>',
            '<rect x="14" y="17" width="2" height="2" fill="#FFE4E1"/>',
            '<rect x="7" y="18" width="1" height="1" fill="#FFE4E1"/>',
            '<rect x="9" y="19" width="1" height="4" fill="#FFE4E1"/>',
            '<rect x="13" y="19" width="2" height="1" fill="#FFE4E1"/>',
            '<rect x="16" y="19" width="2" height="2" fill="#FFE4E1"/>',
            '<rect x="13" y="20" width="1" height="3" fill="#FFE4E1"/>',
            '<rect x="15" y="21" width="2" height="1" fill="#FFE4E1"/>'
        ));
    }
    
    function _getPart5() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Eyes and other details
            '<rect x="9" y="8" width="1" height="1" fill="#FFF"/>',
            '<rect x="14" y="8" width="1" height="1" fill="#FFF"/>',
            // Wings
            '<rect x="3" y="13" width="2" height="4" fill="#4B0000"/>',
            '<rect x="18" y="13" width="3" height="3" fill="#4B0000"/>',
            '<rect x="2" y="14" width="1" height="2" fill="#4B0000"/>',
            '<rect x="5" y="14" width="1" height="2" fill="#4B0000"/>',
            '<rect x="21" y="14" width="1" height="4" fill="#4B0000"/>',
            '<rect x="17" y="15" width="1" height="1" fill="#4B0000"/>',
            '<rect x="19" y="16" width="2" height="1" fill="#4B0000"/>',
            '<rect x="4" y="17" width="1" height="2" fill="#4B0000"/>'
        ));
    }
}