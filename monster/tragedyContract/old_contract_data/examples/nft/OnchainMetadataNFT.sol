// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";
import "./RoyaltyStandard.sol";

/**
 * @title OnchainMetadataNFT
 * @author BankedNFT Team
 * @notice NFT with fully on-chain generated metadata
 * @dev Generates JSON metadata directly in the contract
 */
contract OnchainMetadataNFT is ERC721Enumerable, RoyaltyStandard {
    using Strings for uint256;
    
    // ============ Custom Errors ============
    error OnlyOwner();
    error InsufficientMintFee();
    error MaxSupplyReached();
    error InvalidMaxSupply();
    error NoBalanceToWithdraw();
    error NotOwnerOrApproved();
    error TransferFailed();
    
    // ============ Events ============
    event NFTMinted(address indexed to, uint256 indexed tokenId);
    event Withdrawn(address indexed owner, uint256 amount);
    
    // ============ State Variables ============
    address public immutable owner;
    uint256 public immutable maxSupply;
    uint256 public mintFee;
    uint256 public royaltyRate;
    uint256 public totalMinted;
    string private _name;
    string private _symbol;
    
    // Metadata components
    string public imageBaseURI = "ipfs://QmYourImageHash/";
    string public animationBaseURI = "";
    
    // Traits
    string[] private backgrounds = ["Sky", "Forest", "Desert", "Ocean", "Mountain"];
    string[] private characters = ["Dragon", "Wizard", "Warrior", "Beast", "Spirit"];
    string[] private rarities = ["Common", "Uncommon", "Rare", "Epic", "Legendary"];
    
    // ============ Modifiers ============
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }
    
    // ============ Constructor ============
    constructor(
        string memory nameParam,
        string memory symbolParam,
        uint256 _maxSupply,
        uint256 _mintFee,
        uint256 _royaltyRate
    ) ERC721(nameParam, symbolParam) {
        if (_maxSupply == 0) revert InvalidMaxSupply();
        require(_royaltyRate <= 10000, "Royalty rate exceeds 100%");
        
        owner = msg.sender;
        maxSupply = _maxSupply;
        mintFee = _mintFee;
        royaltyRate = _royaltyRate;
        _name = nameParam;
        _symbol = symbolParam;
    }
    
    // ============ Minting Functions ============
    function mint() public payable returns (uint256) {
        if (msg.value < mintFee) revert InsufficientMintFee();
        if (totalMinted >= maxSupply) revert MaxSupplyReached();
        
        totalMinted++;
        uint256 tokenId = totalMinted;
        
        _mint(msg.sender, tokenId);
        _setTokenRoyalty(tokenId, address(this), royaltyRate);
        
        // Refund excess payment
        if (msg.value > mintFee) {
            uint256 refundAmount = msg.value - mintFee;
            (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
            if (!success) revert TransferFailed();
        }
        
        emit NFTMinted(msg.sender, tokenId);
        return tokenId;
    }
    
    // ============ Metadata Generation ============
    /**
     * @notice Generates attributes for a token based on its ID
     */
    function getAttributes(uint256 tokenId) public view returns (
        string memory background,
        string memory character,
        string memory rarity,
        uint256 level
    ) {
        // Pseudo-random generation based on tokenId
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId, address(this))));
        
        background = backgrounds[seed % backgrounds.length];
        character = characters[(seed / 10) % characters.length];
        rarity = rarities[(seed / 100) % rarities.length];
        level = (seed % 100) + 1; // Level 1-100
    }
    
    /**
     * @notice Returns fully formed on-chain metadata
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        
        (string memory background, string memory character, string memory rarity, uint256 level) = getAttributes(tokenId);
        
        // Build the JSON metadata
        string memory json = string(abi.encodePacked(
            '{"name": "', _name, ' #', tokenId.toString(), '",',
            '"description": "Fully on-chain generated NFT with dynamic attributes",',
            '"image": "', imageBaseURI, tokenId.toString(), '.png",',
            _getAnimationUrl(tokenId),
            '"attributes": [',
                '{"trait_type": "Background", "value": "', background, '"},',
                '{"trait_type": "Character", "value": "', character, '"},',
                '{"trait_type": "Rarity", "value": "', rarity, '"},',
                '{"trait_type": "Level", "value": ', level.toString(), '}',
            ']}'
        ));
        
        // Return as base64 encoded data URI
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    /**
     * @notice Helper function for animation URL
     */
    function _getAnimationUrl(uint256 tokenId) private view returns (string memory) {
        if (bytes(animationBaseURI).length > 0) {
            return string(abi.encodePacked(
                '"animation_url": "', animationBaseURI, tokenId.toString(), '.mp4",'
            ));
        }
        return "";
    }
    
    // ============ Admin Functions ============
    /**
     * @notice Updates image base URI (owner only)
     */
    function setImageBaseURI(string memory newURI) external onlyOwner {
        imageBaseURI = newURI;
    }
    
    /**
     * @notice Updates animation base URI (owner only)
     */
    function setAnimationBaseURI(string memory newURI) external onlyOwner {
        animationBaseURI = newURI;
    }
    
    /**
     * @notice Updates the contract configuration (owner only)
     */
    function config(
        string memory newName,
        string memory newSymbol,
        uint256 newMintFee,
        uint256 newRoyaltyRate
    ) external onlyOwner {
        require(newRoyaltyRate <= 10000, "Royalty rate exceeds 100%");
        
        _name = newName;
        _symbol = newSymbol;
        mintFee = newMintFee;
        royaltyRate = newRoyaltyRate;
    }
    
    /**
     * @notice Withdraws contract balance (owner only)
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoBalanceToWithdraw();
        
        (bool success, ) = payable(owner).call{value: balance}("");
        if (!success) revert TransferFailed();
        
        emit Withdrawn(owner, balance);
    }
    
    // ============ View Functions ============
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    
    function remainingSupply() external view returns (uint256) {
        return maxSupply - totalMinted;
    }
    
    // ============ Receive Function ============
    receive() external payable {}
    
    // ============ Interface Support ============
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, RoyaltyStandard)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}