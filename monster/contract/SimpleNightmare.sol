// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleNightmare is ERC721, ERC721Enumerable, Ownable {
    uint256 public nextTokenId = 1;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public price = 0.005 ether;
    string private baseURI = "ipfs://YOUR_CID/";
    
    constructor() ERC721("Simple Nightmare", "SNIGHTMARE") Ownable(msg.sender) {}
    
    function mint(uint256 quantity) public payable {
        require(nextTokenId + quantity - 1 <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value >= price * quantity, "Insufficient payment");
        
        for (uint256 i = 0; i < quantity; i++) {
            _safeMint(msg.sender, nextTokenId);
            nextTokenId++;
        }
    }
    
    function ownerMint(address to, uint256 quantity) public onlyOwner {
        require(nextTokenId + quantity - 1 <= MAX_SUPPLY, "Exceeds max supply");
        
        for (uint256 i = 0; i < quantity; i++) {
            _safeMint(to, nextTokenId);
            nextTokenId++;
        }
    }
    
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }
    
    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }
    
    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    
    // Required overrides for ERC721Enumerable
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
    
    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}