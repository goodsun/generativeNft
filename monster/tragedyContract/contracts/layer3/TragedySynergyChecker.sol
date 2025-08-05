// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedySynergyChecker
 * @notice Checks for synergies between attributes
 */
contract TragedySynergyChecker {
    
    enum SynergyType { None, Dual, Trinity, Quad }
    enum Rarity { Common, Uncommon, Rare, Epic, Legendary, Mythic }
    
    struct Synergy {
        string title;
        string story;
        SynergyType synergyType;
        Rarity rarity;
        bool exists;
    }
    
    // Pre-computed synergy hashes
    mapping(bytes32 => Synergy) private synergies;
    
    constructor() {
        _initializeQuadSynergies();
        _initializeTrinitySynergies();
        _initializeDualSynergies();
    }
    
    function checkSynergy(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (Synergy memory) {
        // Check Quad synergy first (highest priority)
        bytes32 quadKey = keccak256(abi.encodePacked(species, equipment, realm, curse));
        if (synergies[quadKey].exists) {
            return synergies[quadKey];
        }
        
        // Check Trinity synergies
        // Pattern 1: species + equipment + wildcard + curse
        bytes32 trinityKey1 = keccak256(abi.encodePacked(species, equipment, uint8(255), curse));
        if (synergies[trinityKey1].exists) {
            return synergies[trinityKey1];
        }
        
        // Pattern 2: wildcard + equipment + realm + curse
        bytes32 trinityKey2 = keccak256(abi.encodePacked(uint8(255), equipment, realm, curse));
        if (synergies[trinityKey2].exists) {
            return synergies[trinityKey2];
        }
        
        // Check Dual synergies
        bytes32 dualKey1 = keccak256(abi.encodePacked(species, equipment, uint8(255), uint8(255)));
        bytes32 dualKey2 = keccak256(abi.encodePacked(uint8(255), uint8(255), realm, curse));
        
        Synergy memory dual1 = synergies[dualKey1];
        Synergy memory dual2 = synergies[dualKey2];
        
        // If both dual synergies exist, return the higher rarity one
        if (dual1.exists && dual2.exists) {
            return uint8(dual1.rarity) > uint8(dual2.rarity) ? dual1 : dual2;
        } else if (dual1.exists) {
            return dual1;
        } else if (dual2.exists) {
            return dual2;
        }
        
        // No synergy found
        return Synergy("", "", SynergyType.None, Rarity.Common, false);
    }
    
    function _initializeQuadSynergies() private {
        // Vampire + Wine + Bloodmoon + Bats = Crimson Lord
        _addSynergy(6, 5, 0, 4, Synergy(
            "Crimson Lord",
            "Under the blood moon, the crimson ruler commands legions of bats from a throne of crystallized blood.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Dragon + Crown + Ragnarok + Meteor = Cosmic Sovereign
        _addSynergy(4, 0, 8, 3, Synergy(
            "Cosmic Sovereign",
            "At the end of all things, the crowned dragon rains celestial fire upon the final battlefield.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Demon + Scythe + Inferno + Burning = Hell's Harvester
        _addSynergy(3, 6, 6, 8, Synergy(
            "Hell's Harvester",
            "The infernal reaper harvests souls in seas of eternal flame, each swing igniting new pyres.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Succubus + Amulet + Void + Mind Blast = Psychic Seductress
        _addSynergy(8, 9, 5, 1, Synergy(
            "Psychic Seductress",
            "From the void between thoughts, she weaves desires that shatter minds and bind souls.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Skeleton + Shield + Shadow + Lightning = Storm Sentinel
        _addSynergy(9, 2, 9, 6, Synergy(
            "Storm Sentinel",
            "The undying guardian channels lightning through ancient bones, protecting the shadow realm's borders.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Frankenstein + Magic Wand + Corruption + Brain Wash = Mad Scientist
        _addSynergy(2, 7, 3, 9, Synergy(
            "Mad Scientist",
            "The reanimated genius wields corrupted magic to reshape minds in their twisted laboratory.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Werewolf + Sword + Frost + Blizzard = Fenrir's Heir
        _addSynergy(0, 1, 7, 7, Synergy(
            "Fenrir's Heir",
            "The legendary wolf warrior brings eternal winter, each sword strike summoning howling blizzards.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Goblin + Poison + Venom + Poisoning = Toxic Trickster
        _addSynergy(1, 3, 4, 5, Synergy(
            "Toxic Trickster",
            "The venomous prankster spreads noxious clouds of poison that corrode both matter and spirit.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Zombie + Torch + Decay + Seizure = Plague Bearer
        _addSynergy(5, 4, 2, 0, Synergy(
            "Plague Bearer",
            "The rotting herald carries the flame of pestilence, spreading convulsions and decay with each step.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
        
        // Mummy + Shoulder Armor + Abyss + Confusion = Ancient Enigma
        _addSynergy(7, 8, 1, 2, Synergy(
            "Ancient Enigma",
            "Wrapped in mysteries deeper than the abyss, this armored enigma confounds reality itself.",
            SynergyType.Quad,
            Rarity.Mythic,
            true
        ));
    }
    
    function _initializeTrinitySynergies() private {
        // Species-specific trinity synergies
        _addSynergy(6, 5, 255, 4, Synergy( // Vampire + Wine + Bats
            "Classic Nosferatu",
            "The iconic vampire in its most traditional form, commanding bats while savoring blood wine.",
            SynergyType.Trinity,
            Rarity.Legendary,
            true
        ));
        
        _addSynergy(0, 1, 255, 7, Synergy( // Werewolf + Sword + Blizzard
            "Winter Wolf",
            "The frost-touched lycanthrope wields a blade of ice in the eternal blizzard.",
            SynergyType.Trinity,
            Rarity.Epic,
            true
        ));
        
        // Equipment-centric trinity synergies (species-agnostic)
        _addSynergy(255, 3, 4, 5, Synergy( // Poison + Venom + Poisoning
            "Trinity of Toxins",
            "When poison, venom, and poisoning converge, death becomes an art form.",
            SynergyType.Trinity,
            Rarity.Legendary,
            true
        ));
        
        _addSynergy(255, 4, 6, 8, Synergy( // Torch + Inferno + Burning
            "Eternal Pyre",
            "The torch that ignites the inferno, burning without end or mercy.",
            SynergyType.Trinity,
            Rarity.Epic,
            true
        ));
        
        _addSynergy(255, 7, 5, 1, Synergy( // Magic Wand + Void + Mind Blast
            "Null Mage",
            "Wielding void magic to shatter minds across dimensions.",
            SynergyType.Trinity,
            Rarity.Legendary,
            true
        ));
    }
    
    function _initializeDualSynergies() private {
        // Species + Equipment synergies
        _addSynergy(6, 5, 255, 255, Synergy( // Vampire + Wine
            "Blood Sommelier",
            "A refined predator who has transcended mere survival to savor the finest vintages of life.",
            SynergyType.Dual,
            Rarity.Legendary,
            true
        ));
        
        _addSynergy(4, 0, 255, 255, Synergy( // Dragon + Crown
            "Draconic Royalty",
            "The sovereign of scales, whose reign spans millennia.",
            SynergyType.Dual,
            Rarity.Epic,
            true
        ));
        
        _addSynergy(3, 6, 255, 255, Synergy( // Demon + Scythe
            "Soul Reaper",
            "The infernal harvester of the damned.",
            SynergyType.Dual,
            Rarity.Epic,
            true
        ));
        
        _addSynergy(9, 2, 255, 255, Synergy( // Skeleton + Shield
            "Bone Guardian",
            "Death itself stands sentinel.",
            SynergyType.Dual,
            Rarity.Rare,
            true
        ));
        
        _addSynergy(2, 7, 255, 255, Synergy( // Frankenstein + Magic Wand
            "Reanimated Wizard",
            "Science and sorcery stitched into one.",
            SynergyType.Dual,
            Rarity.Epic,
            true
        ));
        
        // Realm + Curse synergies
        _addSynergy(255, 255, 0, 4, Synergy( // Bloodmoon + Bats
            "Crimson Swarm",
            "Under the blood moon, the night hunters multiply.",
            SynergyType.Dual,
            Rarity.Rare,
            true
        ));
        
        _addSynergy(255, 255, 6, 8, Synergy( // Inferno + Burning
            "Eternal Flame",
            "Fire that burns without fuel, consuming reality itself.",
            SynergyType.Dual,
            Rarity.Epic,
            true
        ));
        
        _addSynergy(255, 255, 7, 7, Synergy( // Frost + Blizzard
            "Absolute Zero",
            "Where warmth goes to die.",
            SynergyType.Dual,
            Rarity.Rare,
            true
        ));
        
        _addSynergy(255, 255, 5, 1, Synergy( // Void + Mind Blast
            "Psychic Rift",
            "The emptiness between thoughts made manifest.",
            SynergyType.Dual,
            Rarity.Legendary,
            true
        ));
        
        _addSynergy(255, 255, 4, 5, Synergy( // Venom + Poisoning
            "Toxic Convergence",
            "When all poisons meet, life itself recoils.",
            SynergyType.Dual,
            Rarity.Epic,
            true
        ));
    }
    
    function _addSynergy(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse,
        Synergy memory synergy
    ) private {
        bytes32 key = keccak256(abi.encodePacked(species, equipment, realm, curse));
        synergies[key] = synergy;
    }
}