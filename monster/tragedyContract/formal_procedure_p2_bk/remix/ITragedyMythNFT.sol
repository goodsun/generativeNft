// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITragedyMythNFT {
    struct TragedyParams {
        uint8 species;
        uint8 background;
        uint8 item;
        uint8 effect;
    }
    
    event TragedyMinted(
        uint256 indexed tokenId,
        address indexed minter,
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    );
    
    function mint(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external returns (uint256);
    
    function mintBatch(
        uint8[] calldata species,
        uint8[] calldata backgrounds,
        uint8[] calldata items,
        uint8[] calldata effects
    ) external returns (uint256[] memory);
    
    function tokenParams(uint256 tokenId) external view returns (
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    );
    
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function nextTokenId() external view returns (uint256);
    function metadata() external view returns (address);
    function setMetadata(address _metadata) external;
    function owner() external view returns (address);
    
    // ERC721 standard functions
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}