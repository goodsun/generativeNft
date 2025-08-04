// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";

/**
 * @title AdultMetadataBank
 * @notice Metadata bank for adult stage characters
 */
contract AdultMetadataBank is IMetadataBank {
    
    string[] private metadataList = [
        "ipfs://QmAdult1/elder_dragon.json",
        "ipfs://QmAdult2/master_wizard.json",
        "ipfs://QmAdult3/legendary_warrior.json",
        "ipfs://QmAdult4/alpha_beast.json",
        "ipfs://QmAdult5/ancient_spirit.json"
    ];
    
    function getMetadata(uint256 index) external view override returns (string memory) {
        require(index < metadataList.length, "Index out of bounds");
        return metadataList[index];
    }
    
    function getMetadataCount() external view override returns (uint256) {
        return metadataList.length;
    }
    
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(seed, block.timestamp, block.prevrandao))) % metadataList.length;
        return metadataList[randomIndex];
    }
}