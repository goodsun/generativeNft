// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyVampireLib
 * @notice Detailed SVG for Vampire
 */
library TragedyVampireLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="vampire">',
            _getHead(),
            _getBody(),
            '</g>'
        ));
    }
    
    function _getHead() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Hair
            '<rect x="6" y="2" width="12" height="3" fill="#000000"/>',
            '<rect x="5" y="3" width="1" height="2" fill="#000000"/>',
            '<rect x="18" y="3" width="1" height="2" fill="#000000"/>',
            // Head
            '<rect x="6" y="5" width="12" height="8" fill="#D3D3D3"/>',
            '<rect x="5" y="6" width="1" height="6" fill="#D3D3D3"/>',
            '<rect x="18" y="6" width="1" height="6" fill="#D3D3D3"/>',
            // Eyes
            '<rect x="8" y="7" width="2" height="2" fill="#DC143C"/>',
            '<rect x="14" y="7" width="2" height="2" fill="#DC143C"/>',
            // Mouth with fangs
            '<rect x="9" y="10" width="6" height="1" fill="#000000"/>',
            '<rect x="9" y="11" width="1" height="2" fill="#FFFFFF"/>',
            '<rect x="14" y="11" width="1" height="2" fill="#FFFFFF"/>'
        ));
    }
    
    function _getBody() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Cape collar
            '<rect x="4" y="12" width="16" height="2" fill="#4B0000"/>',
            '<rect x="3" y="13" width="1" height="1" fill="#4B0000"/>',
            '<rect x="20" y="13" width="1" height="1" fill="#4B0000"/>',
            // Body with cape
            '<rect x="7" y="14" width="10" height="5" fill="#000000"/>',
            '<rect x="6" y="15" width="1" height="3" fill="#000000"/>',
            '<rect x="17" y="15" width="1" height="3" fill="#000000"/>',
            // Cape
            '<rect x="5" y="14" width="1" height="6" fill="#4B0000"/>',
            '<rect x="18" y="14" width="1" height="6" fill="#4B0000"/>',
            '<rect x="4" y="15" width="1" height="5" fill="#4B0000"/>',
            '<rect x="19" y="15" width="1" height="5" fill="#4B0000"/>',
            '<rect x="3" y="16" width="1" height="4" fill="#4B0000"/>',
            '<rect x="20" y="16" width="1" height="4" fill="#4B0000"/>',
            // Legs
            '<rect x="8" y="19" width="3" height="3" fill="#000000"/>',
            '<rect x="13" y="19" width="3" height="3" fill="#000000"/>',
            '<rect x="9" y="22" width="2" height="1" fill="#000000"/>',
            '<rect x="14" y="22" width="2" height="1" fill="#000000"/>'
        ));
    }
}