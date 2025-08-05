// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyBackgroundSVGLib
 * @notice Library for background SVG generation
 */
library TragedyBackgroundSVGLib {
    
    function getBloodmoonBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#1a0000"/><circle cx="12" cy="6" r="5" fill="#8B0000"/>';
    }
    
    function getAbyssBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#000033"/>';
    }
    
    function getDecayBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#3E2723"/>';
    }
    
    function getCorruptionBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#4A148C"/>';
    }
    
    function getVenomBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#1B5E20"/>';
    }
    
    function getVoidBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#000000"/>';
    }
    
    function getInfernoBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#B71C1C"/>';
    }
    
    function getFrostBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#01579B"/>';
    }
    
    function getRagnarokBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#F57F17"/>';
    }
    
    function getShadowBG() internal pure returns (string memory) {
        return '<rect width="24" height="24" fill="#263238"/>';
    }
}