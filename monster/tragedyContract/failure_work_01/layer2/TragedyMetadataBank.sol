// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ITragedyMetadataBank.sol";
import "../layer3/ITragedySVGComposer.sol";
import "../layer3/TragedyTextComposer.sol";
import "../layer4/TragedyMaterialBank.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title TragedyMetadataBank
 * @notice Generates complete NFT metadata by combining Layer 3 components
 */
contract TragedyMetadataBank is ITragedyMetadataBank {
    ITragedySVGComposer public svgComposer;
    TragedyTextComposer public textComposer;
    ITragedyMaterialBank public materialBank;
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    constructor(
        address _svgComposer,
        address _textComposer,
        address _materialBank
    ) {
        owner = msg.sender;
        svgComposer = ITragedySVGComposer(_svgComposer);
        textComposer = TragedyTextComposer(_textComposer);
        materialBank = ITragedyMaterialBank(_materialBank);
    }
    
    function tokenURI(
        uint256 tokenId,
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view override returns (string memory) {
        require(species < 10, "Invalid species");
        require(equipment < 10, "Invalid equipment");
        require(realm < 10, "Invalid realm");
        require(curse < 10, "Invalid curse");
        
        // Generate SVG image
        string memory svg = svgComposer.composeSVG(species, equipment, realm, curse);
        string memory svgDataUri = _encodeSVGDataUri(svg);
        
        // Generate name and description
        string memory name = textComposer.generateName(tokenId, species, equipment, realm, curse);
        string memory description = textComposer.generateDescription(tokenId, species, equipment, realm, curse);
        
        // Generate attributes
        string memory attributes = _generateAttributes(species, equipment, realm, curse);
        
        // Compose final JSON
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', svgDataUri, '",',
            '"attributes":', attributes,
            '}'
        ));
        
        return _encodeJsonDataUri(json);
    }
    
    function setSVGComposer(address composer) external override onlyOwner {
        svgComposer = ITragedySVGComposer(composer);
    }
    
    function setTextComposer(address composer) external override onlyOwner {
        textComposer = TragedyTextComposer(composer);
    }
    
    function setMaterialBank(address bank) external override onlyOwner {
        materialBank = ITragedyMaterialBank(bank);
    }
    
    function _generateAttributes(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) private view returns (string memory) {
        return string(abi.encodePacked(
            '[',
            '{"trait_type":"Species","value":"', materialBank.getSpeciesName(species), '"},',
            '{"trait_type":"Equipment","value":"', materialBank.getEquipmentName(equipment), '"},',
            '{"trait_type":"Realm","value":"', materialBank.getRealmName(realm), '"},',
            '{"trait_type":"Curse","value":"', materialBank.getCurseName(curse), '"},',
            '{"trait_type":"Species ID","value":', _toString(species), '},',
            '{"trait_type":"Equipment ID","value":', _toString(equipment), '},',
            '{"trait_type":"Realm ID","value":', _toString(realm), '},',
            '{"trait_type":"Curse ID","value":', _toString(curse), '}',
            ']'
        ));
    }
    
    function _encodeSVGDataUri(string memory svg) private pure returns (string memory) {
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    function _encodeJsonDataUri(string memory json) private pure returns (string memory) {
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
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
}