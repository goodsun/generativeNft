// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ITextComposer.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterTextComposer
 * @notice Composes text elements for Monster NFTs
 * @dev Handles name generation, descriptions, and stories
 */
contract MonsterTextComposer is ITextComposer {
    using Strings for uint256;
    
    // Attribute names
    string[10] private species = ["Demon", "Dragon", "Frankenstein", "Goblin", "Mummy", "Skeleton", "Vampire", "Werewolf", "Zombie", "Succubus"];
    string[10] private equipment = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
    string[10] private realms = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
    string[10] private curses = ["Seizure", "Mind Blast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"];
    
    // Title patterns
    string[5] private titlePatterns = [
        "The {realm} {species}",
        "{species} of {realm}",
        "{curse}-touched {species}",
        "{realm}'s {species}",
        "The Cursed {species}"
    ];
    
    /**
     * @notice Compose NFT name
     */
    function composeName(
        uint256 tokenId,
        uint8 characterId,
        uint8 itemId
    ) external view override returns (string memory) {
        // Special combinations
        if (characterId == 6 && itemId == 5) { // Vampire + Wine
            return string(abi.encodePacked("Blood Sommelier #", tokenId.toString()));
        }
        if (characterId == 1 && itemId == 0) { // Dragon + Crown
            return string(abi.encodePacked("Dragon King #", tokenId.toString()));
        }
        
        // Default pattern
        return string(abi.encodePacked(species[characterId], " #", tokenId.toString()));
    }
    
    /**
     * @notice Compose description
     */
    function composeDescription(
        uint8 characterId,
        uint8 itemId,
        uint8 backgroundId,
        uint8 effectId
    ) external view override returns (string memory) {
        return string(abi.encodePacked(
            "A ", realms[backgroundId], "-touched ", species[characterId],
            " wielding ", equipment[itemId], ", cursed with ", curses[effectId], "."
        ));
    }
    
    /**
     * @notice Compose dynamic story
     */
    function composeStory(
        uint256 seed,
        uint8[] memory attributes
    ) external view override returns (string memory) {
        require(attributes.length >= 4, "Need 4 attributes");
        
        uint8 templateIndex = uint8(seed % 5);
        uint8 c = attributes[0]; // character
        uint8 i = attributes[1]; // item
        uint8 b = attributes[2]; // background
        uint8 e = attributes[3]; // effect
        
        if (templateIndex == 0) {
            return string(abi.encodePacked(
                "In the depths of ", realms[b], ", a ", species[c],
                " discovered the legendary ", equipment[i], ". Now cursed with ",
                curses[e], ", it roams the land seeking redemption."
            ));
        } else if (templateIndex == 1) {
            return string(abi.encodePacked(
                "Once a noble ", species[c], " of ", realms[b],
                ", now corrupted by the power of ", equipment[i],
                " and afflicted with ", curses[e], "."
            ));
        } else if (templateIndex == 2) {
            return string(abi.encodePacked(
                "The ", curses[e], " curse manifests strongly in this ",
                species[c], ". Armed with ", equipment[i],
                ", it haunts the ", realms[b], " dimension."
            ));
        } else if (templateIndex == 3) {
            return string(abi.encodePacked(
                "Born from the essence of ", realms[b], ", this ",
                species[c], " wields ", equipment[i],
                " to channel its ", curses[e], " affliction."
            ));
        } else {
            return string(abi.encodePacked(
                "A legendary ", species[c], " from ", realms[b],
                ", forever bound to ", equipment[i],
                " and cursed with eternal ", curses[e], "."
            ));
        }
    }
}

/**
 * @title AdvancedTextComposer
 * @notice Advanced text composition with rarity and synergies
 */
contract AdvancedTextComposer is MonsterTextComposer {
    
    struct Synergy {
        uint8 char1;
        uint8 char2;
        uint8 item1;
        uint8 item2;
        string title;
        string story;
    }
    
    Synergy[] public synergies;
    
    constructor() {
        // Add some synergies
        synergies.push(Synergy(6, 255, 5, 255, "Blood Sommelier", "Master of the crimson arts"));
        synergies.push(Synergy(1, 255, 0, 255, "Dragon King", "Ruler of the ancient skies"));
        synergies.push(Synergy(0, 255, 6, 255, "Reaper Demon", "Harvester of souls"));
    }
    
    /**
     * @notice Compose name with synergy check
     */
    function composeNameWithSynergy(
        uint256 tokenId,
        uint8 characterId,
        uint8 itemId
    ) external view returns (string memory name, bool hasSynergy) {
        // Check synergies
        for (uint i = 0; i < synergies.length; i++) {
            Synergy memory s = synergies[i];
            if ((s.char1 == characterId || s.char1 == 255) &&
                (s.item1 == itemId || s.item1 == 255)) {
                return (
                    string(abi.encodePacked(s.title, " #", tokenId.toString())),
                    true
                );
            }
        }
        
        // Default name
        return (
            string(abi.encodePacked(species[characterId], " #", tokenId.toString())),
            false
        );
    }
    
    /**
     * @notice Generate rarity-based description
     */
    function composeRarityDescription(
        uint8 characterId,
        uint8 itemId,
        uint8 backgroundId,
        uint8 effectId,
        uint8 rarity
    ) external view returns (string memory) {
        string memory prefix;
        
        if (rarity >= 5) {
            prefix = "A mythical ";
        } else if (rarity >= 4) {
            prefix = "A legendary ";
        } else if (rarity >= 3) {
            prefix = "An epic ";
        } else if (rarity >= 2) {
            prefix = "A rare ";
        } else {
            prefix = "A ";
        }
        
        return string(abi.encodePacked(
            prefix, realms[backgroundId], "-touched ", species[characterId],
            " wielding ", equipment[itemId], ", cursed with ", curses[effectId], "."
        ));
    }
}