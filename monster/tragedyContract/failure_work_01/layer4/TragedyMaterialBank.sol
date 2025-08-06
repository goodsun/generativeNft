// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TragedyEquipmentSVGLib.sol";
import "./TragedyEffectSVGLib.sol";
import "./TragedyBackgroundSVGLib.sol";

/**
 * @title ITragedyMaterialBank
 * @notice Interface for Tragedy NFT material storage
 */
interface ITragedyMaterialBank {
    // SVG getters (Species moved to separate contract)
    function getEquipmentSVG(uint8 id) external view returns (string memory);
    function getBackgroundSVG(uint8 id) external view returns (string memory);
    function getEffectSVG(uint8 id) external view returns (string memory);
    
    // Name getters
    function getSpeciesName(uint8 id) external view returns (string memory);
    function getEquipmentName(uint8 id) external view returns (string memory);
    function getRealmName(uint8 id) external view returns (string memory);
    function getCurseName(uint8 id) external view returns (string memory);
}

/**
 * @title TragedyMaterialBank
 * @notice Storage for all Tragedy NFT visual and text materials
 * @dev Uses libraries to reduce contract size
 */
contract TragedyMaterialBank is ITragedyMaterialBank {
    
    // Attribute names
    string[10] private speciesNames = [
        "Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon",
        "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"
    ];
    
    string[10] private equipmentNames = [
        "Crown", "Sword", "Shield", "Poison", "Torch",
        "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"
    ];
    
    string[10] private realmNames = [
        "Bloodmoon", "Abyss", "Decay", "Corruption", "Venom",
        "Void", "Inferno", "Frost", "Ragnarok", "Shadow"
    ];
    
    string[10] private curseNames = [
        "Seizure", "Mind Blast", "Confusion", "Meteor", "Bats",
        "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"
    ];
    
    // Name getters
    function getSpeciesName(uint8 id) external view override returns (string memory) {
        require(id < 10, "Invalid species ID");
        return speciesNames[id];
    }
    
    function getEquipmentName(uint8 id) external view override returns (string memory) {
        require(id < 10, "Invalid equipment ID");
        return equipmentNames[id];
    }
    
    function getRealmName(uint8 id) external view override returns (string memory) {
        require(id < 10, "Invalid realm ID");
        return realmNames[id];
    }
    
    function getCurseName(uint8 id) external view override returns (string memory) {
        require(id < 10, "Invalid curse ID");
        return curseNames[id];
    }
    
    // SVG getters using libraries (Monster SVGs moved to separate contract)
    
    function getEquipmentSVG(uint8 id) external pure override returns (string memory) {
        if (id == 0) return TragedyEquipmentSVGLib.getCrownSVG();
        if (id == 1) return TragedyEquipmentSVGLib.getSwordSVG();
        if (id == 2) return TragedyEquipmentSVGLib.getShieldSVG();
        if (id == 3) return TragedyEquipmentSVGLib.getPoisonSVG();
        if (id == 4) return TragedyEquipmentSVGLib.getTorchSVG();
        if (id == 5) return TragedyEquipmentSVGLib.getWineSVG();
        if (id == 6) return TragedyEquipmentSVGLib.getScytheSVG();
        if (id == 7) return TragedyEquipmentSVGLib.getMagicWandSVG();
        if (id == 8) return TragedyEquipmentSVGLib.getShoulderArmorSVG();
        if (id == 9) return TragedyEquipmentSVGLib.getAmuletSVG();
        revert("Invalid equipment ID");
    }
    
    function getBackgroundSVG(uint8 id) external pure override returns (string memory) {
        if (id == 0) return TragedyBackgroundSVGLib.getBloodmoonBG();
        if (id == 1) return TragedyBackgroundSVGLib.getAbyssBG();
        if (id == 2) return TragedyBackgroundSVGLib.getDecayBG();
        if (id == 3) return TragedyBackgroundSVGLib.getCorruptionBG();
        if (id == 4) return TragedyBackgroundSVGLib.getVenomBG();
        if (id == 5) return TragedyBackgroundSVGLib.getVoidBG();
        if (id == 6) return TragedyBackgroundSVGLib.getInfernoBG();
        if (id == 7) return TragedyBackgroundSVGLib.getFrostBG();
        if (id == 8) return TragedyBackgroundSVGLib.getRagnarokBG();
        if (id == 9) return TragedyBackgroundSVGLib.getShadowBG();
        revert("Invalid background ID");
    }
    
    function getEffectSVG(uint8 id) external pure override returns (string memory) {
        if (id == 0) return TragedyEffectSVGLib.getSeizureEffect();
        if (id == 1) return TragedyEffectSVGLib.getMindBlastEffect();
        if (id == 2) return TragedyEffectSVGLib.getConfusionEffect();
        if (id == 3) return TragedyEffectSVGLib.getMeteorEffect();
        if (id == 4) return TragedyEffectSVGLib.getBatsEffect();
        if (id == 5) return TragedyEffectSVGLib.getPoisoningEffect();
        if (id == 6) return TragedyEffectSVGLib.getLightningEffect();
        if (id == 7) return TragedyEffectSVGLib.getBlizzardEffect();
        if (id == 8) return TragedyEffectSVGLib.getBurningEffect();
        if (id == 9) return TragedyEffectSVGLib.getBrainWashEffect();
        revert("Invalid effect ID");
    }
}