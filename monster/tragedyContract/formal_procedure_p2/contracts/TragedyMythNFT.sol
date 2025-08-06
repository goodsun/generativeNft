// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TragedyMetadataV5.sol";

contract TragedyMythNFT is ERC721, Ownable {
    TragedyMetadataV5 public metadata;
    uint256 public nextTokenId = 1;
    
    struct TragedyParams {
        uint8 species;
        uint8 background;
        uint8 item;
        uint8 effect;
    }
    
    mapping(uint256 => TragedyParams) public tokenParams;
    
    event TragedyMinted(
        uint256 indexed tokenId,
        address indexed minter,
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    );
    
    constructor(address _metadata) ERC721("Tragedy Myth", "MYTH") Ownable(msg.sender) {
        metadata = TragedyMetadataV5(_metadata);
    }
    
    function mint(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external returns (uint256) {
        require(species < 10, "Invalid species");
        require(background < 10, "Invalid background");
        require(item < 10, "Invalid item");
        require(effect < 10, "Invalid effect");
        
        uint256 tokenId = nextTokenId++;
        
        tokenParams[tokenId] = TragedyParams({
            species: species,
            background: background,
            item: item,
            effect: effect
        });
        
        _safeMint(msg.sender, tokenId);
        
        emit TragedyMinted(
            tokenId,
            msg.sender,
            species,
            background,
            item,
            effect
        );
        
        return tokenId;
    }
    
    function mintBatch(
        uint8[] calldata species,
        uint8[] calldata backgrounds,
        uint8[] calldata items,
        uint8[] calldata effects
    ) external returns (uint256[] memory) {
        require(
            species.length == backgrounds.length &&
            species.length == items.length &&
            species.length == effects.length,
            "Array length mismatch"
        );
        
        uint256[] memory tokenIds = new uint256[](species.length);
        
        for (uint256 i = 0; i < species.length; i++) {
            require(species[i] < 10, "Invalid species");
            require(backgrounds[i] < 10, "Invalid background");
            require(items[i] < 10, "Invalid item");
            require(effects[i] < 10, "Invalid effect");
            
            uint256 tokenId = nextTokenId++;
            
            tokenParams[tokenId] = TragedyParams({
                species: species[i],
                background: backgrounds[i],
                item: items[i],
                effect: effects[i]
            });
            
            _safeMint(msg.sender, tokenId);
            
            emit TragedyMinted(
                tokenId,
                msg.sender,
                species[i],
                backgrounds[i],
                items[i],
                effects[i]
            );
            
            tokenIds[i] = tokenId;
        }
        
        return tokenIds;
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        
        TragedyParams memory params = tokenParams[tokenId];
        
        return metadata.generateMetadata(
            tokenId,
            params.species,
            params.background,
            params.item,
            params.effect
        );
    }
    
    function setMetadata(address _metadata) external onlyOwner {
        metadata = TragedyMetadataV5(_metadata);
    }
}