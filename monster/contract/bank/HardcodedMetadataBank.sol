// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";

/**
 * @title HardcodedMetadataBank
 * @author BankedNFT Team
 * @notice A metadata bank with hardcoded URIs in the contract code
 * @dev All metadata is defined in the contract itself - no constructor params needed
 */
contract HardcodedMetadataBank is IMetadataBank {
    
    // ============ Hardcoded Metadata ============
    string[] private metadataList = [
        "ipfs://QmXxx1/metadata.json",
        "ipfs://QmXxx2/metadata.json",
        "ipfs://QmXxx3/metadata.json",
        "ipfs://QmXxx4/metadata.json",
        "ipfs://QmXxx5/metadata.json"
        // Add more URIs here as needed
    ];
    
    // ============ View Functions ============
    /**
     * @notice Gets metadata at a specific index
     * @param index The index of the metadata to retrieve
     * @return The metadata URI at the specified index
     */
    function getMetadata(uint256 index) external view override returns (string memory) {
        require(index < metadataList.length, "Index out of bounds");
        return metadataList[index];
    }
    
    /**
     * @notice Returns the total count of metadata entries
     * @return The number of metadata URIs stored
     */
    function getMetadataCount() external view override returns (uint256) {
        return metadataList.length;
    }
    
    /**
     * @notice Gets a random metadata URI based on a seed
     * @param seed A seed value for randomization
     * @return A randomly selected metadata URI
     */
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(seed, block.timestamp, block.prevrandao))) % metadataList.length;
        return metadataList[randomIndex];
    }
    
    /**
     * @notice Returns all metadata URIs
     * @return Array of all metadata URIs
     */
    function getAllMetadata() external view returns (string[] memory) {
        return metadataList;
    }
    
    /**
     * @notice Gets metadata for a specific token based on modulo operation
     * @param tokenId The token ID to get metadata for
     * @return The metadata URI for the token
     */
    function getMetadataForToken(uint256 tokenId) external view returns (string memory) {
        uint256 index = tokenId % metadataList.length;
        return metadataList[index];
    }
}