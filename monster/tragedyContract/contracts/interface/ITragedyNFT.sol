// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITragedyNFT {
    // Struct
    struct TragedyAttributes {
        uint8 species;
        uint8 background;
        uint8 item;
        uint8 effect;
    }
    
    // Main functions
    function mint(uint8 species, uint8 background, uint8 item, uint8 effect) external payable;
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function getSVG(uint256 tokenId) external view returns (string memory);
    function tokenAttributes(uint256 tokenId) external view returns (
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    );
    
    // State variables
    function mintPrice() external view returns (uint256);
    function nextTokenId() external view returns (uint256);
    function metadataBank() external view returns (address);
    function svgComposer() external view returns (address);
    
    // Owner functions
    function setMintPrice(uint256 _price) external;
    function withdraw() external;
    function updateContracts(address _metadataBank, address _svgComposer) external;
    
    // ERC721 functions
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    
    // ERC721Enumerable functions
    function totalSupply() external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function tokenByIndex(uint256 index) external view returns (uint256);
}