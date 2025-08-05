// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ISVGComposer
 * @notice Interface for SVG composition contracts
 */
interface ISVGComposer {
    function composeSVG(
        uint8 backgroundId,
        uint8 characterId,
        uint8 itemId,
        uint8 effectId
    ) external view returns (string memory);
    
    function composeBackground(uint8 id) external view returns (string memory);
    function composeCharacter(uint8 id) external view returns (string memory);
    function composeItem(uint8 id) external view returns (string memory);
    function composeEffect(uint8 id) external view returns (string memory);
}