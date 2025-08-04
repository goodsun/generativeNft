// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BankedNFT.sol";

/**
 * @title EvolvableNFT
 * @author BankedNFT Team
 * @notice NFT contract with evolution stages that can be triggered by the owner
 * @dev Extends BankedNFT with stage management functionality
 */
contract EvolvableNFT is BankedNFT {
    
    // ============ Events ============
    event Evolved(uint256 indexed stage, address indexed newMetadataBank);
    
    // ============ State Variables ============
    uint256 public currentStage;
    uint256 public evolveBlockNumber;
    
    // ============ Constructor ============
    constructor(
        string memory nameParam,
        string memory symbolParam,
        uint256 _maxSupply,
        uint256 _mintFee,
        uint256 _royaltyRate
    ) BankedNFT(nameParam, symbolParam, _maxSupply, _mintFee, _royaltyRate) {
        currentStage = 1;
    }
    
    // ============ Evolution Functions ============
    /**
     * @notice Evolves all NFTs to the next stage by changing the MetadataBank
     * @param newMetadataBank Address of the new MetadataBank for the next stage
     */
    function evolve(address newMetadataBank) external onlyOwner {
        require(newMetadataBank != address(0), "Invalid bank address");
        
        currentStage++;
        metadataBank = IMetadataBank(newMetadataBank);
        evolveBlockNumber = block.number;
        
        emit Evolved(currentStage, newMetadataBank);
    }
    
    /**
     * @notice Schedules an evolution for a specific block number
     * @param targetBlock The block number when evolution should happen
     * @param newMetadataBank Address of the new MetadataBank
     */
    function scheduleEvolution(uint256 targetBlock, address newMetadataBank) external onlyOwner {
        require(targetBlock > block.number, "Target block must be in future");
        require(newMetadataBank != address(0), "Invalid bank address");
        
        // Store for automatic evolution (would need additional implementation)
        evolveBlockNumber = targetBlock;
    }
    
    /**
     * @notice Returns the current evolution stage
     * @return The current stage number
     */
    function getStage() external view returns (uint256) {
        return currentStage;
    }
}