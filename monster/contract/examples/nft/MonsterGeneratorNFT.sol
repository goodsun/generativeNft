// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title MonsterGeneratorNFT
 * @notice Fully on-chain generative Monster NFT inspired by the JavaScript system
 * @dev Simplified version focusing on core generation logic
 */
contract MonsterGeneratorNFT is ERC721Enumerable {
    using Strings for uint256;
    
    address public immutable owner;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintFee = 0.01 ether;
    
    // Attributes (simplified for gas efficiency)
    string[10] private species = [
        "Werewolf", "Demon", "Dragon", "Goblin", "Mummy",
        "Skeleton", "Succubus", "Vampire", "Zombie", "Frankenstein"
    ];
    
    string[10] private equipment = [
        "Crown", "Sword", "Shield", "Staff", "Scythe",
        "Torch", "Amulet", "Wine", "Poison", "Arm"
    ];
    
    string[10] private realms = [
        "Bloodmoon", "Abyss", "Inferno", "Shadow", "Void",
        "Frost", "Venom", "Decay", "Corruption", "Ragnarok"
    ];
    
    string[10] private curses = [
        "Lightning", "Burning", "Blizzard", "Bats", "Poisoning",
        "Blackout", "Meteor", "Seizure", "Confusion", "Matrix"
    ];
    
    // Realm colors for background
    string[10] private realmColors = [
        "#8B0000", "#1a1a2e", "#ff4500", "#2c003e", "#0a0a0a",
        "#4169e1", "#228b22", "#654321", "#4a0080", "#800020"
    ];
    
    // Simple synergies (gas-optimized version)
    struct Synergy {
        uint8 speciesIdx;
        uint8 equipmentIdx;
        uint8 realmIdx;
        uint8 curseIdx;
        string title;
        string rarity;
    }
    
    Synergy[] private synergies;
    
    constructor() ERC721("Monster Generator", "MONSTER") {
        owner = msg.sender;
        
        // Add a few example synergies
        synergies.push(Synergy(7, 7, 0, 3, "Crimson Lord", "Mythic")); // Vampire + Wine + Bloodmoon + Bats
        synergies.push(Synergy(2, 1, 2, 1, "Infernal Wrath", "Legendary")); // Dragon + Sword + Inferno + Burning
        synergies.push(Synergy(4, 0, 9, 9, "Ancient Pharaoh", "Epic")); // Mummy + Crown + Ragnarok + Matrix
    }
    
    function mint() public payable returns (uint256) {
        require(msg.value >= mintFee, "Insufficient fee");
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");
        
        uint256 tokenId = totalSupply() + 1;
        _mint(msg.sender, tokenId);
        
        // Refund excess
        if (msg.value > mintFee) {
            payable(msg.sender).transfer(msg.value - mintFee);
        }
        
        return tokenId;
    }
    
    function getAttributes(uint256 tokenId) public view returns (
        uint8 speciesIdx,
        uint8 equipmentIdx,
        uint8 realmIdx,
        uint8 curseIdx
    ) {
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId, address(this))));
        
        speciesIdx = uint8(seed % 10);
        equipmentIdx = uint8((seed / 10) % 10);
        realmIdx = uint8((seed / 100) % 10);
        curseIdx = uint8((seed / 1000) % 10);
    }
    
    function checkSynergy(uint256 tokenId) public view returns (string memory title, string memory rarity) {
        (uint8 s, uint8 e, uint8 r, uint8 c) = getAttributes(tokenId);
        
        for (uint i = 0; i < synergies.length; i++) {
            if (synergies[i].speciesIdx == s &&
                synergies[i].equipmentIdx == e &&
                synergies[i].realmIdx == r &&
                synergies[i].curseIdx == c) {
                return (synergies[i].title, synergies[i].rarity);
            }
        }
        
        // Check legendary IDs
        if (tokenId == 666) return ("Devil's Number", "Legendary");
        if (tokenId == 777) return ("Lucky Seven", "Legendary");
        if (tokenId == 1337) return ("Elite", "Epic");
        
        return ("", "Common");
    }
    
    function generateSVG(uint256 tokenId) public view returns (string memory) {
        (uint8 s, uint8 e, uint8 r, uint8 c) = getAttributes(tokenId);
        
        // Simplified SVG generation
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240">',
            '<rect width="240" height="240" fill="', realmColors[r], '"/>',
            '<text x="120" y="30" text-anchor="middle" font-size="16" fill="white">',
            species[s], '</text>',
            '<text x="120" y="210" text-anchor="middle" font-size="12" fill="white">',
            equipment[e], ' | ', curses[c],
            '</text>',
            _generateMonsterShape(s, r),
            _generateEffect(c),
            '</svg>'
        ));
        
        return svg;
    }
    
    function _generateMonsterShape(uint8 speciesIdx, uint8 realmIdx) private view returns (string memory) {
        // Simplified monster representation
        uint256 seed = uint256(keccak256(abi.encodePacked(speciesIdx, realmIdx)));
        uint256 size = 60 + (seed % 40);
        
        return string(abi.encodePacked(
            '<circle cx="120" cy="120" r="', size.toString(),
            '" fill="#', _toHexString(seed % 16777215),
            '" opacity="0.8"/>',
            '<circle cx="100" cy="100" r="10" fill="red"/>',  // Eye
            '<circle cx="140" cy="100" r="10" fill="red"/>'   // Eye
        ));
    }
    
    function _generateEffect(uint8 curseIdx) private pure returns (string memory) {
        // Simplified effect overlay
        if (curseIdx < 3) {
            // Lightning, Burning, Blizzard - add particles
            return '<circle cx="60" cy="60" r="5" fill="yellow" opacity="0.6"/><circle cx="180" cy="180" r="5" fill="orange" opacity="0.6"/>';
        } else if (curseIdx < 6) {
            // Bats, Poisoning, Blackout - add darkness
            return '<rect x="0" y="0" width="240" height="240" fill="black" opacity="0.2"/>';
        } else {
            // Others - add glow
            return '<circle cx="120" cy="120" r="100" fill="none" stroke="white" stroke-width="2" opacity="0.3"/>';
        }
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        
        (uint8 s, uint8 e, uint8 r, uint8 c) = getAttributes(tokenId);
        (string memory title, string memory rarity) = checkSynergy(tokenId);
        
        string memory name = bytes(title).length > 0 
            ? title 
            : string(abi.encodePacked(species[s], " #", tokenId.toString()));
        
        string memory svg = generateSVG(tokenId);
        string memory svgBase64 = Base64.encode(bytes(svg));
        
        string memory json = string(abi.encodePacked(
            '{"name":"', name, '",',
            '"description":"On-chain generated Monster NFT",',
            '"image":"data:image/svg+xml;base64,', svgBase64, '",',
            '"attributes":[',
                '{"trait_type":"Species","value":"', species[s], '"},',
                '{"trait_type":"Equipment","value":"', equipment[e], '"},',
                '{"trait_type":"Realm","value":"', realms[r], '"},',
                '{"trait_type":"Curse","value":"', curses[c], '"},',
                '{"trait_type":"Rarity","value":"', rarity, '"}',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    function _toHexString(uint256 value) private pure returns (string memory) {
        bytes memory buffer = new bytes(6);
        for (uint256 i = 6; i > 0; i--) {
            uint256 digit = value % 16;
            buffer[i - 1] = digit < 10 ? bytes1(uint8(48 + digit)) : bytes1(uint8(87 + digit));
            value /= 16;
        }
        return string(buffer);
    }
    
    function _exists(uint256 tokenId) private view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
    
    function withdraw() external {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(address(this).balance);
    }
}