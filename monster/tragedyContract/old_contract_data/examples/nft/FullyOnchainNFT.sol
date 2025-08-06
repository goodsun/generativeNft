// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Base64.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";
import "./RoyaltyStandard.sol";

/**
 * @title FullyOnchainNFT
 * @author BankedNFT Team
 * @notice NFT with fully on-chain SVG image and metadata generation
 * @dev Generates both SVG images and JSON metadata directly in the contract
 */
contract FullyOnchainNFT is ERC721Enumerable, RoyaltyStandard {
    using Strings for uint256;
    
    // ============ Custom Errors ============
    error OnlyOwner();
    error InsufficientMintFee();
    error MaxSupplyReached();
    error InvalidMaxSupply();
    error NoBalanceToWithdraw();
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
    
    // Color palettes
    string[] private bgColors = ["#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7"];
    string[] private fgColors = ["#2D3436", "#6C5CE7", "#00B894", "#E17055", "#0984E3"];
    string[] private shapes = ["circle", "rect", "polygon"];
    
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
    
    // ============ SVG Generation ============
    /**
     * @notice Generates an SVG image for a token
     */
    function generateSVG(uint256 tokenId) public view returns (string memory) {
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId, address(this))));
        
        string memory bgColor = bgColors[seed % bgColors.length];
        string memory fgColor = fgColors[(seed / 10) % fgColors.length];
        uint256 shapeType = (seed / 100) % 3;
        
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">',
            '<rect width="400" height="400" fill="', bgColor, '"/>',
            '<text x="200" y="30" text-anchor="middle" font-size="20" fill="', fgColor, '">',
            _name, ' #', tokenId.toString(),
            '</text>',
            _generateShape(shapeType, fgColor, seed),
            _generatePattern(seed, fgColor),
            '</svg>'
        ));
        
        return svg;
    }
    
    /**
     * @notice Generates different shapes based on type
     */
    function _generateShape(uint256 shapeType, string memory color, uint256 seed) private pure returns (string memory) {
        if (shapeType == 0) {
            // Circle
            uint256 radius = 50 + (seed % 50);
            return string(abi.encodePacked(
                '<circle cx="200" cy="200" r="', radius.toString(), 
                '" fill="', color, '" opacity="0.8"/>'
            ));
        } else if (shapeType == 1) {
            // Rectangle
            uint256 width = 100 + (seed % 100);
            uint256 height = 100 + ((seed / 1000) % 100);
            return string(abi.encodePacked(
                '<rect x="', (200 - width/2).toString(), 
                '" y="', (200 - height/2).toString(),
                '" width="', width.toString(),
                '" height="', height.toString(),
                '" fill="', color, '" opacity="0.8"/>'
            ));
        } else {
            // Triangle
            return string(abi.encodePacked(
                '<polygon points="200,100 300,300 100,300" fill="', color, '" opacity="0.8"/>'
            ));
        }
    }
    
    /**
     * @notice Generates decorative patterns
     */
    function _generatePattern(uint256 seed, string memory color) private pure returns (string memory) {
        string memory pattern = '';
        uint256 numCircles = 3 + (seed % 5);
        
        for (uint256 i = 0; i < numCircles; i++) {
            uint256 x = 50 + ((seed * (i + 1)) % 300);
            uint256 y = 50 + ((seed * (i + 2)) % 300);
            uint256 r = 5 + ((seed * (i + 3)) % 15);
            
            pattern = string(abi.encodePacked(
                pattern,
                '<circle cx="', x.toString(),
                '" cy="', y.toString(),
                '" r="', r.toString(),
                '" fill="', color,
                '" opacity="0.3"/>'
            ));
        }
        
        return pattern;
    }
    
    /**
     * @notice Generates attributes for a token
     */
    function getAttributes(uint256 tokenId) public view returns (
        string memory background,
        string memory foreground,
        string memory shape,
        uint256 complexity
    ) {
        uint256 seed = uint256(keccak256(abi.encodePacked(tokenId, address(this))));
        
        background = bgColors[seed % bgColors.length];
        foreground = fgColors[(seed / 10) % fgColors.length];
        shape = shapes[(seed / 100) % shapes.length];
        complexity = (seed % 10) + 1;
    }
    
    // ============ Metadata Generation ============
    /**
     * @notice Returns fully formed on-chain metadata with embedded SVG
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        
        string memory svg = generateSVG(tokenId);
        string memory svgBase64 = Base64.encode(bytes(svg));
        
        (string memory background, string memory foreground, string memory shape, uint256 complexity) = getAttributes(tokenId);
        
        // Build the JSON metadata with embedded SVG image
        string memory json = string(abi.encodePacked(
            '{"name": "', _name, ' #', tokenId.toString(), '",',
            '"description": "100% on-chain generative art NFT with dynamic SVG images",',
            '"image": "data:image/svg+xml;base64,', svgBase64, '",',
            '"attributes": [',
                '{"trait_type": "Background", "value": "', background, '"},',
                '{"trait_type": "Foreground", "value": "', foreground, '"},',
                '{"trait_type": "Shape", "value": "', shape, '"},',
                '{"trait_type": "Complexity", "value": ', complexity.toString(), '}',
            ']}'
        ));
        
        // Return as base64 encoded data URI
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    // ============ View Functions ============
    /**
     * @notice Returns raw SVG string for a token
     */
    function getSVG(uint256 tokenId) external view returns (string memory) {
        _requireMinted(tokenId);
        return generateSVG(tokenId);
    }
    
    /**
     * @notice Returns SVG as base64 data URI
     */
    function getSVGDataURI(uint256 tokenId) external view returns (string memory) {
        _requireMinted(tokenId);
        string memory svg = generateSVG(tokenId);
        return string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
    }
    
    // ============ Admin Functions ============
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoBalanceToWithdraw();
        
        (bool success, ) = payable(owner).call{value: balance}("");
        if (!success) revert TransferFailed();
        
        emit Withdrawn(owner, balance);
    }
    
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    
    receive() external payable {}
    
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