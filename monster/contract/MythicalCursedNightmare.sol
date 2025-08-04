// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title The Mythical Cursed-Nightmare
 * @dev A collection of 10,000 cursed creatures from the digital abyss
 */
contract MythicalCursedNightmare is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    
    // Token counter
    Counters.Counter private _tokenIdCounter;
    
    // Contract configuration
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public price = 0.005 ether;
    uint256 public maxPerWallet = 20;
    uint256 public maxPerTransaction = 10;
    
    // Mint phase control
    bool public mintEnabled = false;
    bool public publicMintEnabled = false;
    
    // Special access lists
    mapping(address => bool) public watchwordList;
    mapping(address => uint256) public mintedPerWallet;
    mapping(uint256 => uint256) public tokenIdToSeed; // For randomization
    
    // Base URI for metadata
    string private _baseTokenURI;
    string private _contractURI;
    
    // Events
    event NightmareSummoned(address indexed summoner, uint256 indexed tokenId);
    event PhaseChanged(bool mintEnabled, bool publicMintEnabled);
    event PriceUpdated(uint256 newPrice);
    
    constructor() ERC721("The Mythical Cursed-Nightmare", "NIGHTMARE") Ownable(msg.sender) {
        _baseTokenURI = "ipfs://YOUR_METADATA_CID/";
        _contractURI = "ipfs://YOUR_CONTRACT_METADATA_CID";
    }
    
    /**
     * @dev Public mint function - summon your nightmare
     */
    function mint(uint256 quantity) public payable nonReentrant {
        require(mintEnabled || publicMintEnabled, "The seal is not yet broken");
        require(quantity > 0 && quantity <= maxPerTransaction, "Invalid quantity");
        require(_tokenIdCounter.current() + quantity <= MAX_SUPPLY, "Would exceed max supply");
        require(mintedPerWallet[msg.sender] + quantity <= maxPerWallet, "Exceeds wallet limit");
        
        // Check payment
        uint256 totalPrice = price * quantity;
        require(msg.value >= totalPrice, "Insufficient payment");
        
        // Mint tokens
        for (uint256 i = 0; i < quantity; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            
            // Generate random seed for this token
            tokenIdToSeed[tokenId] = uint256(keccak256(abi.encodePacked(
                block.timestamp,
                block.prevrandao,
                msg.sender,
                tokenId
            )));
            
            _safeMint(msg.sender, tokenId);
            emit NightmareSummoned(msg.sender, tokenId);
        }
        
        mintedPerWallet[msg.sender] += quantity;
        
        // Refund excess payment
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
    }
    
    /**
     * @dev Special mint for watchword holders (discounted)
     */
    function watchwordMint(uint256 quantity) public payable nonReentrant {
        require(watchwordList[msg.sender], "Not on the watchword list");
        require(mintEnabled, "Watchword mint not active");
        require(quantity > 0 && quantity <= maxPerTransaction, "Invalid quantity");
        require(_tokenIdCounter.current() + quantity <= MAX_SUPPLY, "Would exceed max supply");
        
        // 40% discount for watchword holders
        uint256 discountedPrice = (price * 60) / 100;
        uint256 totalPrice = discountedPrice * quantity;
        require(msg.value >= totalPrice, "Insufficient payment");
        
        // Mint tokens
        for (uint256 i = 0; i < quantity; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            
            tokenIdToSeed[tokenId] = uint256(keccak256(abi.encodePacked(
                block.timestamp,
                block.prevrandao,
                msg.sender,
                tokenId,
                "SOULBOUND"
            )));
            
            _safeMint(msg.sender, tokenId);
            emit NightmareSummoned(msg.sender, tokenId);
        }
        
        mintedPerWallet[msg.sender] += quantity;
        
        // Refund excess
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
    }
    
    /**
     * @dev Owner mint for giveaways and team
     */
    function ownerMint(address to, uint256 quantity) public onlyOwner {
        require(quantity > 0, "Invalid quantity");
        require(_tokenIdCounter.current() + quantity <= MAX_SUPPLY, "Would exceed max supply");
        
        for (uint256 i = 0; i < quantity; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            
            tokenIdToSeed[tokenId] = uint256(keccak256(abi.encodePacked(
                block.timestamp,
                block.prevrandao,
                to,
                tokenId,
                "CURSED"
            )));
            
            _safeMint(to, tokenId);
            emit NightmareSummoned(to, tokenId);
        }
    }
    
    // Admin functions
    
    function setMintPhase(bool _mintEnabled, bool _publicMintEnabled) public onlyOwner {
        mintEnabled = _mintEnabled;
        publicMintEnabled = _publicMintEnabled;
        emit PhaseChanged(_mintEnabled, _publicMintEnabled);
    }
    
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
        emit PriceUpdated(_price);
    }
    
    function setMaxPerWallet(uint256 _max) public onlyOwner {
        maxPerWallet = _max;
    }
    
    function setMaxPerTransaction(uint256 _max) public onlyOwner {
        maxPerTransaction = _max;
    }
    
    function addToWatchwordList(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            watchwordList[addresses[i]] = true;
        }
    }
    
    function removeFromWatchwordList(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            watchwordList[addresses[i]] = false;
        }
    }
    
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    function setContractURI(string memory contractURI_) public onlyOwner {
        _contractURI = contractURI_;
    }
    
    // View functions
    
    function totalSupply() public view override returns (uint256) {
        return _tokenIdCounter.current();
    }
    
    function maxSupply() public pure returns (uint256) {
        return MAX_SUPPLY;
    }
    
    function contractURI() public view returns (string memory) {
        return _contractURI;
    }
    
    function tokenURI(uint256 tokenId) 
        public 
        view 
        override(ERC721, ERC721URIStorage) 
        returns (string memory) 
    {
        require(ownerOf(tokenId) != address(0), "Token does not exist");
        
        // Generate deterministic metadata based on seed
        // This could point to different IPFS files or generate on-chain metadata
        uint256 seed = tokenIdToSeed[tokenId];
        uint256 creatureType = (seed % 10) + 1; // 10 different creature types
        
        return string(abi.encodePacked(_baseTokenURI, toString(creatureType), "/", toString(tokenId), ".json"));
    }
    
    // Withdraw function
    
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }
    
    // Utility functions
    
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
    
    // Required overrides
    
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
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}