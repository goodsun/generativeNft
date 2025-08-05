// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ITextComposer
 * @notice Interface for text composition contracts
 */
interface ITextComposer {
    function composeName(
        uint256 tokenId,
        uint8 characterId,
        uint8 itemId
    ) external view returns (string memory);
    
    function composeDescription(
        uint8 characterId,
        uint8 itemId,
        uint8 backgroundId,
        uint8 effectId
    ) external view returns (string memory);
    
    function composeStory(
        uint256 seed,
        uint8[] memory attributes
    ) external view returns (string memory);
}