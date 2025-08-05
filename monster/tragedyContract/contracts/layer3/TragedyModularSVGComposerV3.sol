// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Bank interfaces
interface IMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

interface IBackgroundBank {
    function getBackgroundSVG(uint8 id) external view returns (string memory);
}

interface IItemBank {
    function getItemSVG(uint8 id) external view returns (string memory);
}

interface IEffectBank {
    function getEffectSVG(uint8 id) external view returns (string memory);
}

/**
 * @title TragedyModularSVGComposerV3
 * @notice Simplified composer that assumes banks return complete SVGs
 */
contract TragedyModularSVGComposerV3 {
    // Bank addresses
    IMonsterBank public monsterBank;
    IBackgroundBank public backgroundBank;
    IItemBank public itemBank;
    IEffectBank public effectBank;
    
    constructor(
        address _monsterBank,
        address _backgroundBank,
        address _itemBank,
        address _effectBank
    ) {
        monsterBank = IMonsterBank(_monsterBank);
        backgroundBank = IBackgroundBank(_backgroundBank);
        itemBank = IItemBank(_itemBank);
        effectBank = IEffectBank(_effectBank);
    }
    
    /**
     * @notice Get only the monster SVG (for testing)
     */
    function getMonsterOnly(uint8 species) external view returns (string memory) {
        return monsterBank.getSpeciesSVG(species);
    }
    
    /**
     * @notice Compose without extraction - just return individual SVGs for now
     */
    function testIndividualSVGs(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (
        string memory monsterSVG,
        string memory backgroundSVG,
        string memory itemSVG,
        string memory effectSVG
    ) {
        monsterSVG = monsterBank.getSpeciesSVG(species);
        backgroundSVG = backgroundBank.getBackgroundSVG(background);
        itemSVG = itemBank.getItemSVG(item);
        effectSVG = effectBank.getEffectSVG(effect);
    }
}