// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterMetadataBankOptimized
 * @notice Optimized version to avoid Stack too deep errors
 * @dev Simplified implementation focusing on core functionality
 */
contract MonsterMetadataBankOptimized is IMetadataBank {
    using Strings for uint256;
    
    // Core attributes
    string[10] private species = ["Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon", "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"];
    string[10] private equipment = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
    string[10] private realms = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
    string[10] private curses = ["Seizure", "Mind Blast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"];
    
    // Rarity names
    string[6] private rarityNames = ["Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"];
    
    // Legendary token IDs
    mapping(uint256 => bool) private legendaryTokens;
    
    constructor() {
        // Set legendary IDs
        legendaryTokens[0] = true;
        legendaryTokens[1] = true;
        legendaryTokens[666] = true;
        legendaryTokens[777] = true;
        legendaryTokens[1234] = true;
        legendaryTokens[1337] = true;
        legendaryTokens[7777] = true;
        legendaryTokens[9999] = true;
    }
    
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId < 10000, "Invalid token ID");
        
        // Decode attributes
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        // Generate metadata parts separately to avoid stack too deep
        string memory json1 = generateJsonPart1(tokenId, s, e, r, c);
        string memory json2 = generateJsonPart2(s, e, r, c);
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(string(abi.encodePacked(json1, json2))))
        ));
    }
    
    function generateJsonPart1(uint256 tokenId, uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        string memory name = generateName(tokenId, s, e, r, c);
        string memory description = generateDescription(tokenId, s, e, r, c);
        string memory image = generateSimpleImage(tokenId);
        
        return string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', image, '",',
            '"external_url":"https://cursed-nightmare.example.com/essay/', tokenId.toString(), '",',
            '"attributes":['
        ));
    }
    
    function generateJsonPart2(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        return string(abi.encodePacked(
            '{"trait_type":"Species","value":"', species[s], '"},',
            '{"trait_type":"Equipment","value":"', equipment[e], '"},',
            '{"trait_type":"Realm","value":"', realms[r], '"},',
            '{"trait_type":"Curse","value":"', curses[c], '"},',
            '{"trait_type":"Rarity","value":"', getRarityName(s, e, r, c), '"}',
            ']}'
        ));
    }
    
    function generateName(uint256 tokenId, uint8 s, uint8, uint8, uint8) private view returns (string memory) {
        if (legendaryTokens[tokenId]) {
            return string(abi.encodePacked("Legendary ", species[s], " #", tokenId.toString()));
        }
        return string(abi.encodePacked("The Mythical Cursed-Nightmare #", tokenId.toString()));
    }
    
    function generateDescription(uint256 tokenId, uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        if (legendaryTokens[tokenId]) {
            return "A legendary creature of immense power and mystery.";
        }
        
        return string(abi.encodePacked(
            "A ", species[s], " wielding ", equipment[e],
            " from the ", realms[r], " realm, cursed with ", curses[c], "."
        ));
    }
    
    function generateSimpleImage(uint256 tokenId) private pure returns (string memory) {
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="#1a1a1a"/>',
            '<text x="200" y="200" text-anchor="middle" font-size="48" fill="#ff0000" font-family="monospace">',
            '#', tokenId.toString(),
            '</text>',
            '<text x="200" y="250" text-anchor="middle" font-size="20" fill="#666">',
            'MONSTER',
            '</text>',
            '</svg>'
        ));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    function getRarityName(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        // Simple rarity calculation based on attribute matching
        uint8 matches = 0;
        if (s == e) matches++;
        if (r == c) matches++;
        if (s == r) matches++;
        if (e == c) matches++;
        
        if (matches >= 3) return rarityNames[5]; // Mythic
        if (matches == 2) return rarityNames[4]; // Legendary
        if (matches == 1) return rarityNames[3]; // Epic
        
        // Use sum for base rarity
        uint8 sum = s + e + r + c;
        if (sum < 10) return rarityNames[2];  // Rare
        if (sum < 20) return rarityNames[1];  // Uncommon
        return rarityNames[0]; // Common
    }
    
    function decodeTokenId(uint256 tokenId) public pure returns (uint8 s, uint8 e, uint8 r, uint8 c) {
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId)));
        s = uint8((seed >> 0) % 10);
        e = uint8((seed >> 8) % 10);
        r = uint8((seed >> 16) % 10);
        c = uint8((seed >> 24) % 10);
    }
    
    function getMetadataCount() external pure override returns (uint256) {
        return 10000;
    }
    
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 tokenId = seed % 10000;
        return this.getMetadata(tokenId);
    }
    
    /**
     * @notice Simple preview function
     */
    function previewToken(uint256 tokenId) external view returns (
        string memory speciesName,
        string memory equipmentName,
        string memory realmName,
        string memory curseName,
        bool isLegendary
    ) {
        require(tokenId < 10000, "Invalid token ID");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        speciesName = species[s];
        equipmentName = equipment[e];
        realmName = realms[r];
        curseName = curses[c];
        isLegendary = legendaryTokens[tokenId];
    }
}