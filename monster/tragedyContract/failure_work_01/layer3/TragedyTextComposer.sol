// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../layer4/TragedyMaterialBank.sol";
import "./TragedySynergyChecker.sol";

/**
 * @title TragedyTextComposer
 * @notice Generates names and descriptions for NFTs
 */
contract TragedyTextComposer {
    ITragedyMaterialBank public materialBank;
    TragedySynergyChecker public synergyChecker;
    
    // Power levels for dynamic naming
    mapping(uint8 => uint8) private equipmentPower;
    mapping(uint8 => uint8) private cursePower;
    
    // Equipment titles (based on power level)
    mapping(uint8 => string[4]) private equipmentTitles;
    
    // Curse adjectives (based on power level)
    mapping(uint8 => string[4]) private curseAdjectives;
    
    constructor(address _materialBank, address _synergyChecker) {
        materialBank = ITragedyMaterialBank(_materialBank);
        synergyChecker = TragedySynergyChecker(_synergyChecker);
        
        _initializePowerLevels();
        _initializeTitles();
    }
    
    function generateName(
        uint256 tokenId,
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (string memory) {
        // Check for synergy first
        TragedySynergyChecker.Synergy memory synergy = synergyChecker.checkSynergy(
            species, equipment, realm, curse
        );
        
        if (synergy.exists) {
            return string(abi.encodePacked(synergy.title, " #", _toString(tokenId)));
        }
        
        // Generate dynamic name based on power levels
        string memory speciesName = materialBank.getSpeciesName(species);
        string memory realmName = materialBank.getRealmName(realm);
        
        uint8 eqPower = equipmentPower[equipment];
        uint8 crPower = cursePower[curse];
        
        if (eqPower >= crPower) {
            // Equipment-based naming
            string memory title = _getEquipmentTitle(equipment, _random(tokenId) % 4);
            return string(abi.encodePacked(
                title, " ", speciesName, " on ", realmName, " #", _toString(tokenId)
            ));
        } else {
            // Curse-based naming
            string memory adjective = _getCurseAdjective(curse, _random(tokenId + 1) % 4);
            return string(abi.encodePacked(
                adjective, " ", speciesName, " on ", realmName, " #", _toString(tokenId)
            ));
        }
    }
    
    function generateDescription(
        uint256, // tokenId - not used in current implementation
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (string memory) {
        // Check for synergy first
        TragedySynergyChecker.Synergy memory synergy = synergyChecker.checkSynergy(
            species, equipment, realm, curse
        );
        
        if (synergy.exists) {
            return synergy.story;
        }
        
        // Generate dynamic description
        string memory speciesName = materialBank.getSpeciesName(species);
        string memory equipmentName = materialBank.getEquipmentName(equipment);
        string memory realmName = materialBank.getRealmName(realm);
        string memory curseName = materialBank.getCurseName(curse);
        
        return string(abi.encodePacked(
            "A ", _toLower(speciesName), " wielding ", _toLower(equipmentName),
            " in the ", _toLower(realmName), " realm, afflicted by ",
            _toLower(curseName), ". ",
            "This cursed being exists in the space between nightmare and reality."
        ));
    }
    
    function _initializePowerLevels() private {
        // Equipment power levels
        equipmentPower[0] = 9;  // Crown
        equipmentPower[1] = 7;  // Sword
        equipmentPower[2] = 5;  // Shield
        equipmentPower[3] = 4;  // Poison
        equipmentPower[4] = 3;  // Torch
        equipmentPower[5] = 2;  // Wine
        equipmentPower[6] = 8;  // Scythe
        equipmentPower[7] = 6;  // Magic Wand
        equipmentPower[8] = 1;  // Shoulder Armor
        equipmentPower[9] = 1;  // Amulet
        
        // Curse power levels
        cursePower[0] = 1;   // Seizure
        cursePower[1] = 9;   // Mind Blast
        cursePower[2] = 6;   // Confusion
        cursePower[3] = 7;   // Meteor
        cursePower[4] = 1;   // Bats
        cursePower[5] = 2;   // Poisoning
        cursePower[6] = 5;   // Lightning
        cursePower[7] = 3;   // Blizzard
        cursePower[8] = 4;   // Burning
        cursePower[9] = 8;   // Brain Wash
    }
    
    function _initializeTitles() private {
        // Crown titles
        equipmentTitles[0] = ["King", "Lord", "Monarch", "Sovereign"];
        
        // Sword titles
        equipmentTitles[1] = ["Blade", "Warrior", "Knight", "Swordmaster"];
        
        // Shield titles
        equipmentTitles[2] = ["Guardian", "Defender", "Protector", "Sentinel"];
        
        // Poison titles
        equipmentTitles[3] = ["Toxic", "Venomous", "Poisonous", "Noxious"];
        
        // Torch titles
        equipmentTitles[4] = ["Burning", "Flaming", "Torchbearer", "Ignited"];
        
        // Wine titles
        equipmentTitles[5] = ["Drunk", "Intoxicated", "Tipsy", "Inebriated"];
        
        // Scythe titles
        equipmentTitles[6] = ["Reaper", "Harvester", "Death", "Grim"];
        
        // Magic Wand titles
        equipmentTitles[7] = ["Sorcerer", "Wizard", "Mage", "Mystic"];
        
        // Shoulder Armor titles
        equipmentTitles[8] = ["Armed", "Grasping", "Reaching", "Clawed"];
        
        // Amulet titles
        equipmentTitles[9] = ["Blessed", "Charmed", "Enchanted", "Protected"];
        
        // Curse adjectives
        curseAdjectives[0] = ["Seized", "Convulsing", "Spasming", "Twitching"];
        curseAdjectives[1] = ["Psycho", "Mad", "Demented", "Insane"];
        curseAdjectives[2] = ["Confused", "Bewildered", "Lost", "Dazed"];
        curseAdjectives[3] = ["Meteoric", "Celestial", "Cosmic", "Stellar"];
        curseAdjectives[4] = ["Swarmed", "Winged", "Nocturnal", "Flying"];
        curseAdjectives[5] = ["Poisoned", "Toxic", "Infected", "Contaminated"];
        curseAdjectives[6] = ["Electric", "Shocking", "Voltaic", "Thunderous"];
        curseAdjectives[7] = ["Frozen", "Icy", "Frigid", "Arctic"];
        curseAdjectives[8] = ["Burning", "Ablaze", "Scorching", "Immolated"];
        curseAdjectives[9] = ["Hypnotized", "Controlled", "Enslaved", "Dominated"];
    }
    
    function _getEquipmentTitle(uint8 equipment, uint256 index) private view returns (string memory) {
        return equipmentTitles[equipment][index];
    }
    
    function _getCurseAdjective(uint8 curse, uint256 index) private view returns (string memory) {
        return curseAdjectives[curse][index];
    }
    
    function _random(uint256 seed) private pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed)));
    }
    
    function _toString(uint256 value) private pure returns (string memory) {
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
    
    function _toLower(string memory str) private pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            if ((bStr[i] >= 0x41) && (bStr[i] <= 0x5A)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
}