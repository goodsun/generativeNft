// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterMetadataBank
 * @notice MetadataBank for the Monster NFT generation system
 * @dev Implements the full generation logic from the JavaScript system
 */
contract MonsterMetadataBank is IMetadataBank {
    using Strings for uint256;
    
    // ============ Attributes (10 each) ============
    string[10] private species = [
        "Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon",
        "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"
    ];
    
    string[10] private equipment = [
        "Crown", "Sword", "Shield", "Poison", "Torch",
        "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"
    ];
    
    string[10] private realms = [
        "Bloodmoon", "Abyss", "Decay", "Corruption", "Venom",
        "Void", "Inferno", "Frost", "Ragnarok", "Shadow"
    ];
    
    string[10] private curses = [
        "Seizure", "Mind Blast", "Confusion", "Meteor", "Bats",
        "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"
    ];
    
    // Realm colors for backgrounds
    string[10] private realmColors = [
        "#FFE66D", "#00F5FF", "#AAD576", "#D64545", "#FFC0CB",
        "#51355A", "#FFA500", "#E0FFFF", "#FFFFE0", "#A9A9A9"
    ];
    
    uint256[10] private hueRotations = [
        0, 200, 90, 270, 330, 240, 15, 180, 45, 0
    ];
    
    // ============ Synergies ============
    struct Synergy {
        uint8 s; // species index (255 = any)
        uint8 e; // equipment index (255 = any)
        uint8 r; // realm index (255 = any)
        uint8 c; // curse index (255 = any)
        string title;
        string story;
        uint8 rarity; // 0=Common, 1=Uncommon, 2=Rare, 3=Epic, 4=Legendary, 5=Mythic
    }
    
    // Packed synergy storage for gas efficiency
    Synergy[] public quadSynergies;
    Synergy[] public trinitySynergies;
    Synergy[] public dualSynergies;
    
    // Special IDs with custom data
    mapping(uint256 => Synergy) public legendaryIds;
    
    // Equipment transformations for synergies
    mapping(uint8 => uint8) private equipmentTransform;
    
    constructor() {
        // Equipment transformations
        equipmentTransform[8] = 255; // Shoulder Armor → Arm (special marker)
        equipmentTransform[9] = 254; // Amulet → Head (special marker)
        
        _initializeQuadSynergies();
        _initializeTrinitySynergies();
        _initializeDualSynergies();
        _initializeLegendaryIds();
    }
    
    function _initializeQuadSynergies() private {
        // Dragon + Crown + Ragnarok + Meteor
        quadSynergies.push(Synergy(4, 0, 8, 3, 
            "Cosmic Sovereign", 
            "The cosmic ruler who brings the end times. Its crown channels meteor storms that herald the final days.",
            5
        ));
        
        // Skeleton + Scythe + Shadow + Mind Blast
        quadSynergies.push(Synergy(9, 6, 9, 1,
            "Soul Harvester",
            "The ultimate reaper of souls. Its psychic scythe cuts through both flesh and consciousness.",
            5
        ));
        
        // Vampire + Wine + Bloodmoon + Bats
        quadSynergies.push(Synergy(6, 5, 0, 4,
            "Crimson Lord",
            "Under the blood moon, the crimson ruler commands legions of bats. The ancient vampire lord in its truest form.",
            5
        ));
        
        // Add more quad synergies...
    }
    
    function _initializeTrinitySynergies() private {
        // Dragon + Sword + Burning
        trinitySynergies.push(Synergy(4, 1, 255, 8,
            "Primordial Flame Lord",
            "The original fire drake wielding a blade forged in creation's flames.",
            4
        ));
        
        // Vampire + Wine + Bats (auto-legendary)
        trinitySynergies.push(Synergy(6, 5, 255, 4,
            "Classic Nosferatu",
            "The iconic vampire in its most traditional form - wine, blood, and winged servants.",
            4
        ));
        
        // Species-agnostic: Poison + Venom + Poisoning
        trinitySynergies.push(Synergy(255, 3, 4, 5,
            "Toxic Trinity",
            "The perfect convergence of all toxic forces.",
            3
        ));
        
        // Add more trinity synergies...
    }
    
    function _initializeDualSynergies() private {
        // Vampire + Wine
        dualSynergies.push(Synergy(6, 5, 255, 255,
            "Blood Sommelier",
            "A refined predator who has transcended mere survival. This vampire has cultivated an exquisite palate for the finest vintages - both wine and blood.",
            4
        ));
        
        // Skeleton + Scythe
        dualSynergies.push(Synergy(9, 6, 255, 255,
            "Death's Herald",
            "The original harbinger of doom. This skeletal reaper has collected souls since the dawn of mortality itself.",
            4
        ));
        
        // Add more dual synergies...
    }
    
    function _initializeLegendaryIds() private {
        legendaryIds[1] = Synergy(255, 255, 255, 255,
            "The Genesis",
            "The first of its kind, born from the primordial chaos. It has witnessed the birth of darkness itself.",
            4
        );
        
        legendaryIds[666] = Synergy(3, 0, 255, 255, // Force Demon + Crown
            "The Beast Awakened",
            "The prophesied destroyer has risen. Its coming was foretold in ancient texts now burned to ash.",
            4
        );
        
        legendaryIds[777] = Synergy(255, 255, 255, 255,
            "Lucky Seven",
            "Blessed or cursed with infinite fortune. Its luck comes at the cost of everyone else's fate.",
            4
        );
        
        legendaryIds[1337] = Synergy(255, 255, 255, 255,
            "The Chosen One",
            "Elite among the damned, marked by the ancient digital prophets. It speaks in forgotten codes.",
            3
        );
        
        // Add more legendary IDs...
    }
    
    /**
     * @notice Get metadata for a token ID (0-9999)
     */
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId < 10000, "Invalid token ID");
        
        // Decode attributes from token ID
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        // Check for legendary ID override
        Synergy memory legendary = legendaryIds[tokenId];
        if (bytes(legendary.title).length > 0) {
            // Override attributes if specified
            if (legendary.s != 255) s = legendary.s;
            if (legendary.e != 255) e = legendary.e;
            if (legendary.r != 255) r = legendary.r;
            if (legendary.c != 255) c = legendary.c;
        }
        
        // Check for synergies
        (Synergy memory synergy, uint8 synergyType) = checkSynergies(s, e, r, c);
        
        // Determine name and description
        string memory name;
        string memory description;
        uint8 rarity;
        
        if (bytes(legendary.title).length > 0) {
            name = string(abi.encodePacked(legendary.title, " #", tokenId.toString()));
            description = legendary.story;
            rarity = legendary.rarity;
        } else if (synergyType > 0) {
            name = string(abi.encodePacked(synergy.title, " #", tokenId.toString()));
            description = synergy.story;
            rarity = synergy.rarity;
        } else {
            name = string(abi.encodePacked("The Mythical Cursed-Nightmare #", tokenId.toString()));
            description = generateSimpleDescription(s, e, r, c);
            rarity = calculateBaseRarity(tokenId);
        }
        
        // Generate image
        string memory image = generateImage(s, e, r, c);
        
        // Build metadata JSON
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', image, '",',
            '"external_url":"https://cursed-nightmare.example.com/essay/', tokenId.toString(), '",',
            '"attributes":['
        ));
        
        // Add attributes
        json = string(abi.encodePacked(json,
            '{"trait_type":"Species","value":"', species[s], '"},',
            '{"trait_type":"Equipment","value":"', equipment[e], '"},',
            '{"trait_type":"Realm","value":"', realms[r], '"},',
            '{"trait_type":"Curse","value":"', curses[c], '"},',
            '{"trait_type":"Rarity","value":"', getRarityName(rarity), '"}'
        ));
        
        // Add synergy attributes if applicable
        if (synergyType > 0) {
            json = string(abi.encodePacked(json,
                ',{"trait_type":"Synergy Type","value":"', getSynergyTypeName(synergyType), '"}',
                ',{"trait_type":"Synergy","value":"', synergy.title, '"}'
            ));
        }
        
        // Add legendary ID attribute if applicable
        if (bytes(legendary.title).length > 0) {
            json = string(abi.encodePacked(json,
                ',{"trait_type":"Legendary ID","value":"True"}'
            ));
        }
        
        json = string(abi.encodePacked(json, ']}'));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Decode token ID into attribute indices
     */
    function decodeTokenId(uint256 tokenId) public pure returns (uint8 s, uint8 e, uint8 r, uint8 c) {
        // Use deterministic pseudo-random for each attribute
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId)));
        
        s = uint8((seed >> 0) % 10);
        e = uint8((seed >> 8) % 10);
        r = uint8((seed >> 16) % 10);
        c = uint8((seed >> 24) % 10);
    }
    
    /**
     * @notice Check for synergies
     */
    function checkSynergies(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (Synergy memory, uint8) {
        // Check equipment transformation
        uint8 transformedE = e;
        if (equipmentTransform[e] != 0) {
            // Check if transformation would create synergy
            // This is simplified - in full implementation would check all synergies
            transformedE = equipmentTransform[e];
        }
        
        // Check quad synergies (type 3)
        for (uint i = 0; i < quadSynergies.length; i++) {
            if (matchesSynergy(quadSynergies[i], s, e, r, c)) {
                return (quadSynergies[i], 3);
            }
        }
        
        // Check trinity synergies (type 2)
        for (uint i = 0; i < trinitySynergies.length; i++) {
            if (matchesSynergy(trinitySynergies[i], s, e, r, c)) {
                return (trinitySynergies[i], 2);
            }
        }
        
        // Check dual synergies (type 1)
        for (uint i = 0; i < dualSynergies.length; i++) {
            if (matchesSynergy(dualSynergies[i], s, e, r, c)) {
                return (dualSynergies[i], 1);
            }
        }
        
        return (Synergy(0, 0, 0, 0, "", "", 0), 0);
    }
    
    /**
     * @notice Check if attributes match a synergy
     */
    function matchesSynergy(Synergy memory syn, uint8 s, uint8 e, uint8 r, uint8 c) private pure returns (bool) {
        return (syn.s == 255 || syn.s == s) &&
               (syn.e == 255 || syn.e == e) &&
               (syn.r == 255 || syn.r == r) &&
               (syn.c == 255 || syn.c == c);
    }
    
    /**
     * @notice Generate dynamic story for non-synergy combinations
     */
    function generateSimpleDescription(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        return string(abi.encodePacked(
            "A ", realms[r], "-touched ", species[s], " wielding ", equipment[e], 
            ", cursed with ", curses[c], "."
        ));
    }
    
    /**
     * @notice Calculate base rarity from seed
     */
    function calculateBaseRarity(uint256 seed) private pure returns (uint8) {
        uint256 roll = (seed % 100) + 1;
        
        if (roll > 95) return 4; // Legendary
        if (roll > 85) return 3; // Epic
        if (roll > 70) return 2; // Rare
        if (roll > 50) return 1; // Uncommon
        return 0; // Common
    }
    
    /**
     * @notice Get rarity name
     */
    function getRarityName(uint8 rarity) private pure returns (string memory) {
        string[6] memory rarityNames = ["Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"];
        return rarityNames[rarity];
    }
    
    /**
     * @notice Get synergy type name
     */
    function getSynergyTypeName(uint8 synergyType) private pure returns (string memory) {
        if (synergyType == 3) return "Quad";
        if (synergyType == 2) return "Trinity";
        if (synergyType == 1) return "Dual";
        return "None";
    }
    
    /**
     * @notice Generate SVG image
     */
    function generateImage(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        // Simplified SVG generation
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">',
            '<rect width="240" height="240" fill="', realmColors[r], '"/>',
            '<circle cx="120" cy="120" r="60" fill="#', getMonsterColor(s, r), '" opacity="0.8"/>',
            '<text x="120" y="200" text-anchor="middle" font-size="14" fill="white">', species[s], '</text>',
            '</svg>'
        );
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        ));
    }
    
    /**
     * @notice Get monster color based on species and realm
     */
    function getMonsterColor(uint8 s, uint8 r) private pure returns (string memory) {
        uint256 color = uint256(keccak256(abi.encodePacked(s, r))) % 16777215;
        bytes memory buffer = new bytes(6);
        for (uint256 i = 6; i > 0; i--) {
            uint256 digit = color % 16;
            buffer[i-1] = digit < 10 ? bytes1(uint8(48 + digit)) : bytes1(uint8(87 + digit));
            color /= 16;
        }
        return string(buffer);
    }
    
    function getMetadataCount() external pure override returns (uint256) {
        return 10000;
    }
    
    function getRandomMetadata(uint256 seed) external view override returns (string memory) {
        uint256 tokenId = seed % 10000;
        return this.getMetadata(tokenId);
    }
    
    /**
     * @notice Preview attributes for a token ID
     */
    function previewToken(uint256 tokenId) external view returns (
        string memory speciesName,
        string memory equipmentName,
        string memory realmName,
        string memory curseName,
        string memory rarity,
        bool hasSynergy,
        bool isLegendary
    ) {
        require(tokenId < 10000, "Invalid token ID");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        speciesName = species[s];
        equipmentName = equipment[e];
        realmName = realms[r];
        curseName = curses[c];
        
        // Check synergies
        (, uint8 synergyType) = checkSynergies(s, e, r, c);
        hasSynergy = synergyType > 0;
        
        // Check legendary status and get rarity
        isLegendary = bytes(legendaryIds[tokenId].title).length > 0;
        
        if (isLegendary) {
            rarity = getRarityName(legendaryIds[tokenId].rarity);
        } else if (hasSynergy) {
            (Synergy memory synergy, ) = checkSynergies(s, e, r, c);
            rarity = getRarityName(synergy.rarity);
        } else {
            rarity = getRarityName(calculateBaseRarity(tokenId));
        }
    }
}