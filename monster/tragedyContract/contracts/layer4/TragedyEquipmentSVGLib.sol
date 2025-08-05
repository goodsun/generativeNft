// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyEquipmentSVGLib
 * @notice Library for equipment SVG generation
 */
library TragedyEquipmentSVGLib {
    
    function getCrownSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="crown">',
            '<rect x="9" y="2" width="6" height="2" fill="#FFD700"/>',
            '<rect x="9" y="0" width="2" height="2" fill="#FFD700"/>',
            '<rect x="11" y="0" width="2" height="2" fill="#FFD700"/>',
            '<rect x="13" y="0" width="2" height="2" fill="#FFD700"/>',
            '</g>'
        ));
    }
    
    function getSwordSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="sword">',
            '<rect x="16" y="4" width="1" height="8" fill="#C0C0C0"/>',
            '<rect x="15" y="12" width="3" height="1" fill="#8B4513"/>',
            '<rect x="16" y="13" width="1" height="2" fill="#8B4513"/>',
            '</g>'
        ));
    }
    
    function getShieldSVG() internal pure returns (string memory) {
        return '<g id="shield"><rect x="6" y="8" width="4" height="5" fill="#4682B4"/></g>';
    }
    
    function getPoisonSVG() internal pure returns (string memory) {
        return '<g id="poison"><circle cx="18" cy="10" r="2" fill="#4B0082"/></g>';
    }
    
    function getTorchSVG() internal pure returns (string memory) {
        return '<g id="torch"><rect x="18" y="8" width="1" height="6" fill="#8B4513"/><circle cx="18" cy="6" r="2" fill="#FF4500"/></g>';
    }
    
    function getWineSVG() internal pure returns (string memory) {
        return '<g id="wine"><rect x="17" y="10" width="2" height="3" fill="#722F37"/></g>';
    }
    
    function getScytheSVG() internal pure returns (string memory) {
        return '<g id="scythe"><path d="M16,6 Q20,6 20,10 L18,10 Q18,8 16,8 Z" fill="#696969"/></g>';
    }
    
    function getMagicWandSVG() internal pure returns (string memory) {
        return '<g id="wand"><rect x="16" y="6" width="1" height="8" fill="#4B0082"/><circle cx="16" cy="5" r="1" fill="#FFD700"/></g>';
    }
    
    function getShoulderArmorSVG() internal pure returns (string memory) {
        return '<g id="armor"><rect x="8" y="6" width="3" height="3" fill="#696969"/><rect x="13" y="6" width="3" height="3" fill="#696969"/></g>';
    }
    
    function getAmuletSVG() internal pure returns (string memory) {
        return '<g id="amulet"><circle cx="12" cy="3" r="2" fill="#FFD700" stroke="#4B0082"/></g>';
    }
}