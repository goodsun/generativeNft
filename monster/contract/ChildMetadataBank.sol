// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";

/**
 * @title ChildMetadataBank
 * @notice Metadata bank for child stage characters
 */
contract ChildMetadataBank is IMetadataBank {
    
    string[] private metadataList = [
        "ipfs://QmChild1/baby_dragon.json",
        "ipfs://QmChild2/young_wizard.json",
        "ipfs://QmChild3/little_warrior.json",
        "ipfs://QmChild4/small_beast.json",
        "ipfs://QmChild5/tiny_spirit.json"
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