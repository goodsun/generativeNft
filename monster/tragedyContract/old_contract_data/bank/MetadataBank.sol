// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IMetadataBank
 * @notice Interface for the MetadataBank contract
 */
interface IMetadataBank {
    function getMetadata(uint256 index) external view returns (string memory);
    function getMetadataCount() external view returns (uint256);
    function getRandomMetadata(uint256 seed) external view returns (string memory);
}

/**
 * @title MetadataBank
 * @author BankedNFT Team
 * @notice A contract for storing and managing NFT metadata URIs
 * @dev Stores a list of metadata URIs that can be accessed by NFT contracts
 */
contract MetadataBank is IMetadataBank {
    
    // ============ Custom Errors ============
    error OnlyOwner();
    error InvalidIndex();
    error EmptyMetadata();
    error NoMetadataAvailable();
    
    // ============ Events ============
    event MetadataAdded(uint256 indexed index, string metadataURI);
    event MetadataUpdated(uint256 indexed index, string oldURI, string newURI);
    event MetadataRemoved(uint256 indexed index);
    event AuthorizedContractAdded(address indexed contractAddress);
    event AuthorizedContractRemoved(address indexed contractAddress);
    
    // ============ State Variables ============
    address public immutable owner;
    string[] public metadataList;
    mapping(address => bool) public authorizedContracts;
    
    // ============ Modifiers ============
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }
    
    modifier onlyAuthorized() {
        require(
            msg.sender == owner || authorizedContracts[msg.sender],
            "Not authorized"
        );
        _;
    }
    
    // ============ Constructor ============
    constructor() {
        owner = msg.sender;
    }
    
    // ============ Admin Functions ============
    /**
     * @notice Adds a new metadata URI to the bank
     * @param metadataURI The metadata URI to add
     */
    function addMetadata(string memory metadataURI) external onlyOwner {
        if (bytes(metadataURI).length == 0) revert EmptyMetadata();
        
        metadataList.push(metadataURI);
        emit MetadataAdded(metadataList.length - 1, metadataURI);
    }
    
    /**
     * @notice Adds multiple metadata URIs at once
     * @param metadataURIs Array of metadata URIs to add
     */
    function addMultipleMetadata(string[] memory metadataURIs) external onlyOwner {
        for (uint256 i = 0; i < metadataURIs.length; i++) {
            if (bytes(metadataURIs[i]).length == 0) revert EmptyMetadata();
            
            metadataList.push(metadataURIs[i]);
            emit MetadataAdded(metadataList.length - 1, metadataURIs[i]);
        }
    }
    
    /**
     * @notice Updates an existing metadata URI
     * @param index The index of the metadata to update
     * @param newMetadataURI The new metadata URI
     */
    function updateMetadata(uint256 index, string memory newMetadataURI) external onlyOwner {
        if (index >= metadataList.length) revert InvalidIndex();
        if (bytes(newMetadataURI).length == 0) revert EmptyMetadata();
        
        string memory oldURI = metadataList[index];
        metadataList[index] = newMetadataURI;
        emit MetadataUpdated(index, oldURI, newMetadataURI);
    }
    
    /**
     * @notice Removes a metadata URI from the bank
     * @param index The index of the metadata to remove
     */
    function removeMetadata(uint256 index) external onlyOwner {
        if (index >= metadataList.length) revert InvalidIndex();
        
        // Move the last element to the deleted position and pop
        metadataList[index] = metadataList[metadataList.length - 1];
        metadataList.pop();
        
        emit MetadataRemoved(index);
    }
    
    /**
     * @notice Authorizes a contract to access metadata
     * @param contractAddress The address of the contract to authorize
     */
    function authorizeContract(address contractAddress) external onlyOwner {
        authorizedContracts[contractAddress] = true;
        emit AuthorizedContractAdded(contractAddress);
    }
    
    /**
     * @notice Removes authorization from a contract
     * @param contractAddress The address of the contract to remove authorization from
     */
    function unauthorizeContract(address contractAddress) external onlyOwner {
        authorizedContracts[contractAddress] = false;
        emit AuthorizedContractRemoved(contractAddress);
    }
    
    // ============ View Functions ============
    /**
     * @notice Gets metadata at a specific index
     * @param index The index of the metadata to retrieve
     * @return The metadata URI at the specified index
     */
    function getMetadata(uint256 index) external view override returns (string memory) {
        if (index >= metadataList.length) revert InvalidIndex();
        return metadataList[index];
    }
    
    /**
     * @notice Gets a random metadata URI based on a seed
     * @param seed A seed value for randomization (e.g., tokenId)
     * @return A randomly selected metadata URI
     */
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        if (metadataList.length == 0) revert NoMetadataAvailable();
        
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(seed, block.timestamp, block.prevrandao))) % metadataList.length;
        return metadataList[randomIndex];
    }
    
    /**
     * @notice Gets metadata for a specific token based on modulo operation
     * @param tokenId The token ID to get metadata for
     * @return The metadata URI for the token
     */
    function getMetadataForToken(uint256 tokenId) external view returns (string memory) {
        if (metadataList.length == 0) revert NoMetadataAvailable();
        
        uint256 index = tokenId % metadataList.length;
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
     * @notice Returns all metadata URIs
     * @return Array of all metadata URIs
     */
    function getAllMetadata() external view returns (string[] memory) {
        return metadataList;
    }
    
    /**
     * @notice Checks if a contract is authorized
     * @param contractAddress The address to check
     * @return True if the contract is authorized
     */
    function isAuthorized(address contractAddress) external view returns (bool) {
        return authorizedContracts[contractAddress];
    }
}