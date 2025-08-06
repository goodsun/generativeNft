// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "./MaterialBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterMetadataBankV4
 * @notice Monster metadata using MaterialBank system
 * @dev Clean separation of concerns - materials in MaterialBank, logic here
 */
contract MonsterMetadataBankV4 is IMetadataBank {
    using Strings for uint256;
    
    // Material provider
    IMaterialBank public immutable materialBank;
    
    // Attribute names
    string[10] private species = ["Demon", "Dragon", "Frankenstein", "Goblin", "Mummy", "Skeleton", "Vampire", "Werewolf", "Zombie", "Succubus"];
    string[10] private equipment = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
    string[10] private realms = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
    string[10] private curses = ["Seizure", "Mind Blast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"];
    
    constructor(address _materialBank) {
        materialBank = IMaterialBank(_materialBank);
    }
    
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId < 10000, "Invalid token ID");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        string memory json = string(abi.encodePacked(
            '{"name":"', species[s], ' #', tokenId.toString(), '",',
            '"description":"', _generateDescription(s, e, r, c), '",',
            '"image":"', _generateImage(s, e, r, c), '",',
            '"attributes":['
        ));
        
        json = string(abi.encodePacked(json,
            '{"trait_type":"Species","value":"', species[s], '"},',
            '{"trait_type":"Equipment","value":"', equipment[e], '"},',
            '{"trait_type":"Realm","value":"', realms[r], '"},',
            '{"trait_type":"Curse","value":"', curses[c], '"}',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    function _generateImage(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        // Build SVG using MaterialBank
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">';
        
        // Get background
        if (materialBank.isMaterialExists(IMaterialBank.MaterialType.BACKGROUND, r)) {
            svg = string(abi.encodePacked(svg, 
                materialBank.getMaterial(IMaterialBank.MaterialType.BACKGROUND, r)
            ));
        } else {
            svg = string(abi.encodePacked(svg, '<rect width="240" height="240" fill="#222"/>'));
        }
        
        // Scale for pixel art
        svg = string(abi.encodePacked(svg, '<g transform="scale(10)">'));
        
        // Add monster
        if (materialBank.isMaterialExists(IMaterialBank.MaterialType.SPECIES, s)) {
            svg = string(abi.encodePacked(svg,
                materialBank.getMaterial(IMaterialBank.MaterialType.SPECIES, s)
            ));
        }
        
        // Add equipment
        if (materialBank.isMaterialExists(IMaterialBank.MaterialType.EQUIPMENT, e)) {
            svg = string(abi.encodePacked(svg,
                materialBank.getMaterial(IMaterialBank.MaterialType.EQUIPMENT, e)
            ));
        }
        
        svg = string(abi.encodePacked(svg, '</g>'));
        
        // Add effect based on curse
        uint8 effectId = _mapCurseToEffect(c);
        if (effectId < 255 && materialBank.isMaterialExists(IMaterialBank.MaterialType.EFFECT, effectId)) {
            svg = string(abi.encodePacked(svg,
                materialBank.getMaterial(IMaterialBank.MaterialType.EFFECT, effectId)
            ));
        }
        
        svg = string(abi.encodePacked(svg, '</svg>'));
        
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    function _generateDescription(uint8 s, uint8 e, uint8 r, uint8 c) private view returns (string memory) {
        return string(abi.encodePacked(
            "A ", realms[r], "-touched ", species[s],
            " wielding ", equipment[e], ", cursed with ", curses[c], "."
        ));
    }
    
    function _mapCurseToEffect(uint8 curseId) private pure returns (uint8) {
        if (curseId == 4) return 4;  // Bats
        if (curseId == 6) return 0;  // Lightning
        return 255; // No effect
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
        return this.getMetadata(seed % 10000);
    }
}

/**
 * @title SVGComposer
 * @notice Utility contract for complex SVG composition using MaterialBank
 */
contract SVGComposer {
    using Strings for uint256;
    
    IMaterialBank public immutable materialBank;
    
    constructor(address _materialBank) {
        materialBank = IMaterialBank(_materialBank);
    }
    
    /**
     * @notice Compose a complex SVG from multiple materials
     */
    function composeSVG(
        uint256[] memory backgroundIds,
        uint256[] memory speciesIds,
        uint256[] memory equipmentIds,
        uint256[] memory effectIds,
        string memory customTransform
    ) external view returns (string memory) {
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">';
        
        // Add backgrounds
        for (uint i = 0; i < backgroundIds.length; i++) {
            if (materialBank.isMaterialExists(IMaterialBank.MaterialType.BACKGROUND, backgroundIds[i])) {
                svg = string(abi.encodePacked(svg,
                    materialBank.getMaterial(IMaterialBank.MaterialType.BACKGROUND, backgroundIds[i])
                ));
            }
        }
        
        // Add main content with transform
        if (bytes(customTransform).length > 0) {
            svg = string(abi.encodePacked(svg, '<g transform="', customTransform, '">'));
        } else {
            svg = string(abi.encodePacked(svg, '<g>'));
        }
        
        // Add species
        for (uint i = 0; i < speciesIds.length; i++) {
            if (materialBank.isMaterialExists(IMaterialBank.MaterialType.SPECIES, speciesIds[i])) {
                svg = string(abi.encodePacked(svg,
                    materialBank.getMaterial(IMaterialBank.MaterialType.SPECIES, speciesIds[i])
                ));
            }
        }
        
        // Add equipment
        for (uint i = 0; i < equipmentIds.length; i++) {
            if (materialBank.isMaterialExists(IMaterialBank.MaterialType.EQUIPMENT, equipmentIds[i])) {
                svg = string(abi.encodePacked(svg,
                    materialBank.getMaterial(IMaterialBank.MaterialType.EQUIPMENT, equipmentIds[i])
                ));
            }
        }
        
        svg = string(abi.encodePacked(svg, '</g>'));
        
        // Add effects
        for (uint i = 0; i < effectIds.length; i++) {
            if (materialBank.isMaterialExists(IMaterialBank.MaterialType.EFFECT, effectIds[i])) {
                svg = string(abi.encodePacked(svg,
                    materialBank.getMaterial(IMaterialBank.MaterialType.EFFECT, effectIds[i])
                ));
            }
        }
        
        svg = string(abi.encodePacked(svg, '</svg>'));
        
        return svg;
    }
}