// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyEffectSVGLib
 * @notice Library for effect SVG generation
 */
library TragedyEffectSVGLib {
    
    function getSeizureEffect() internal pure returns (string memory) {
        return '<g opacity="0.7"><rect x="0" y="0" width="24" height="24" fill="#FF0"><animate attributeName="opacity" values="0;1;0" dur="0.5s" repeatCount="indefinite"/></g>';
    }
    
    function getMindBlastEffect() internal pure returns (string memory) {
        return '<g opacity="0.5"><circle cx="12" cy="12" r="10" fill="none" stroke="#FF00FF" stroke-width="2"><animate attributeName="r" values="2;10;2" dur="2s" repeatCount="indefinite"/></circle></g>';
    }
    
    function getConfusionEffect() internal pure returns (string memory) {
        return '<g opacity="0.6"><text x="12" y="6" text-anchor="middle" fill="#FFF" font-size="8">?</text></g>';
    }
    
    function getMeteorEffect() internal pure returns (string memory) {
        return '<g><circle cx="6" cy="6" r="2" fill="#FF4500"><animate attributeName="cy" from="0" to="24" dur="2s" repeatCount="indefinite"/></circle></g>';
    }
    
    function getBatsEffect() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g>',
            '<path d="M4,4 Q6,3 8,4 L7,5 L6,4 L5,5 L4,4" fill="#000"/>',
            '<path d="M16,8 Q18,7 20,8 L19,9 L18,8 L17,9 L16,8" fill="#000"/>',
            '<path d="M10,6 Q12,5 14,6 L13,7 L12,6 L11,7 L10,6" fill="#000" opacity="0.7"/>',
            '</g>'
        ));
    }
    
    function getPoisoningEffect() internal pure returns (string memory) {
        return '<g opacity="0.4"><rect width="24" height="24" fill="#4B0082"/></g>';
    }
    
    function getLightningEffect() internal pure returns (string memory) {
        return '<g opacity="0.8"><path d="M12,0 L10,8 L14,8 L12,16" stroke="#FFFF00" stroke-width="2" fill="none"><animate attributeName="opacity" values="0;1;0" dur="0.3s" repeatCount="indefinite"/></path></g>';
    }
    
    function getBlizzardEffect() internal pure returns (string memory) {
        return '<g opacity="0.6"><circle cx="8" cy="8" r="1" fill="#FFF"/><circle cx="16" cy="12" r="1" fill="#FFF"/><circle cx="12" cy="16" r="1" fill="#FFF"/></g>';
    }
    
    function getBurningEffect() internal pure returns (string memory) {
        return '<g opacity="0.5"><rect width="24" height="24" fill="#FF4500"/></g>';
    }
    
    function getBrainWashEffect() internal pure returns (string memory) {
        return '<g opacity="0.6"><circle cx="12" cy="6" r="3" fill="none" stroke="#FF00FF" stroke-width="1"><animate attributeName="r" values="3;6;3" dur="2s" repeatCount="indefinite"/></circle></g>';
    }
}