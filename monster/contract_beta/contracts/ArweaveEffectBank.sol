// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArweaveEffectBank
 * @notice Stores Arweave URLs for effect overlays
 * @dev Effects are stored on Arweave for permanent storage
 */
contract ArweaveEffectBank {
    mapping(uint8 => string) private effectUrls;
    
    string[10] public effectNames = [
        "Seizure",
        "Mindblast",
        "Confusion",
        "Meteor",
        "Bats",
        "Poisoning",
        "Lightning",
        "Blizzard",
        "Burning",
        "Brainwash"
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
        effectUrls[0] = "https://arweave.net/seizure-placeholder";
        effectUrls[1] = "https://arweave.net/mindblast-placeholder";
        effectUrls[2] = "https://arweave.net/confusion-placeholder";
        effectUrls[3] = "https://arweave.net/meteor-placeholder";
        effectUrls[4] = "https://arweave.net/bats-placeholder";
        effectUrls[5] = "https://arweave.net/poisoning-placeholder";
        effectUrls[6] = "https://arweave.net/lightning-placeholder";
        effectUrls[7] = "https://arweave.net/blizzard-placeholder";
        effectUrls[8] = "https://arweave.net/burning-placeholder";
        effectUrls[9] = "https://arweave.net/brainwash-placeholder";
    }
    
    function getEffectUrl(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid effect ID");
        return effectUrls[id];
    }
    
    function getEffectName(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid effect ID");
        return effectNames[id];
    }
    
    function setEffectUrl(uint8 id, string calldata url) external onlyOwner {
        require(id < 10, "Invalid effect ID");
        effectUrls[id] = url;
    }
    
    // Batch update for gas efficiency
    function setMultipleUrls(uint8[] calldata ids, string[] calldata urls) external onlyOwner {
        require(ids.length == urls.length, "Arrays length mismatch");
        for (uint i = 0; i < ids.length; i++) {
            require(ids[i] < 10, "Invalid effect ID");
            effectUrls[ids[i]] = urls[i];
        }
    }
}