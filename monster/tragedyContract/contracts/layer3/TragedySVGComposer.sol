// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../layer4/TragedyMaterialBank.sol";
import "../layer4/TragedyMonsterMaterialBank.sol";

/**
 * @title ITragedySVGComposer
 * @notice Interface for composing SVG from multiple layers
 */
interface ITragedySVGComposer {
    function composeSVG(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (string memory);
    
    function setMaterialBank(address bank) external;
    function setMonsterMaterialBank(address bank) external;
}

/**
 * @title TragedySVGComposer
 * @notice Composes final SVG from MaterialBank assets
 */
contract TragedySVGComposer is ITragedySVGComposer {
    ITragedyMaterialBank public materialBank;
    TragedyMonsterMaterialBank public monsterMaterialBank;
    
    // Color schemes for realms (hue-rotate values)
    uint16[10] private realmHueRotations = [
        0,    // Bloodmoon (red)
        250,  // Abyss (blue)
        130,  // Decay (brown-green)
        270,  // Corruption (purple)
        90,   // Venom (green)
        0,    // Void (no rotation)
        15,   // Inferno (orange-red)
        200,  // Frost (cyan)
        45,   // Ragnarok (yellow-orange)
        0     // Shadow (no rotation)
    ];
    
    constructor(address _materialBank, address _monsterMaterialBank) {
        materialBank = ITragedyMaterialBank(_materialBank);
        monsterMaterialBank = TragedyMonsterMaterialBank(_monsterMaterialBank);
    }
    
    function setMaterialBank(address bank) external override {
        materialBank = ITragedyMaterialBank(bank);
    }
    
    function setMonsterMaterialBank(address bank) external override {
        monsterMaterialBank = TragedyMonsterMaterialBank(bank);
    }
    
    function composeSVG(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view override returns (string memory) {
        require(species < 10, "Invalid species");
        require(equipment < 10, "Invalid equipment");
        require(realm < 10, "Invalid realm");
        require(curse < 10, "Invalid curse");
        
        return string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="240" height="240">',
            '<defs>',
            _getFilter(realm),
            '</defs>',
            // Background layer
            materialBank.getBackgroundSVG(realm),
            // Monster layer with color filter
            '<g filter="url(#realmFilter)">',
            monsterMaterialBank.getSpeciesSVG(species),
            '</g>',
            // Equipment layer
            _positionEquipment(equipment),
            // Effect layer
            materialBank.getEffectSVG(curse),
            '</svg>'
        ));
    }
    
    function _getFilter(uint8 realm) private view returns (string memory) {
        uint16 hueRotate = realmHueRotations[realm];
        
        if (hueRotate == 0 && realm != 0 && realm != 5 && realm != 9) {
            // No filter needed for realms without color transformation
            return '';
        }
        
        return string(abi.encodePacked(
            '<filter id="realmFilter">',
            '<feColorMatrix type="hueRotate" values="',
            _uint2str(hueRotate),
            '"/>',
            '<feColorMatrix type="saturate" values="1.5"/>',
            '</filter>'
        ));
    }
    
    function _positionEquipment(uint8 equipment) private view returns (string memory) {
        string memory svg = materialBank.getEquipmentSVG(equipment);
        
        // Position based on equipment type
        if (equipment == 0) { // Crown
            return string(abi.encodePacked(
                '<g transform="translate(0, -6)">',
                svg,
                '</g>'
            ));
        } else if (equipment == 9) { // Amulet
            return string(abi.encodePacked(
                '<g transform="translate(0, -3)">',
                svg,
                '</g>'
            ));
        } else if (equipment == 2) { // Shield
            return string(abi.encodePacked(
                '<g transform="translate(-4, 0)">',
                svg,
                '</g>'
            ));
        } else if (equipment == 1) { // Sword
            return string(abi.encodePacked(
                '<g transform="translate(4, 0)">',
                svg,
                '</g>'
            ));
        }
        
        // Default position for other equipment
        return svg;
    }
    
    function _uint2str(uint256 value) private pure returns (string memory) {
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
}