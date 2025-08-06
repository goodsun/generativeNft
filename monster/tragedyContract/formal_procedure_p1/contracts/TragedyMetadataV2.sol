// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ArweaveTragedyComposerV2.sol";
import "./ArweaveMonsterBank.sol";
import "./ArweaveBackgroundBank.sol";
import "./ArweaveItemBank.sol";
import "./ArweaveEffectBank.sol";
import "./libraries/Base64.sol";

import "./bank/MetadataBank.sol";

contract TragedyMetadataV2 is IMetadataBank {
    ArweaveTragedyComposerV2 public composer;
    
    constructor(address _composer) {
        composer = ArweaveTragedyComposerV2(_composer);
    }
    
    // Decode token ID to parameters using SEED
    function decodeTokenId(uint256 tokenId) public pure returns (
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) {
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId)));
        species = uint8((seed >> 0) % 10);
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
        
        // Get filter params
        (uint16 hue, uint16 sat, uint16 bright) = composer.filterParams(background);
        
        // Build metadata JSON
        string memory json = string(abi.encodePacked(
            '{"name":"Tragedy Myth #', toString(tokenId), '",',
            '"description":"A mythical creature cursed by tragedy, dwelling in nightmares.",',
            '"image":"data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '",',
            '"attributes":['
        ));
        
        json = string(abi.encodePacked(
            json,
            '{"trait_type":"Monster","value":"', monsterName, '"},',
            '{"trait_type":"Background","value":"', backgroundName, '"},',
            '{"trait_type":"Item","value":"', itemName, '"},',
            '{"trait_type":"Effect","value":"', effectName, '"},',
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
}