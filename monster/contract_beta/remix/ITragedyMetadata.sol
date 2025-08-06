// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITragedyMetadata {
    function generateMetadata(
        uint256 tokenId,
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory);
    
    function composer() external view returns (address);
}