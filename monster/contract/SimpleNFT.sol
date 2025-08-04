// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./RoyaltyStandard.sol";

/**
 * @title SimpleNFT
 * @author SimpleNFT Team
 * @notice A simple and clean NFT contract with minting, burning, and optional soul-bound functionality
 * @dev Implements ERC721 with enumerable extension and ERC2981 royalty standard
 */
contract SimpleNFT is ERC721Enumerable, RoyaltyStandard {

    // ============ Custom Errors ============
    error OnlyOwner();
    error InsufficientMintFee();
    error EmptyMetadataURI();
    error MaxSupplyReached();
    error InvalidMaxSupply();
    error NoBalanceToWithdraw();
    error NotOwnerOrApproved();
    error TokenIsSoulBound();
    error TransferFailed();

    // ============ Events ============
    event NFTMinted(
        address indexed to,
        uint256 indexed tokenId,
        address indexed creator,
        string metadataURI
    );

    event SoulBoundNFTMinted(
        address indexed to,
        uint256 indexed tokenId,
        address indexed creator,
        string metadataURI
    );

    event NFTBurned(uint256 indexed tokenId);
    event Withdrawn(address indexed owner, uint256 amount);
    event ReceivedEther(address indexed from, uint256 amount);
    event ConfigUpdated(
        string name,
        string symbol,
        uint256 mintFee,
        uint256 royaltyRate
    );

    // ============ State Variables ============
    address public immutable owner;
    uint256 public immutable maxSupply;
    uint256 public mintFee;
    uint256 public royaltyRate;
    uint256 public totalMinted;
    string private _name;
    string private _symbol;

    mapping(uint256 => string) private _tokenMetadataURIs;
    mapping(uint256 => bool) private _soulBoundTokens;

    // ============ Modifiers ============
    /**
     * @dev Restricts function access to contract owner only
     */
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    // ============ Constructor ============
    /**
     * @notice Deploys the NFT contract with specified parameters
     * @param name The name of the NFT collection
     * @param symbol The symbol of the NFT collection
     * @param _maxSupply Maximum number of NFTs that can be minted
     * @param _mintFee The fee required to mint an NFT (in wei)
     * @param _royaltyRate The royalty rate in basis points (e.g., 250 = 2.5%)
     */
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
    /**
     * @notice Mints a new NFT to the specified address
     * @param to The address that will receive the NFT
     * @param metadataURI The metadata URI for the NFT
     * @return tokenId The ID of the newly minted NFT
     */
    function mint(
        address to,
        string memory metadataURI
    ) public payable returns (uint256) {
        if (msg.value < mintFee) revert InsufficientMintFee();
        if (bytes(metadataURI).length == 0) revert EmptyMetadataURI();
        if (totalMinted >= maxSupply) revert MaxSupplyReached();

        totalMinted++;
        uint256 tokenId = totalMinted;

        _tokenMetadataURIs[tokenId] = metadataURI;
        _mint(to, tokenId);
        _setTokenRoyalty(tokenId, address(this), royaltyRate);

        // Refund excess payment
        if (msg.value > mintFee) {
            uint256 refundAmount = msg.value - mintFee;
            (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
            if (!success) revert TransferFailed();
        }

        emit NFTMinted(to, tokenId, msg.sender, metadataURI);

        return tokenId;
    }

    /**
     * @notice Mints a soul-bound (non-transferable) NFT
     * @param to The address that will receive the NFT
     * @param metadataURI The metadata URI for the NFT
     * @return tokenId The ID of the newly minted NFT
     */
    function mintSoulBound(
        address to,
        string memory metadataURI
    ) external payable returns (uint256) {
        uint256 tokenId = mint(to, metadataURI);
        _soulBoundTokens[tokenId] = true;

        emit SoulBoundNFTMinted(to, tokenId, msg.sender, metadataURI);

        return tokenId;
    }

    // ============ Token Functions ============
    /**
     * @notice Returns the metadata URI for a specific token
     * @param tokenId The ID of the token to query
     * @return The metadata URI string
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        _requireMinted(tokenId);
        return _tokenMetadataURIs[tokenId];
    }

    /**
     * @notice Burns (permanently destroys) a token
     * @param tokenId The ID of the token to burn
     */
    function burn(uint256 tokenId) external {
        if (!_isApprovedOrOwner(_msgSender(), tokenId)) {
            revert NotOwnerOrApproved();
        }

        delete _tokenMetadataURIs[tokenId];
        delete _soulBoundTokens[tokenId];
        _burn(tokenId);

        emit NFTBurned(tokenId);
    }

    /**
     * @notice Checks if a token is soul-bound (non-transferable)
     * @param tokenId The ID of the token to check
     * @return True if the token is soul-bound, false otherwise
     */
    function isSoulBound(uint256 tokenId) external view returns (bool) {
        return _soulBoundTokens[tokenId];
    }

    // ============ Admin Functions ============
    /**
     * @notice Updates the contract configuration (owner only)
     * @param newName The new name for the NFT collection
     * @param newSymbol The new symbol for the NFT collection
     * @param newMintFee The new minting fee in wei
     * @param newRoyaltyRate The new royalty rate in basis points
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
        
        emit ConfigUpdated(newName, newSymbol, newMintFee, newRoyaltyRate);
    }

    /**
     * @notice Withdraws all contract balance to owner (owner only)
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoBalanceToWithdraw();

        (bool success, ) = payable(owner).call{value: balance}("");
        if (!success) revert TransferFailed();

        emit Withdrawn(owner, balance);
    }

    // ============ View Functions ============
    /**
     * @notice Returns the number of tokens remaining to be minted
     * @return The number of tokens that can still be minted
     */
    function remainingSupply() external view returns (uint256) {
        return maxSupply - totalMinted;
    }

    /**
     * @notice Checks if minting is still possible
     * @return True if tokens can still be minted, false otherwise
     */
    function canMint() external view returns (bool) {
        return totalMinted < maxSupply;
    }
    
    /**
     * @notice Returns the name of the NFT collection
     * @return The collection name
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    
    /**
     * @notice Returns the symbol of the NFT collection
     * @return The collection symbol
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    // ============ Receive Function ============
    /**
     * @notice Allows the contract to receive ETH directly
     * @dev Emits ReceivedEther event when ETH is received
     */
    receive() external payable {
        emit ReceivedEther(msg.sender, msg.value);
    }

    // ============ Internal Functions ============
    /**
     * @dev Hook that is called before any token transfer
     * @param from Source address
     * @param to Destination address
     * @param tokenId Token ID being transferred
     * @param batchSize Size of the batch transfer
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        // Allow minting and burning, but check soul-bound status for transfers
        if (from != address(0) && to != address(0)) {
            if (_soulBoundTokens[tokenId]) revert TokenIsSoulBound();
        }
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // ============ Interface Support ============
    /**
     * @notice Checks if the contract supports a specific interface
     * @param interfaceId The interface identifier to check
     * @return True if the interface is supported, false otherwise
     */
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