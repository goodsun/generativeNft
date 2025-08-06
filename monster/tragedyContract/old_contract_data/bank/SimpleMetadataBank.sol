// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";

/**
 * @title SimpleMetadataBank
 * @author BankedNFT Team
 * @notice A simple, immutable metadata bank that stores metadata URIs at deployment
 * @dev All metadata is set in constructor and cannot be changed after deployment
 */
contract SimpleMetadataBank is IMetadataBank {
    
    // ============ State Variables ============
    string[] private metadataList;
    
    // ============ Constructor ============
    /**
     * @notice Creates a new SimpleMetadataBank with fixed metadata
     * @param _metadataURIs Array of metadata URIs to store permanently
     */
    constructor(string[] memory _metadataURIs) {
        require(_metadataURIs.length > 0, "Empty metadata array");
        
        for (uint256 i = 0; i < _metadataURIs.length; i++) {
            require(bytes(_metadataURIs[i]).length > 0, "Empty metadata URI");
            metadataList.push(_metadataURIs[i]);
        }
    }
    
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
        require(metadataList.length > 0, "No metadata available");
        
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
        require(metadataList.length > 0, "No metadata available");
        
        uint256 index = tokenId % metadataList.length;
        return metadataList[index];
    }
}