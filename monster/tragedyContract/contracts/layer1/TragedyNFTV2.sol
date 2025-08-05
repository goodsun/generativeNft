// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface IMetadataBank {
    function getSpeciesNames(uint8 id) external pure returns (string memory, string memory);
    function getBackgroundNames(uint8 id) external pure returns (string memory, string memory);
    function getItemNames(uint8 id) external pure returns (string memory, string memory);
    function getEffectNames(uint8 id) external pure returns (string memory, string memory);
}

interface ISVGComposer {
    function composeSVG(uint8 species, uint8 background, uint8 item, uint8 effect) 
        external view returns (string memory);
}

/**
 * @title TragedyNFTV2
 * @notice The main NFT contract for Tragedy NFT system (OpenZeppelin v5)
 */
contract TragedyNFTV2 is ERC721, ERC721Enumerable, Ownable {
    // Struct to store NFT attributes
    struct TragedyAttributes {
        uint8 species;
        uint8 background;
        uint8 item;
        uint8 effect;
    }
    
    // Dependencies
    IMetadataBank public metadataBank;
    ISVGComposer public svgComposer;
    
    // Storage
    mapping(uint256 => TragedyAttributes) public tokenAttributes;
    uint256 public nextTokenId = 1;
    
    // Mint price
    uint256 public mintPrice = 0.01 ether;
    
    constructor(
        address _metadataBank,
        address _svgComposer
    ) ERC721("Tragedy NFT", "TRAGEDY") Ownable(msg.sender) {
        metadataBank = IMetadataBank(_metadataBank);
        svgComposer = ISVGComposer(_svgComposer);
    }
    
    /**
     * @notice Mint a new NFT with specified attributes
     */
    function mint(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external payable {
        require(msg.value >= mintPrice, "Insufficient payment");
        require(species < 10, "Invalid species");
        require(background < 10, "Invalid background");
        require(item < 10, "Invalid item");
        require(effect < 10, "Invalid effect");
        
        uint256 tokenId = nextTokenId++;
        
        tokenAttributes[tokenId] = TragedyAttributes({
            species: species,
            background: background,
            item: item,
            effect: effect
        });
        
        _safeMint(msg.sender, tokenId);
    }
    
    /**
     * @notice Generate tokenURI with on-chain metadata
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        
        TragedyAttributes memory attrs = tokenAttributes[tokenId];
        
        // Get names from metadata bank
        (string memory speciesName,) = metadataBank.getSpeciesNames(attrs.species);
        (string memory backgroundName,) = metadataBank.getBackgroundNames(attrs.background);
        (string memory itemName,) = metadataBank.getItemNames(attrs.item);
        (string memory effectName,) = metadataBank.getEffectNames(attrs.effect);
        
        // Get SVG from composer
        string memory svg = svgComposer.composeSVG(
            attrs.species,
            attrs.background,
            attrs.item,
            attrs.effect
        );
        
        // Build metadata JSON
        string memory json = string(abi.encodePacked(
            '{"name":"Tragedy #', _toString(tokenId), '",',
            '"description":"A fully on-chain generative NFT",',
            '"image":"data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '",',
            '"attributes":[',
                '{"trait_type":"Species","value":"', speciesName, '"},',
                '{"trait_type":"Background","value":"', backgroundName, '"},',
                '{"trait_type":"Item","value":"', itemName, '"},',
                '{"trait_type":"Effect","value":"', effectName, '"}'
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Get raw SVG for a token
     */
    function getSVG(uint256 tokenId) external view returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        
        TragedyAttributes memory attrs = tokenAttributes[tokenId];
        return svgComposer.composeSVG(
            attrs.species,
            attrs.background,
            attrs.item,
            attrs.effect
        );
    }
    
    /**
     * @notice Owner functions
     */
    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }
    
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    function updateContracts(address _metadataBank, address _svgComposer) external onlyOwner {
        metadataBank = IMetadataBank(_metadataBank);
        svgComposer = ISVGComposer(_svgComposer);
    }
    
    /**
     * @notice Internal functions
     */
    function _toString(uint256 value) internal pure returns (string memory) {
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
    
    /**
     * @notice Required overrides for OpenZeppelin v5
     */
    function _update(address to, uint256 tokenId, address auth) 
        internal 
        override(ERC721, ERC721Enumerable) 
        returns (address) 
    {
        return super._update(to, tokenId, auth);
    }
    
    function _increaseBalance(address account, uint128 amount) 
        internal 
        override(ERC721, ERC721Enumerable) 
    {
        super._increaseBalance(account, amount);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public view override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}