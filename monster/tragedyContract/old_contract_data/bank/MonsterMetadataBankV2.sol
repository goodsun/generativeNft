// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterMetadataBankV2
 * @notice Full-featured version with Stack too deep fixes
 * @dev Implements complete synergy system while avoiding stack issues
 */
contract MonsterMetadataBankV2 is IMetadataBank {
    using Strings for uint256;
    
    // Core attributes
    string[10] private species = ["Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon", "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"];
    string[10] private equipment = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
    string[10] private realms = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
    string[10] private curses = ["Seizure", "Mind Blast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"];
    
    // Rarity names
    string[6] private rarityNames = ["Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"];
    
    // Realm colors for SVG
    string[10] private realmColors = [
        "#8B0000", "#4B0082", "#2F4F2F", "#800080", "#006400",
        "#000000", "#B22222", "#4682B4", "#8B4513", "#696969"
    ];
    
    // Synergy data structure
    struct SynergyData {
        string title;
        uint8 rarity;
    }
    
    // Legendary IDs
    mapping(uint256 => SynergyData) private legendaryIds;
    
    // Key synergies (simplified for gas optimization)
    mapping(bytes32 => SynergyData) private synergies;
    
    constructor() {
        _initializeLegendaryIds();
        _initializeSynergies();
    }
    
    function _initializeLegendaryIds() private {
        legendaryIds[0] = SynergyData("The Void", 5);
        legendaryIds[1] = SynergyData("The Genesis", 5);
        legendaryIds[666] = SynergyData("The Beast Awakened", 5);
        legendaryIds[777] = SynergyData("Lucky Seven", 5);
        legendaryIds[1234] = SynergyData("Sequential Master", 5);
        legendaryIds[1337] = SynergyData("Elite Monster", 5);
        legendaryIds[7777] = SynergyData("Ultimate Fortune", 5);
        legendaryIds[9999] = SynergyData("The End", 5);
    }
    
    function _initializeSynergies() private {
        // Quad synergies (simplified)
        synergies[keccak256(abi.encodePacked(uint8(4), uint8(0), uint8(8), uint8(3)))] = SynergyData("Cosmic Sovereign", 5);
        synergies[keccak256(abi.encodePacked(uint8(6), uint8(5), uint8(0), uint8(4)))] = SynergyData("Crimson Lord", 5);
        
        // Trinity synergies
        synergies[keccak256(abi.encodePacked(uint8(255), uint8(5), uint8(0), uint8(4)))] = SynergyData("Classic Nosferatu", 4);
        
        // Dual synergies
        synergies[keccak256(abi.encodePacked(uint8(6), uint8(5), uint8(255), uint8(255)))] = SynergyData("Blood Sommelier", 3);
    }
    
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId < 10000, "Invalid token ID");
        
        // Split into separate function calls to reduce stack depth
        string memory part1 = _buildMetadataPart1(tokenId);
        string memory part2 = _buildMetadataPart2(tokenId);
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(string(abi.encodePacked(part1, part2))))
        ));
    }
    
    function _buildMetadataPart1(uint256 tokenId) private view returns (string memory) {
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        // Get basic info
        (string memory name, string memory description) = _getNameAndDescription(tokenId, s, e, r, c);
        string memory image = _generateSimpleImage(tokenId, s, r);
        
        return string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', image, '",',
            '"external_url":"https://cursed-nightmare.example.com/essay/', tokenId.toString(), '",',
            '"attributes":['
        ));
    }
    
    function _buildMetadataPart2(uint256 tokenId) private view returns (string memory) {
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        uint8 rarity = _calculateRarity(tokenId, s, e, r, c);
        
        return string(abi.encodePacked(
            '{"trait_type":"Species","value":"', species[s], '"},',
            '{"trait_type":"Equipment","value":"', equipment[e], '"},',
            '{"trait_type":"Realm","value":"', realms[r], '"},',
            '{"trait_type":"Curse","value":"', curses[c], '"},',
            '{"trait_type":"Rarity","value":"', rarityNames[rarity], '"}',
            ']}'
        ));
    }
    
    function _getNameAndDescription(
        uint256 tokenId,
        uint8 s,
        uint8 e,
        uint8 r,
        uint8 c
    ) private view returns (string memory name, string memory description) {
        // Check legendary
        SynergyData memory legendary = legendaryIds[tokenId];
        if (bytes(legendary.title).length > 0) {
            name = string(abi.encodePacked(legendary.title, " #", tokenId.toString()));
            description = "A legendary creature of immense power.";
            return (name, description);
        }
        
        // Check synergies (simplified)
        bytes32 quadKey = keccak256(abi.encodePacked(s, e, r, c));
        SynergyData memory synergy = synergies[quadKey];
        
        if (bytes(synergy.title).length > 0) {
            name = string(abi.encodePacked(synergy.title, " #", tokenId.toString()));
            description = "A powerful synergy creature.";
            return (name, description);
        }
        
        // Default
        name = string(abi.encodePacked("The Mythical Cursed-Nightmare #", tokenId.toString()));
        description = string(abi.encodePacked(
            "A ", realms[r], "-touched ", species[s], 
            " wielding ", equipment[e], ", cursed with ", curses[c], "."
        ));
    }
    
    function _generateSimpleImage(uint256 tokenId, uint8 s, uint8 r) private view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="', realmColors[r], '"/>',
            '<text x="200" y="180" text-anchor="middle" font-size="48" fill="#fff" font-family="monospace">',
            '#', tokenId.toString(),
            '</text>',
            '<text x="200" y="220" text-anchor="middle" font-size="24" fill="#ccc">',
            species[s],
            '</text>',
            '</svg>'
        );
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        ));
    }
    
    function _calculateRarity(
        uint256 tokenId,
        uint8 s,
        uint8 e,
        uint8 r,
        uint8 c
    ) private view returns (uint8) {
        // Check legendary
        if (legendaryIds[tokenId].rarity > 0) {
            return legendaryIds[tokenId].rarity;
        }
        
        // Check synergies
        bytes32 quadKey = keccak256(abi.encodePacked(s, e, r, c));
        if (synergies[quadKey].rarity > 0) {
            return synergies[quadKey].rarity;
        }
        
        // Base rarity calculation
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId)));
        uint256 roll = (seed % 100) + 1;
        
        if (roll > 95) return 4; // Legendary
        if (roll > 85) return 3; // Epic
        if (roll > 70) return 2; // Rare
        if (roll > 50) return 1; // Uncommon
        return 0; // Common
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
     * @notice Preview function with reduced parameters
     */
    function previewToken(uint256 tokenId) external view returns (
        string memory speciesName,
        string memory equipmentName,
        string memory realmName,
        string memory curseName
    ) {
        require(tokenId < 10000, "Invalid token ID");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        speciesName = species[s];
        equipmentName = equipment[e];
        realmName = realms[r];
        curseName = curses[c];
    }
}