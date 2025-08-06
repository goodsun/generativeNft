// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./libraries/Base64.sol";
import "./ArweaveTragedyComposerV4.sol";
import "./ArweaveMonsterBank.sol";
import "./ArweaveBackgroundBank.sol";
import "./ArweaveItemBank.sol";
import "./ArweaveEffectBank.sol";

interface IArweaveTragedyComposer {
    function composeSVG(uint8 species, uint8 background, uint8 item, uint8 effect) external view returns (string memory);
    function filterParams(uint8) external view returns (uint16, uint16, uint16);
    function monsterBank() external view returns (address);
    function itemBank() external view returns (address);
    function backgroundBank() external view returns (address);
    function effectBank() external view returns (address);
}

contract TragedyMetadataV3 {
    IArweaveTragedyComposer public composer;
    
    struct SynergyResult {
        bool found;
        string title;
        string description;
        uint8 synergyType; // 2=dual, 3=trinity, 4=quad
    }
    
    constructor(address _composer) {
        composer = IArweaveTragedyComposer(_composer);
    }
    
    function decodeTokenId(uint256 tokenId) public pure returns (uint8 species, uint8 background, uint8 item, uint8 effect) {
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId)));
        species = uint8(seed % 10);
        background = uint8((seed >> 8) % 10);
        item = uint8((seed >> 16) % 10);
        effect = uint8((seed >> 24) % 10);
    }
    
    // IMetadataBank interface implementation
    function getMetadata(uint256 index) external view returns (string memory) {
        // Token ID is index + 1 (since token IDs start from 1)
        uint256 tokenId = index + 1;
        (uint8 species, uint8 background, uint8 item, uint8 effect) = decodeTokenId(tokenId);
        return generateMetadata(tokenId, species, background, item, effect);
    }
    
    function getMetadataCount() external pure returns (uint256) {
        return 10000; // Max supply
    }
    
    function generateMetadata(
        uint256 tokenId,
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) public view returns (string memory) {
        // Get SVG from composer
        string memory svg = composer.composeSVG(species, background, item, effect);
        
        // Get names from banks
        string memory monsterName = ArweaveMonsterBank(address(composer.monsterBank())).getMonsterName(species);
        string memory backgroundName = ArweaveBackgroundBank(address(composer.backgroundBank())).getBackgroundName(background);
        string memory itemName = ArweaveItemBank(address(composer.itemBank())).getItemName(item);
        string memory effectName = ArweaveEffectBank(address(composer.effectBank())).getEffectName(effect);
        
        // Check for synergies
        SynergyResult memory synergy = checkSynergies(monsterName, backgroundName, itemName, effectName);
        
        // Get title and description
        string memory title;
        string memory description;
        
        if (synergy.found) {
            title = synergy.title;
            description = synergy.description;
        } else {
            // Generate narrative title and description
            title = generateNarrativeTitle(monsterName, backgroundName, itemName, effectName, tokenId);
            description = generateNarrativeDescription(monsterName, backgroundName, itemName, effectName);
        }
        
        // Get filter params
        (uint16 hue, uint16 sat, uint16 bright) = composer.filterParams(background);
        
        // Build metadata JSON
        string memory json = string(abi.encodePacked(
            '{"name":"', title, '",',
            '"description":"', description, '",',
            '"image":"data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '",',
            '"attributes":['
        ));
        
        json = string(abi.encodePacked(
            json,
            '{"trait_type":"Monster","value":"', monsterName, '"},',
            '{"trait_type":"Background","value":"', backgroundName, '"},',
            '{"trait_type":"Item","value":"', itemName, '"},',
            '{"trait_type":"Effect","value":"', effectName, '"},'
        ));
        
        // Add synergy attribute if found
        if (synergy.found) {
            string memory synergyTypeStr;
            if (synergy.synergyType == 4) synergyTypeStr = "Quad";
            else if (synergy.synergyType == 3) synergyTypeStr = "Trinity";
            else synergyTypeStr = "Dual";
            
            json = string(abi.encodePacked(
                json,
                '{"trait_type":"Synergy","value":"', synergyTypeStr, '"},'
            ));
        }
        
        json = string(abi.encodePacked(
            json,
            '{"trait_type":"Hue Rotation","value":', toString(hue), '},',
            '{"trait_type":"Saturation","value":', toString(sat), '},',
            '{"trait_type":"Brightness","value":', toString(bright), '}'
        ));
        
        json = string(abi.encodePacked(json, ']}'));
        
        return string(abi.encodePacked(
            'data:application/json;base64,',
            Base64.encode(bytes(json))
        ));
    }
    
    function checkSynergies(
        string memory monster,
        string memory background,
        string memory item,
        string memory effect
    ) internal pure returns (SynergyResult memory) {
        // Check Quad Synergies first (highest priority)
        
        // Cosmic Sovereign: Dragon + Crown + Ragnarok + Meteor
        if (keccak256(bytes(monster)) == keccak256(bytes("Dragon")) &&
            keccak256(bytes(item)) == keccak256(bytes("Crown")) &&
            keccak256(bytes(background)) == keccak256(bytes("Ragnarok")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Meteor"))) {
            return SynergyResult(true, "Cosmic Sovereign", "The cosmic ruler who brings the end times. Its crown channels meteor storms that herald the final days.", 4);
        }
        
        // Soul Harvester: Skeleton + Scythe + Shadow + Mindblast
        if (keccak256(bytes(monster)) == keccak256(bytes("Skeleton")) &&
            keccak256(bytes(item)) == keccak256(bytes("Scythe")) &&
            keccak256(bytes(background)) == keccak256(bytes("Shadow")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Mindblast"))) {
            return SynergyResult(true, "Soul Harvester", "The ultimate reaper of souls. Its psychic scythe cuts through both flesh and consciousness.", 4);
        }
        
        // Crimson Lord: Vampire + Wine + Bloodmoon + Bats
        if (keccak256(bytes(monster)) == keccak256(bytes("Vampire")) &&
            keccak256(bytes(item)) == keccak256(bytes("Wine")) &&
            keccak256(bytes(background)) == keccak256(bytes("Bloodmoon")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Bats"))) {
            return SynergyResult(true, "Crimson Lord", "Under the blood moon, the crimson ruler commands legions of bats. The ancient vampire lord in its truest form.", 4);
        }
        
        // Hellstorm Avatar: Demon + Torch + Inferno + Lightning
        if (keccak256(bytes(monster)) == keccak256(bytes("Demon")) &&
            keccak256(bytes(item)) == keccak256(bytes("Torch")) &&
            keccak256(bytes(background)) == keccak256(bytes("Inferno")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Lightning"))) {
            return SynergyResult(true, "Hellstorm Avatar", "The incarnation of hell's tempest. Lightning-wreathed flames announce its apocalyptic arrival.", 4);
        }
        
        // Mind Empress: Succubus + Staff + Corruption + Brainwash
        if (keccak256(bytes(monster)) == keccak256(bytes("Succubus")) &&
            keccak256(bytes(item)) == keccak256(bytes("Staff")) && // Magic Wand -> Staff
            keccak256(bytes(background)) == keccak256(bytes("Corruption")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Brainwash"))) {
            return SynergyResult(true, "Mind Empress", "The corrupted empress who enslaves minds. Her wand weaves thoughts into chains of eternal servitude.", 4);
        }
        
        // Eternal Warrior: Mummy + Sword + Void + Burning
        if (keccak256(bytes(monster)) == keccak256(bytes("Mummy")) &&
            keccak256(bytes(item)) == keccak256(bytes("Sword")) &&
            keccak256(bytes(background)) == keccak256(bytes("Void")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Burning"))) {
            return SynergyResult(true, "Eternal Warrior", "An immortal ancient warrior wrapped in void flames. Time means nothing to this burning guardian.", 4);
        }
        
        // Toxic Abomination: Frankenstein + Poison + Venom + Seizure
        if (keccak256(bytes(monster)) == keccak256(bytes("Frankenstein")) &&
            keccak256(bytes(item)) == keccak256(bytes("Poison")) &&
            keccak256(bytes(background)) == keccak256(bytes("Venom")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Seizure"))) {
            return SynergyResult(true, "Toxic Abomination", "An undying monster saturated with poison. Its body convulses eternally from the toxins it cannot expel.", 4);
        }
        
        // Lunatic Alpha: Werewolf + Amulet + Abyss + Confusion (Head -> Amulet)
        if (keccak256(bytes(monster)) == keccak256(bytes("Werewolf")) &&
            keccak256(bytes(item)) == keccak256(bytes("Amulet")) &&
            keccak256(bytes(background)) == keccak256(bytes("Abyss")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Confusion"))) {
            return SynergyResult(true, "Lunatic Alpha", "The pack leader consumed by abyssal madness. It carries trophies of those who challenged its insanity.", 4);
        }
        
        // Rotting Collector: Zombie + Shoulder + Decay + Poisoning (Arm -> Shoulder)
        if (keccak256(bytes(monster)) == keccak256(bytes("Zombie")) &&
            keccak256(bytes(item)) == keccak256(bytes("Shoulder")) &&
            keccak256(bytes(background)) == keccak256(bytes("Decay")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Poisoning"))) {
            return SynergyResult(true, "Rotting Collector", "A putrid corpse collector spreading toxic decay. Each arm in its collection tells a story of plague.", 4);
        }
        
        // Frozen Guardian: Goblin + Shield + Frost + Blizzard
        if (keccak256(bytes(monster)) == keccak256(bytes("Goblin")) &&
            keccak256(bytes(item)) == keccak256(bytes("Shield")) &&
            keccak256(bytes(background)) == keccak256(bytes("Frost")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Blizzard"))) {
            return SynergyResult(true, "Frozen Guardian", "The ice sprite defending eternal permafrost. Its shield channels blizzards that freeze time itself.", 4);
        }
        
        // Check Trinity Synergies
        
        // Fire Trinity: Dragon + Sword + Burning
        if (keccak256(bytes(monster)) == keccak256(bytes("Dragon")) &&
            keccak256(bytes(item)) == keccak256(bytes("Sword")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Burning"))) {
            return SynergyResult(true, "Primordial Flame Lord", "The original fire drake wielding a blade forged in creation's flames.", 3);
        }
        
        // Hell's Gatekeeper: Demon + Torch + Inferno
        if (keccak256(bytes(monster)) == keccak256(bytes("Demon")) &&
            keccak256(bytes(item)) == keccak256(bytes("Torch")) &&
            keccak256(bytes(background)) == keccak256(bytes("Inferno"))) {
            return SynergyResult(true, "Hell's Gatekeeper", "Guardian of the infernal gates, its torch lights the path to damnation.", 3);
        }
        
        // Death Incarnate: Skeleton + Scythe + Shadow
        if (keccak256(bytes(monster)) == keccak256(bytes("Skeleton")) &&
            keccak256(bytes(item)) == keccak256(bytes("Scythe")) &&
            keccak256(bytes(background)) == keccak256(bytes("Shadow"))) {
            return SynergyResult(true, "Death Incarnate", "Death given form, harvesting souls in shadow's embrace.", 3);
        }
        
        // Undead Overlord: Zombie + Amulet + Decay (Head -> Amulet)
        if (keccak256(bytes(monster)) == keccak256(bytes("Zombie")) &&
            keccak256(bytes(item)) == keccak256(bytes("Amulet")) &&
            keccak256(bytes(background)) == keccak256(bytes("Decay"))) {
            return SynergyResult(true, "Undead Overlord", "The first risen, commanding legions with severed heads as trophies.", 3);
        }
        
        // Mind Seductress: Succubus + Wine + Brainwash
        if (keccak256(bytes(monster)) == keccak256(bytes("Succubus")) &&
            keccak256(bytes(item)) == keccak256(bytes("Wine")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Brainwash"))) {
            return SynergyResult(true, "Mind Seductress", "She who intoxicates minds with cursed wine and forbidden desires.", 3);
        }
        
        // Psychic Monarch: Vampire + Crown + Mindblast
        if (keccak256(bytes(monster)) == keccak256(bytes("Vampire")) &&
            keccak256(bytes(item)) == keccak256(bytes("Crown")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Mindblast"))) {
            return SynergyResult(true, "Psychic Monarch", "The vampire king whose crown amplifies psychic dominion.", 3);
        }
        
        // Classic Nosferatu: Vampire + Wine + Bats
        if (keccak256(bytes(monster)) == keccak256(bytes("Vampire")) &&
            keccak256(bytes(item)) == keccak256(bytes("Wine")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Bats"))) {
            return SynergyResult(true, "Classic Nosferatu", "The iconic vampire in its most traditional form - wine, blood, and winged servants.", 3);
        }
        
        // Lunar Beast: Werewolf + Shoulder + Bloodmoon (Arm -> Shoulder)
        if (keccak256(bytes(monster)) == keccak256(bytes("Werewolf")) &&
            keccak256(bytes(item)) == keccak256(bytes("Shoulder")) &&
            keccak256(bytes(background)) == keccak256(bytes("Bloodmoon"))) {
            return SynergyResult(true, "Lunar Beast", "Under the blood moon, the beast collects arms of fallen hunters.", 3);
        }
        
        // Ancient Apocalypse: Mummy + Void + Ragnarok
        if (keccak256(bytes(monster)) == keccak256(bytes("Mummy")) &&
            keccak256(bytes(background)) == keccak256(bytes("Void")) &&
            keccak256(bytes(background)) == keccak256(bytes("Ragnarok"))) {
            return SynergyResult(true, "Ancient Apocalypse", "The void-touched pharaoh who brings the end of ages.", 3);
        }
        
        // Aberrant Creation: Frankenstein + Lightning + Seizure
        if (keccak256(bytes(monster)) == keccak256(bytes("Frankenstein")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Lightning")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Seizure"))) {
            return SynergyResult(true, "Aberrant Creation", "Lightning-born abomination wracked by eternal spasms.", 3);
        }
        
        // Mad Trickster: Goblin + Corruption + Confusion
        if (keccak256(bytes(monster)) == keccak256(bytes("Goblin")) &&
            keccak256(bytes(background)) == keccak256(bytes("Corruption")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Confusion"))) {
            return SynergyResult(true, "Mad Trickster", "A corrupted goblin spreading chaos through mind-bending pranks.", 3);
        }
        
        // Species-agnostic Trinity Synergies
        
        // Toxic Trinity: Poison + Venom + Poisoning
        if (keccak256(bytes(item)) == keccak256(bytes("Poison")) &&
            keccak256(bytes(background)) == keccak256(bytes("Venom")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Poisoning"))) {
            return SynergyResult(true, "Toxic Trinity", "The perfect convergence of all toxic forces.", 3);
        }
        
        // Frozen Fortress: Shield + Frost + Blizzard
        if (keccak256(bytes(item)) == keccak256(bytes("Shield")) &&
            keccak256(bytes(background)) == keccak256(bytes("Frost")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Blizzard"))) {
            return SynergyResult(true, "Frozen Fortress", "An impenetrable defense of eternal winter.", 3);
        }
        
        // Cosmic Sorcery: Staff + Abyss + Meteor
        if (keccak256(bytes(item)) == keccak256(bytes("Staff")) &&
            keccak256(bytes(background)) == keccak256(bytes("Abyss")) &&
            keccak256(bytes(effect)) == keccak256(bytes("Meteor"))) {
            return SynergyResult(true, "Cosmic Sorcery", "Deep space magic calling meteors from the abyss.", 3);
        }
        
        // Check Dual Synergies
        
        // Species + Equipment combos
        if (keccak256(bytes(monster)) == keccak256(bytes("Vampire")) &&
            keccak256(bytes(item)) == keccak256(bytes("Wine"))) {
            return SynergyResult(true, "Blood Sommelier", "A refined predator who has transcended mere survival. This vampire has cultivated an exquisite palate for the finest vintages - both wine and blood.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Skeleton")) &&
            keccak256(bytes(item)) == keccak256(bytes("Scythe"))) {
            return SynergyResult(true, "Death's Herald", "The original harbinger of doom. This skeletal reaper has collected souls since the dawn of mortality itself.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Dragon")) &&
            keccak256(bytes(item)) == keccak256(bytes("Crown"))) {
            return SynergyResult(true, "The Fallen Monarch", "Once ruled the skies with absolute authority. Now seeks to reclaim the throne stolen by lesser beings.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Demon")) &&
            keccak256(bytes(item)) == keccak256(bytes("Torch"))) {
            return SynergyResult(true, "Infernal Lightkeeper", "Guardian of the eternal flames that bridge the mortal realm and the underworld. Its torch never extinguishes.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Werewolf")) &&
            keccak256(bytes(item)) == keccak256(bytes("Amulet"))) { // Head -> Amulet
            return SynergyResult(true, "The Alpha's Trophy", "This werewolf carries the severed head of its pack's former leader, a grim reminder of the brutal law of nature.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Frankenstein")) &&
            keccak256(bytes(item)) == keccak256(bytes("Shoulder"))) { // Arm -> Shoulder
            return SynergyResult(true, "The Collector", "An abomination that grafts new limbs onto itself, growing stronger with each defeated foe.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Mummy")) &&
            keccak256(bytes(item)) == keccak256(bytes("Staff"))) { // Magic Wand -> Staff
            return SynergyResult(true, "Pharaoh's Awakening", "An ancient ruler risen from eternal slumber, wielding the wand of divine authority.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Goblin")) &&
            keccak256(bytes(item)) == keccak256(bytes("Sword"))) {
            return SynergyResult(true, "Blade Master", "A goblin warrior who mastered the way of the blade through centuries of combat.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Succubus")) &&
            keccak256(bytes(item)) == keccak256(bytes("Shield"))) {
            return SynergyResult(true, "Temptress Guardian", "A succubus who protects her victims from other demons, keeping them for herself.", 2);
        }
        
        if (keccak256(bytes(monster)) == keccak256(bytes("Zombie")) &&
            keccak256(bytes(item)) == keccak256(bytes("Poison"))) {
            return SynergyResult(true, "Patient Zero", "The original infected. Its toxic blood spawned the great plague that consumed civilizations.", 2);
        }
        
        // Effect + Background combos
        if ((keccak256(bytes(effect)) == keccak256(bytes("Burning")) && keccak256(bytes(background)) == keccak256(bytes("Inferno"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Inferno")) && keccak256(bytes(effect)) == keccak256(bytes("Burning")))) {
            return SynergyResult(true, "Eternal Flame", "Fire that burns without fuel, consuming reality itself.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Blizzard")) && keccak256(bytes(background)) == keccak256(bytes("Frost"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Frost")) && keccak256(bytes(effect)) == keccak256(bytes("Blizzard")))) {
            return SynergyResult(true, "Absolute Zero", "Where ice meets storm, nothing survives.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Poisoning")) && keccak256(bytes(background)) == keccak256(bytes("Venom"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Venom")) && keccak256(bytes(effect)) == keccak256(bytes("Poisoning")))) {
            return SynergyResult(true, "Toxic Miasma", "A poisonous fog that corrupts all it touches.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Mindblast")) && keccak256(bytes(background)) == keccak256(bytes("Void"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Void")) && keccak256(bytes(effect)) == keccak256(bytes("Mindblast")))) {
            return SynergyResult(true, "Mental Collapse", "The void between thoughts where sanity dies.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Lightning")) && keccak256(bytes(background)) == keccak256(bytes("Bloodmoon"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Bloodmoon")) && keccak256(bytes(effect)) == keccak256(bytes("Lightning")))) {
            return SynergyResult(true, "Crimson Thunder", "Blood-red lightning that strikes with divine wrath.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Brainwash")) && keccak256(bytes(background)) == keccak256(bytes("Corruption"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Corruption")) && keccak256(bytes(effect)) == keccak256(bytes("Brainwash")))) {
            return SynergyResult(true, "Mind Corruption", "Thoughts twisted into weapons against their owner.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Meteor")) && keccak256(bytes(background)) == keccak256(bytes("Ragnarok"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Ragnarok")) && keccak256(bytes(effect)) == keccak256(bytes("Meteor")))) {
            return SynergyResult(true, "Apocalypse Rain", "The sky falls, bringing the end of all things.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Bats")) && keccak256(bytes(background)) == keccak256(bytes("Shadow"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Shadow")) && keccak256(bytes(effect)) == keccak256(bytes("Bats")))) {
            return SynergyResult(true, "Night Terror", "Living shadows that feast on fear.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Confusion")) && keccak256(bytes(background)) == keccak256(bytes("Decay"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Decay")) && keccak256(bytes(effect)) == keccak256(bytes("Confusion")))) {
            return SynergyResult(true, "Madness Plague", "A disease that rots both mind and body.", 2);
        }
        
        if ((keccak256(bytes(effect)) == keccak256(bytes("Seizure")) && keccak256(bytes(background)) == keccak256(bytes("Abyss"))) ||
            (keccak256(bytes(background)) == keccak256(bytes("Abyss")) && keccak256(bytes(effect)) == keccak256(bytes("Seizure")))) {
            return SynergyResult(true, "Deep Tremor", "Convulsions from staring too long into the infinite dark.", 2);
        }
        
        // No synergy found
        return SynergyResult(false, "", "", 0);
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function lowercase(string memory str) internal pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character ASCII range: 65-90
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                // Add 32 to make it lowercase
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
    
    function generateNarrativeDescription(
        string memory monster,
        string memory background,
        string memory item,
        string memory effect
    ) internal pure returns (string memory) {
        // Get realm-specific prefix
        string memory realmPrefix = getRealmPrefix(background);
        
        // Get monster-specific action
        string memory monsterAction = getMonsterAction(monster, item);
        
        // Get curse description
        string memory curseDesc = getCurseDescription(effect);
        
        return string(abi.encodePacked(
            realmPrefix, " ",
            monsterAction, " ",
            curseDesc
        ));
    }
    
    function getRealmPrefix(string memory background) internal pure returns (string memory) {
        bytes32 bgHash = keccak256(bytes(background));
        
        if (bgHash == keccak256(bytes("Bloodmoon"))) {
            return "Under the crimson gaze of the blood moon,";
        } else if (bgHash == keccak256(bytes("Abyss"))) {
            return "From the depths of the endless void,";
        } else if (bgHash == keccak256(bytes("Decay"))) {
            return "In the rotting wastelands of despair,";
        } else if (bgHash == keccak256(bytes("Corruption"))) {
            return "Where reality itself bends and breaks,";
        } else if (bgHash == keccak256(bytes("Venom"))) {
            return "In the toxic mists of the poison realm,";
        } else if (bgHash == keccak256(bytes("Void"))) {
            return "At the edge of existence itself,";
        } else if (bgHash == keccak256(bytes("Inferno"))) {
            return "Within the eternal flames of damnation,";
        } else if (bgHash == keccak256(bytes("Frost"))) {
            return "In the frozen wastes of eternal winter,";
        } else if (bgHash == keccak256(bytes("Ragnarok"))) {
            return "As the world crumbles in its final days,";
        } else { // Shadow
            return "Shrouded in darkness beyond light's reach,";
        }
    }
    
    function getMonsterAction(string memory monster, string memory item) internal pure returns (string memory) {
        bytes32 monsterHash = keccak256(bytes(monster));
        bytes32 itemHash = keccak256(bytes(item));
        
        if (monsterHash == keccak256(bytes("Dragon"))) {
            if (itemHash == keccak256(bytes("Crown"))) return "the ancient wyrm reclaims its lost dominion";
            else if (itemHash == keccak256(bytes("Sword"))) return "the scaled tyrant wields steel forged in dragonfire";
            else return "this winged terror hoards its cursed treasures";
        } else if (monsterHash == keccak256(bytes("Vampire"))) {
            if (itemHash == keccak256(bytes("Wine"))) return "the immortal noble savors its crimson vintage";
            else if (itemHash == keccak256(bytes("Crown"))) return "the vampiric lord rules from shadow throne";
            else return "this nightwalker hunts with unholy relics";
        } else if (monsterHash == keccak256(bytes("Skeleton"))) {
            if (itemHash == keccak256(bytes("Scythe"))) return "death's herald reaps the souls of the living";
            else if (itemHash == keccak256(bytes("Shield"))) return "the bone guardian stands eternal vigil";
            else return "these ancient bones clutch their final possession";
        } else if (monsterHash == keccak256(bytes("Demon"))) {
            if (itemHash == keccak256(bytes("Torch"))) return "the hellspawn lights the path to perdition";
            else if (itemHash == keccak256(bytes("Sword"))) return "the infernal warrior brings chaos incarnate";
            else return "this fiend wields instruments of torment";
        } else if (monsterHash == keccak256(bytes("Werewolf"))) {
            if (itemHash == keccak256(bytes("Amulet"))) return "the beast carries trophies of fallen prey";
            else if (itemHash == keccak256(bytes("Shoulder"))) return "the lycanthrope bears the weight of its curse";
            else return "this moonbound hunter stalks with primal fury";
        } else if (monsterHash == keccak256(bytes("Zombie"))) {
            if (itemHash == keccak256(bytes("Poison"))) return "the walking plague spreads its infection";
            else if (itemHash == keccak256(bytes("Amulet"))) return "the risen corpse clutches forbidden talismans";
            else return "this shambling horror grasps at remnants of life";
        } else if (monsterHash == keccak256(bytes("Mummy"))) {
            if (itemHash == keccak256(bytes("Staff"))) return "the ancient pharaoh commands with divine authority";
            else if (itemHash == keccak256(bytes("Sword"))) return "the bandaged warrior fights beyond death";
            else return "this entombed ruler clings to earthly power";
        } else if (monsterHash == keccak256(bytes("Succubus"))) {
            if (itemHash == keccak256(bytes("Wine"))) return "the temptress offers intoxicating corruption";
            else if (itemHash == keccak256(bytes("Staff"))) return "the seductress weaves spells of desire";
            else return "this demon of passion ensnares mortal souls";
        } else if (monsterHash == keccak256(bytes("Frankenstein"))) {
            if (itemHash == keccak256(bytes("Shoulder"))) return "the patchwork horror grafts new flesh";
            else if (itemHash == keccak256(bytes("Poison"))) return "the reanimated abomination seeps toxins";
            else return "this stitched monstrosity defies nature's law";
        } else { // Goblin
            if (itemHash == keccak256(bytes("Sword"))) return "the cunning warrior strikes from shadow";
            else if (itemHash == keccak256(bytes("Shield"))) return "the tribal defender protects its hoard";
            else return "this mischievous creature plots dark schemes";
        }
    }
    
    function getCurseDescription(string memory effect) internal pure returns (string memory) {
        bytes32 effectHash = keccak256(bytes(effect));
        
        if (effectHash == keccak256(bytes("Burning"))) {
            return "while eternal flames consume but never destroy.";
        } else if (effectHash == keccak256(bytes("Blizzard"))) {
            return "as frozen winds tear at the boundaries of reality.";
        } else if (effectHash == keccak256(bytes("Lightning"))) {
            return "beneath skies torn asunder by electric fury.";
        } else if (effectHash == keccak256(bytes("Meteor"))) {
            return "while the heavens rain destruction upon the earth.";
        } else if (effectHash == keccak256(bytes("Mindblast"))) {
            return "its psychic screams shattering sanity itself.";
        } else if (effectHash == keccak256(bytes("Brainwash"))) {
            return "enslaving minds with whispers of madness.";
        } else if (effectHash == keccak256(bytes("Confusion"))) {
            return "spreading chaos through fractured perception.";
        } else if (effectHash == keccak256(bytes("Seizure"))) {
            return "its presence causing reality to convulse.";
        } else if (effectHash == keccak256(bytes("Poisoning"))) {
            return "leaving trails of toxic death in its wake.";
        } else { // Bats
            return "commanding swarms of nightborn servants.";
        }
    }
    
    function generateNarrativeTitle(
        string memory monster,
        string memory background,
        string memory item,
        string memory effect,
        uint256 tokenId
    ) internal pure returns (string memory) {
        bytes32 monsterHash = keccak256(bytes(monster));
        bytes32 itemHash = keccak256(bytes(item));
        bytes32 backgroundHash = keccak256(bytes(background));
        
        // Create title based on specific combinations
        string memory titlePrefix;
        string memory titleCore;
        
        // Special prefixes for certain backgrounds
        if (backgroundHash == keccak256(bytes("Ragnarok"))) {
            titlePrefix = "Last ";
        } else if (backgroundHash == keccak256(bytes("Void"))) {
            titlePrefix = "Void ";
        } else if (backgroundHash == keccak256(bytes("Corruption"))) {
            titlePrefix = "Corrupted ";
        } else if (backgroundHash == keccak256(bytes("Bloodmoon"))) {
            titlePrefix = "Crimson ";
        } else if (backgroundHash == keccak256(bytes("Inferno"))) {
            titlePrefix = "Infernal ";
        } else if (backgroundHash == keccak256(bytes("Frost"))) {
            titlePrefix = "Frozen ";
        } else {
            titlePrefix = "";
        }
        
        // Generate core title based on monster and item
        if (monsterHash == keccak256(bytes("Dragon"))) {
            if (itemHash == keccak256(bytes("Sword"))) titleCore = "Wyrm Knight";
            else if (itemHash == keccak256(bytes("Shield"))) titleCore = "Scale Guardian";
            else if (itemHash == keccak256(bytes("Crown"))) titleCore = "Drake Lord";
            else titleCore = "Ancient Wyrm";
        } else if (monsterHash == keccak256(bytes("Vampire"))) {
            if (itemHash == keccak256(bytes("Wine"))) titleCore = "Blood Noble";
            else if (itemHash == keccak256(bytes("Crown"))) titleCore = "Night King";
            else titleCore = "Eternal Hunter";
        } else if (monsterHash == keccak256(bytes("Skeleton"))) {
            if (itemHash == keccak256(bytes("Scythe"))) titleCore = "Bone Reaper";
            else if (itemHash == keccak256(bytes("Shield"))) titleCore = "Undead Sentinel";
            else titleCore = "Hollow One";
        } else if (monsterHash == keccak256(bytes("Demon"))) {
            if (itemHash == keccak256(bytes("Torch"))) titleCore = "Flame Bearer";
            else if (itemHash == keccak256(bytes("Sword"))) titleCore = "Hell Blade";
            else titleCore = "Fiend Lord";
        } else if (monsterHash == keccak256(bytes("Werewolf"))) {
            if (itemHash == keccak256(bytes("Amulet"))) titleCore = "Pack Alpha";
            else if (itemHash == keccak256(bytes("Shoulder"))) titleCore = "Beast Warrior";
            else titleCore = "Moon Stalker";
        } else if (monsterHash == keccak256(bytes("Zombie"))) {
            if (itemHash == keccak256(bytes("Poison"))) titleCore = "Plague Walker";
            else if (itemHash == keccak256(bytes("Amulet"))) titleCore = "Cursed Corpse";
            else titleCore = "Shambling Dead";
        } else if (monsterHash == keccak256(bytes("Mummy"))) {
            if (itemHash == keccak256(bytes("Staff"))) titleCore = "Tomb Priest";
            else if (itemHash == keccak256(bytes("Sword"))) titleCore = "Desert Warrior";
            else titleCore = "Ancient Guard";
        } else if (monsterHash == keccak256(bytes("Succubus"))) {
            if (itemHash == keccak256(bytes("Wine"))) titleCore = "Desire Maiden";
            else if (itemHash == keccak256(bytes("Staff"))) titleCore = "Dream Weaver";
            else titleCore = "Soul Temptress";
        } else if (monsterHash == keccak256(bytes("Frankenstein"))) {
            if (itemHash == keccak256(bytes("Shoulder"))) titleCore = "Flesh Sculptor";
            else if (itemHash == keccak256(bytes("Poison"))) titleCore = "Toxic Creation";
            else titleCore = "Stitched Horror";
        } else { // Goblin
            if (itemHash == keccak256(bytes("Sword"))) titleCore = "Cave Raider";
            else if (itemHash == keccak256(bytes("Shield"))) titleCore = "Tribal Guard";
            else titleCore = "Shadow Gremlin";
        }
        
        return string(abi.encodePacked(titlePrefix, titleCore, " #", toString(tokenId)));
    }
}