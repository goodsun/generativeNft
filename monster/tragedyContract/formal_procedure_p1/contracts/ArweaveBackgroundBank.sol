// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArweaveBackgroundBank
 * @notice Stores Arweave URLs for background images
 * @dev Backgrounds are stored on Arweave for permanent storage
 */
contract ArweaveBackgroundBank {
    mapping(uint8 => string) private backgroundUrls;
    
    string[10] public backgroundNames = [
        "Bloodmoon",
        "Abyss",
        "Decay",
        "Corruption",
        "Venom",
        "Void",
        "Inferno",
        "Frost",
        "Ragnarok",
        "Shadow"
    ];
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _initializeUrls();
    }
    
    function _initializeUrls() private {
        // Initialize with placeholder Arweave URLs
        // These should be replaced with actual Arweave transaction IDs after uploading
        backgroundUrls[0] = "https://arweave.net/bloodmoon-placeholder";
        backgroundUrls[1] = "https://arweave.net/abyss-placeholder";
        backgroundUrls[2] = "https://arweave.net/decay-placeholder";
        backgroundUrls[3] = "https://arweave.net/corruption-placeholder";
        backgroundUrls[4] = "https://arweave.net/venom-placeholder";
        backgroundUrls[5] = "https://arweave.net/void-placeholder";
        backgroundUrls[6] = "https://arweave.net/inferno-placeholder";
        backgroundUrls[7] = "https://arweave.net/frost-placeholder";
        backgroundUrls[8] = "https://arweave.net/ragnarok-placeholder";
        backgroundUrls[9] = "https://arweave.net/shadow-placeholder";
    }
    
    function getBackgroundUrl(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid background ID");
        return backgroundUrls[id];
    }
    
    function getBackgroundName(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid background ID");
        return backgroundNames[id];
    }
    
    function setBackgroundUrl(uint8 id, string calldata url) external onlyOwner {
        require(id < 10, "Invalid background ID");
        backgroundUrls[id] = url;
    }
    
    // Batch update for gas efficiency
    function setMultipleUrls(uint8[] calldata ids, string[] calldata urls) external onlyOwner {
        require(ids.length == urls.length, "Arrays length mismatch");
        for (uint i = 0; i < ids.length; i++) {
            require(ids[i] < 10, "Invalid background ID");
            backgroundUrls[ids[i]] = urls[i];
        }
    }
}