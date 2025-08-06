// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "../svg/MonsterSVGDirect.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterMetadataBankV3
 * @notice Monster metadata with actual SVG graphics
 * @dev Uses MonsterSVGDirect for real pixel art
 */
contract MonsterMetadataBankV3 is IMetadataBank {
    using Strings for uint256;
    
    // SVG provider
    MonsterSVGDirect public immutable svgProvider;
    
    // Core attributes (matching SVG assets)
    string[10] private species = ["Demon", "Dragon", "Frankenstein", "Goblin", "Mummy", "Skeleton", "Vampire", "Werewolf", "Zombie", "Succubus"];
    string[10] private equipment = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
    string[10] private realms = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
    string[10] private curses = ["Seizure", "Mind Blast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"];
    
    // Rarity names
    string[6] private rarityNames = ["Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"];
    
    constructor(address _svgProvider) {
        svgProvider = MonsterSVGDirect(_svgProvider);
    }
    
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId < 10000, "Invalid token ID");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        // Generate actual SVG using the SVG provider
        string memory image = generateSVGImage(s, e, r, c);
        
        // Build metadata
        string memory json = string(abi.encodePacked(
            '{"name":"', generateName(tokenId, s), '",',
            '"description":"', generateDescription(s, e, r, c), '",',
            '"image":"', image, '",',
            '"external_url":"https://cursed-nightmare.example.com/monster/', tokenId.toString(), '",',
            '"attributes":['
        ));
        
        json = string(abi.encodePacked(json,
            '{"trait_type":"Species","value":"', species[s], '"},',
            '{"trait_type":"Equipment","value":"', equipment[e], '"},',
            '{"trait_type":"Realm","value":"', realms[r], '"},',
            '{"trait_type":"Curse","value":"', curses[c], '"},',
            '{"trait_type":"Rarity","value":"', calculateRarity(tokenId, s, e, r, c), '"}',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    function generateSVGImage(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        // Map curse to effect (simplified mapping)
        uint8 effectId = c;
        if (c == 4) effectId = 4; // Bats
        else if (c == 6) effectId = 1; // Lightning
        else effectId = 255; // No effect
        
        // Get actual SVG from provider
        string memory svg = svgProvider.assembleMonsterSVG(r, s, e, effectId);
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    function generateName(uint256 tokenId, uint8 s) private view returns (string memory) {
        return string(abi.encodePacked(species[s], " #", tokenId.toString()));
    }
    
    function generateDescription(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        return string(abi.encodePacked(
            "A ", realms[r], "-touched ", species[s],
            " wielding ", equipment[e], ", cursed with ", curses[c], "."
        ));
    }
    
    function calculateRarity(uint256 tokenId, uint8 s, uint8 e, uint8 r, uint8 c) private pure returns (string memory) {
        // Simple rarity based on attribute matching
        uint8 matches = 0;
        if (s == e) matches++;
        if (r == c) matches++;
        if (s == r) matches++;
        if (e == c) matches++;
        
        if (matches >= 3) return "Mythic";
        if (matches == 2) return "Legendary";
        if (matches == 1) return "Epic";
        
        // Use tokenId for base rarity
        uint256 roll = uint256(keccak256(abi.encodePacked(tokenId))) % 100;
        if (roll < 10) return "Rare";
        if (roll < 30) return "Uncommon";
        return "Common";
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
     * @notice Preview token with actual SVG
     */
    function previewToken(uint256 tokenId) external view returns (
        string memory speciesName,
        string memory equipmentName,
        string memory realmName,
        string memory curseName,
        string memory svgImage
    ) {
        require(tokenId < 10000, "Invalid token ID");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        speciesName = species[s];
        equipmentName = equipment[e];
        realmName = realms[r];
        curseName = curses[c];
        svgImage = generateSVGImage(s, e, r, c);
    }
}