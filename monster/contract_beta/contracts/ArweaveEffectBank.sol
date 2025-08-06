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
        // Initialize with actual Arweave URLs
        effectUrls[0] = "https://arweave.net/8szL-F1P2dHg3XLlYA5EXf3BVzQGfeH_CF_B-MjuNE4";
        effectUrls[1] = "https://arweave.net/DdiqAGyJ4XDW1EFdgKBXo6fStbW-Ks2Y3f3AM96A2A0";
        effectUrls[2] = "https://arweave.net/1-QnPkLT5KI7eQD420wrB3m7n9hXj77rTpanb5773A0";
        effectUrls[3] = "https://arweave.net/TdHsWKEvCIaKhgUcaGVpbs5bLE2V5metBywUhN81Ay4";
        effectUrls[4] = "https://arweave.net/gj9yctWGFj2QhsNxLIFdtPLedkZxz460wVjdc3DwKko";
        effectUrls[5] = "https://arweave.net/aIAfVjyQEPzqqn6OtABZzFJg2yYSUWdet3Zt0EAzPnQ";
        effectUrls[6] = "https://arweave.net/23iGDqX0Uok653Hy3oo1o_Y-haNnzcHMW1LPmOi8IwI";
        effectUrls[7] = "https://arweave.net/dQ5Y3zR80WV6KNnoh214zRk--xEdnMdKtDxI-YMGITM";
        effectUrls[8] = "https://arweave.net/5dC56SGjfZd29Jb_NIlwcUBYtm0VrkE1q53EsN52ZTA";
        effectUrls[9] = "https://arweave.net/M2iMAG1UD9QpqF9OkkUrK56LlLmjhFaeN0fqSyUxPvU";
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