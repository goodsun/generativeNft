// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedySimpleMetadataBank
 * @notice Simple metadata storage for Tragedy NFT attributes
 */
contract TragedySimpleMetadataBank {
    
    // Species names
    function getSpeciesNames(uint8 id) external pure returns (string memory, string memory) {
        if (id == 0) return ("Werewolf", unicode"人狼");
        if (id == 1) return ("Goblin", unicode"ゴブリン");
        if (id == 2) return ("Frankenstein", unicode"フランケンシュタイン");
        if (id == 3) return ("Demon", unicode"悪魔");
        if (id == 4) return ("Dragon", unicode"ドラゴン");
        if (id == 5) return ("Zombie", unicode"ゾンビ");
        if (id == 6) return ("Vampire", unicode"吸血鬼");
        if (id == 7) return ("Mummy", unicode"ミイラ");
        if (id == 8) return ("Succubus", unicode"サキュバス");
        if (id == 9) return ("Skeleton", unicode"スケルトン");
        revert("Invalid species ID");
    }
    
    // Background names
    function getBackgroundNames(uint8 id) external pure returns (string memory, string memory) {
        if (id == 0) return ("Bloodmoon", unicode"血月");
        if (id == 1) return ("Abyss", unicode"深淵");
        if (id == 2) return ("Decay", unicode"腐敗");
        if (id == 3) return ("Corruption", unicode"堕落");
        if (id == 4) return ("Venom", unicode"毒");
        if (id == 5) return ("Void", unicode"虚無");
        if (id == 6) return ("Inferno", unicode"業火");
        if (id == 7) return ("Frost", unicode"凍結");
        if (id == 8) return ("Ragnarok", unicode"終末");
        if (id == 9) return ("Shadow", unicode"影");
        revert("Invalid background ID");
    }
    
    // Item names
    function getItemNames(uint8 id) external pure returns (string memory, string memory) {
        if (id == 0) return ("Crown", unicode"王冠");
        if (id == 1) return ("Sword", unicode"剣");
        if (id == 2) return ("Shield", unicode"盾");
        if (id == 3) return ("Poison", unicode"毒薬");
        if (id == 4) return ("Torch", unicode"松明");
        if (id == 5) return ("Wine", unicode"ワイン");
        if (id == 6) return ("Scythe", unicode"大鎌");
        if (id == 7) return ("Staff", unicode"杖");
        if (id == 8) return ("Shoulder", unicode"肩当て");
        if (id == 9) return ("Amulet", unicode"護符");
        revert("Invalid item ID");
    }
    
    // Effect names
    function getEffectNames(uint8 id) external pure returns (string memory, string memory) {
        if (id == 0) return ("Seizure", unicode"発作");
        if (id == 1) return ("Mindblast", unicode"精神崩壊");
        if (id == 2) return ("Confusion", unicode"混乱");
        if (id == 3) return ("Meteor", unicode"流星");
        if (id == 4) return ("Bats", unicode"蝙蝠");
        if (id == 5) return ("Poisoning", unicode"毒霧");
        if (id == 6) return ("Lightning", unicode"雷撃");
        if (id == 7) return ("Blizzard", unicode"吹雪");
        if (id == 8) return ("Burning", unicode"燃焼");
        if (id == 9) return ("Brainwash", unicode"洗脳");
        revert("Invalid effect ID");
    }
}