// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";
import "../composer/ISVGComposer.sol";
import "../composer/ITextComposer.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterMetadataBankV5
 * @notice Ultimate clean architecture - MetadataBank only assembles, composers do the work
 * @dev Complete separation of concerns
 */
contract MonsterMetadataBankV5 is IMetadataBank {
    using Strings for uint256;
    
    // Composers
    ISVGComposer public immutable svgComposer;
    ITextComposer public immutable textComposer;
    
    constructor(address _svgComposer, address _textComposer) {
        svgComposer = ISVGComposer(_svgComposer);
        textComposer = ITextComposer(_textComposer);
    }
    
    /**
     * @notice Get metadata - this is ALL this contract does!
     */
    function getMetadata(uint256 tokenId) external view override returns (string memory) {
        require(tokenId < 10000, "Invalid token ID");
        
        // Decode token attributes
        (uint8 s, uint8 e, uint8 r, uint8 c) = decodeTokenId(tokenId);
        
        // Get composed elements from specialized contracts
        string memory name = textComposer.composeName(tokenId, s, e);
        string memory description = textComposer.composeDescription(s, e, r, c);
        string memory image = svgComposer.composeSVG(r, s, e, c);
        
        // Assemble metadata JSON
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"', description, '",',
            '"image":"', image, '",',
            '"attributes":', _buildAttributes(s, e, r, c),
            '}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Build attributes array
     */
    function _buildAttributes(uint8 s, uint8 e, uint8 r, uint8 c) private pure returns (string memory) {
        return string(abi.encodePacked(
            '[',
            '{"trait_type":"Species","value":"', _getSpeciesName(s), '"},',
            '{"trait_type":"Equipment","value":"', _getEquipmentName(e), '"},',
            '{"trait_type":"Realm","value":"', _getRealmName(r), '"},',
            '{"trait_type":"Curse","value":"', _getCurseName(c), '"}',
            ']'
        ));
    }
    
    // Simple attribute name getters
    function _getSpeciesName(uint8 id) private pure returns (string memory) {
        string[10] memory names = ["Demon", "Dragon", "Frankenstein", "Goblin", "Mummy", 
                                   "Skeleton", "Vampire", "Werewolf", "Zombie", "Succubus"];
        return names[id];
    }
    
    function _getEquipmentName(uint8 id) private pure returns (string memory) {
        string[10] memory names = ["Crown", "Sword", "Shield", "Poison", "Torch", 
                                   "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
        return names[id];
    }
    
    function _getRealmName(uint8 id) private pure returns (string memory) {
        string[10] memory names = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", 
                                   "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
        return names[id];
    }
    
    function _getCurseName(uint8 id) private pure returns (string memory) {
        string[10] memory names = ["Seizure", "Mind Blast", "Confusion", "Meteor", "Bats", 
                                   "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"];
        return names[id];
    }
    
    /**
     * @notice Decode token ID to attributes
     */
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
 * @title ConfigurableMetadataBank
 * @notice MetadataBank with swappable composers
 */
contract ConfigurableMetadataBank is MonsterMetadataBankV5 {
    
    address public owner;
    ISVGComposer public overrideSvgComposer;
    ITextComposer public overrideTextComposer;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(address _svgComposer, address _textComposer) 
        MonsterMetadataBankV5(_svgComposer, _textComposer) {
        owner = msg.sender;
    }
    
    /**
     * @notice Update composers
     */
    function updateComposers(
        address _svgComposer,
        address _textComposer
    ) external onlyOwner {
        if (_svgComposer != address(0)) {
            overrideSvgComposer = ISVGComposer(_svgComposer);
        }
        if (_textComposer != address(0)) {
            overrideTextComposer = ITextComposer(_textComposer);
        }
    }
    
    /**
     * @notice Get active SVG composer
     */
    function getActiveSvgComposer() public view returns (ISVGComposer) {
        return address(overrideSvgComposer) != address(0) ? overrideSvgComposer : svgComposer;
    }
    
    /**
     * @notice Get active text composer
     */
    function getActiveTextComposer() public view returns (ITextComposer) {
        return address(overrideTextComposer) != address(0) ? overrideTextComposer : textComposer;
    }
}