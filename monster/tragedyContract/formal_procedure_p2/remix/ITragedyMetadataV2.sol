// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITragedyMetadataV2 {
    // MetadataBank interface functions
    function getMetadata(uint256 index) external view returns (string memory);
    function getMetadataCount() external view returns (uint256);
    
    // Additional functions specific to TragedyMetadataV2
    function decodeTokenId(uint256 tokenId) external pure returns (
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    );
    
    function generateMetadata(
        uint256 tokenId,
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory);
    
    // Public state
    function composer() external view returns (address);
}