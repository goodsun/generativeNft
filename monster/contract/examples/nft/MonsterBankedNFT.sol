// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../BankedNFT.sol";
import "../../bank/MonsterMetadataBank.sol";

/**
 * @title MonsterBankedNFT
 * @notice Monster NFT using the MonsterMetadataBank for on-chain metadata generation
 * @dev Demonstrates integration with the JavaScript-based generation system
 */
contract MonsterBankedNFT is BankedNFT {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintPrice = 0.01 ether;
    
    // Special mint prices for legendary IDs
    mapping(uint256 => uint256) public legendaryPrices;
    
    constructor(address metadataBank) BankedNFT(
        metadataBank,
        "The Mythical Cursed-Nightmare",
        "CURSE",
        0x00
    ) {
        // Set special prices for legendary IDs
        legendaryPrices[1] = 1 ether;      // The Genesis
        legendaryPrices[666] = 0.666 ether; // The Beast
        legendaryPrices[777] = 0.777 ether; // Lucky Seven
        legendaryPrices[1337] = 0.1337 ether; // The Chosen One
    }
    
    /**
     * @notice Mint a specific token ID
     * @param tokenId The token ID to mint (0-9999)
     */
    function mint(uint256 tokenId) external payable {
        require(tokenId < MAX_SUPPLY, "Token ID out of range");
        require(!_exists(tokenId), "Token already minted");
        
        // Check mint price
        uint256 price = legendaryPrices[tokenId] > 0 ? legendaryPrices[tokenId] : mintPrice;
        require(msg.value >= price, "Insufficient payment");
        
        // Mint the token
        _safeMint(msg.sender, tokenId);
        
        // Refund excess payment
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }
    
    /**
     * @notice Mint a random available token
     */
    function mintRandom() external payable returns (uint256) {
        require(msg.value >= mintPrice, "Insufficient payment");
        require(totalSupply() < MAX_SUPPLY, "All tokens minted");
        
        // Find an unminted token ID
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, totalSupply())));
        uint256 tokenId;
        
        for (uint256 i = 0; i < MAX_SUPPLY; i++) {
            tokenId = (seed + i) % MAX_SUPPLY;
            if (!_exists(tokenId)) {
                break;
            }
        }
        
        require(!_exists(tokenId), "No tokens available");
        
        // Mint the token
        _safeMint(msg.sender, tokenId);
        
        // Refund excess payment
        if (msg.value > mintPrice) {
            payable(msg.sender).transfer(msg.value - mintPrice);
        }
        
        return tokenId;
    }
    
    /**
     * @notice Batch mint multiple sequential tokens
     * @param startId Starting token ID
     * @param count Number of tokens to mint
     */
    function batchMint(uint256 startId, uint256 count) external payable {
        require(count > 0 && count <= 10, "Invalid count");
        require(startId + count <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= mintPrice * count, "Insufficient payment");
        
        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = startId + i;
            require(!_exists(tokenId), "Token already minted");
            _safeMint(msg.sender, tokenId);
        }
        
        // Refund excess payment
        if (msg.value > mintPrice * count) {
            payable(msg.sender).transfer(msg.value - mintPrice * count);
        }
    }
    
    /**
     * @notice Check if a token exists
     */
    function exists(uint256 tokenId) external view returns (bool) {
        return _exists(tokenId);
    }
    
    /**
     * @notice Get minted tokens count
     */
    function totalSupply() public view returns (uint256) {
        // Count minted tokens (simplified - in production use a counter)
        uint256 count = 0;
        for (uint256 i = 0; i < MAX_SUPPLY; i++) {
            if (_exists(i)) count++;
        }
        return count;
    }
    
    /**
     * @notice Preview token attributes before minting
     */
    function previewToken(uint256 tokenId) external view returns (
        string memory species,
        string memory equipment,
        string memory realm,
        string memory curse,
        string memory rarity,
        bool hasSynergy,
        bool isLegendary
    ) {
        MonsterMetadataBank bank = MonsterMetadataBank(address(metadataBank));
        return bank.previewToken(tokenId);
    }
    
    /**
     * @notice Get all legendary token IDs and their status
     */
    function getLegendaryTokens() external view returns (
        uint256[] memory ids,
        bool[] memory minted,
        uint256[] memory prices
    ) {
        uint256[] memory legendaryIds = new uint256[](14);
        legendaryIds[0] = 1;
        legendaryIds[1] = 7;
        legendaryIds[2] = 13;
        legendaryIds[3] = 42;
        legendaryIds[4] = 666;
        legendaryIds[5] = 777;
        legendaryIds[6] = 911;
        legendaryIds[7] = 999;
        legendaryIds[8] = 1000;
        legendaryIds[9] = 1111;
        legendaryIds[10] = 1337;
        legendaryIds[11] = 1492;
        legendaryIds[12] = 1776;
        legendaryIds[13] = 9999;
        
        ids = legendaryIds;
        minted = new bool[](ids.length);
        prices = new uint256[](ids.length);
        
        for (uint256 i = 0; i < ids.length; i++) {
            minted[i] = _exists(ids[i]);
            prices[i] = legendaryPrices[ids[i]] > 0 ? legendaryPrices[ids[i]] : mintPrice;
        }
    }
    
    /**
     * @notice Owner functions
     */
    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }
    
    function setLegendaryPrice(uint256 tokenId, uint256 price) external onlyOwner {
        legendaryPrices[tokenId] = price;
    }
    
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    /**
     * @notice Emergency function to update metadata bank
     */
    function updateMetadataBank(address newBank) external onlyOwner {
        metadataBank = IMetadataBank(newBank);
    }
}