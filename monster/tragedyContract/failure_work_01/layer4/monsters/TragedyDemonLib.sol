// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyDemonLib
 * @notice Detailed SVG for Demon
 */
library TragedyDemonLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="demon">',
            _getPart1(),
            _getPart2(),
            '</g>'
        ));
    }
    
    function _getPart1() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Horns
            '<rect x="6" y="2" width="2" height="3" fill="#8B0000"/>',
            '<rect x="16" y="2" width="2" height="3" fill="#8B0000"/>',
            '<rect x="5" y="3" width="1" height="2" fill="#8B0000"/>',
            '<rect x="18" y="3" width="1" height="2" fill="#8B0000"/>',
            // Head
            '<rect x="7" y="5" width="10" height="8" fill="#DC143C"/>',
            '<rect x="6" y="6" width="1" height="6" fill="#DC143C"/>',
            '<rect x="17" y="6" width="1" height="6" fill="#DC143C"/>',
            // Eyes
            '<rect x="8" y="7" width="3" height="2" fill="#FFFF00"/>',
            '<rect x="13" y="7" width="3" height="2" fill="#FFFF00"/>',
            '<rect x="9" y="8" width="1" height="1" fill="#000000"/>',
            '<rect x="14" y="8" width="1" height="1" fill="#000000"/>',
            // Mouth with fangs
            '<rect x="9" y="10" width="6" height="1" fill="#000000"/>',
            '<rect x="9" y="11" width="1" height="1" fill="#FFFFFF"/>',
            '<rect x="14" y="11" width="1" height="1" fill="#FFFFFF"/>'
        ));
    }
    
    function _getPart2() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Body
            '<rect x="6" y="13" width="12" height="6" fill="#DC143C"/>',
            '<rect x="5" y="14" width="1" height="4" fill="#DC143C"/>',
            '<rect x="18" y="14" width="1" height="4" fill="#DC143C"/>',
            // Wings
            '<rect x="3" y="12" width="2" height="5" fill="#4B0000"/>',
            '<rect x="19" y="12" width="2" height="5" fill="#4B0000"/>',
            '<rect x="2" y="13" width="1" height="3" fill="#4B0000"/>',
            '<rect x="21" y="13" width="1" height="3" fill="#4B0000"/>',
            // Legs
            '<rect x="7" y="19" width="3" height="3" fill="#DC143C"/>',
            '<rect x="14" y="19" width="3" height="3" fill="#DC143C"/>',
            '<rect x="8" y="22" width="2" height="1" fill="#4B0000"/>',
            '<rect x="15" y="22" width="2" height="1" fill="#4B0000"/>'
        ));
    }
}