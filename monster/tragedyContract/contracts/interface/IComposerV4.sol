// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IComposerV4 {
    function composeSVG(uint8 species, uint8 background, uint8 item, uint8 effect) 
        external view returns (string memory);
    
    function testExtract(string memory svg) 
        external pure returns (string memory);
    
    function monsterBank() external view returns (address);
    function backgroundBank() external view returns (address);
    function itemBank() external view returns (address);
    function effectBank() external view returns (address);
}