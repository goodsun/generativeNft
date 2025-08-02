// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NFTMetadataOnChain is ERC721 {
    using Strings for uint256;
    
    // 属性の定義
    string[10] private bloodlines = ["Dragon", "Phoenix", "Unicorn", "Griffin", "Sphinx", "Kraken", "Pegasus", "Hydra", "Minotaur", "Chimera"];
    string[10] private ancientForces = ["Mystical", "Legendary", "Cosmic", "Ancient", "Ethereal", "Radiant", "Shadow", "Crystal", "Golden", "Silver"];
    string[10] private elementalAffinities = ["Red", "Blue", "Green", "Purple", "Gold", "Silver", "Black", "White", "Rainbow", "Crystal"];
    
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 3 ether; // 3 POL on Polygon
    uint256 private _currentTokenId = 0;
    address private _owner;
    
    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }
    
    constructor() ERC721("OnChainNFT", "OCNFT") {
        _owner = msg.sender;
    }
    
    function mint() public payable {
        require(_currentTokenId < MAX_SUPPLY, "Max supply reached");
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        
        _currentTokenId++;
        _mint(msg.sender, _currentTokenId);
        
        // 余分な支払いがあった場合は返金
        if (msg.value > MINT_PRICE) {
            payable(msg.sender).transfer(msg.value - MINT_PRICE);
        }
    }
    
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(_owner).transfer(balance);
    }
    
    function totalSupply() public view returns (uint256) {
        return _currentTokenId;
    }
    
    // シード付き疑似乱数生成
    function random(uint256 seed) private pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(seed)));
    }
    
    // 属性の取得
    function getBloodline(uint256 tokenId) public view returns (string memory) {
        return bloodlines[random(tokenId + 1) % 10];
    }
    
    function getAncientForce(uint256 tokenId) public view returns (string memory) {
        return ancientForces[random(tokenId + 2) % 10];
    }
    
    function getElementalAffinity(uint256 tokenId) public view returns (string memory) {
        return elementalAffinities[random(tokenId + 3) % 10];
    }
    
    function getArcanePotency(uint256 tokenId) public pure returns (uint256) {
        return (random(tokenId + 4) % 100) + 1;
    }
    
    // 色の生成
    function getColor(uint256 tokenId) private pure returns (string memory) {
        uint256 r = (random(tokenId + 100) % 256);
        uint256 g = (random(tokenId + 200) % 256);
        uint256 b = (random(tokenId + 300) % 256);
        return string(abi.encodePacked("rgb(", r.toString(), ",", g.toString(), ",", b.toString(), ")"));
    }
    
    // エフェクトの生成（簡略版）
    function getEffect(uint256 tokenId) private pure returns (string memory) {
        uint256 powerLevel = getArcanePotency(tokenId);
        uint256 effectIndex = (powerLevel - 1) / 10;
        
        if (effectIndex == 0) {
            // 1-10: 回転する光の粒子（簡略版）
            return '<circle cx="450" cy="150" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="2s" repeatCount="indefinite"/></circle>';
        } else if (effectIndex == 1) {
            // 11-20: 星
            return '<text x="300" y="100" font-size="30" fill="yellow">&#9733;</text>';
        } else if (effectIndex == 2) {
            // 21-30: 魔法陣（簡略版）
            return '<circle cx="300" cy="300" r="180" fill="none" stroke="cyan" stroke-width="2" opacity="0.7"/>';
        } else if (effectIndex == 3) {
            // 31-40: パルスする輪
            return '<circle cx="300" cy="300" r="200" fill="none" stroke="white" stroke-width="2" opacity="0.3"><animate attributeName="r" values="200;250;200" dur="3s" repeatCount="indefinite"/></circle>';
        } else if (effectIndex == 4) {
            // 41-50: 光線（簡略版）
            return '<line x1="300" y1="300" x2="300" y2="50" stroke="gold" stroke-width="3" opacity="0.5"/>';
        } else if (effectIndex == 5) {
            // 51-60: ダイヤモンド
            return '<path d="M300,150 L450,300 L300,450 L150,300 Z" fill="none" stroke="magenta" stroke-width="3" opacity="0.5"/>';
        } else if (effectIndex == 6) {
            // 61-70: オーラ（簡略版）
            return '<ellipse cx="300" cy="300" rx="200" ry="250" fill="none" stroke="cyan" stroke-width="3" opacity="0.6"/>';
        } else if (effectIndex == 7) {
            // 71-80: ダビデの星（簡略版）
            return '<path d="M300,150 L430,375 L170,375 Z" fill="none" stroke="cyan" stroke-width="3" opacity="0.8"/>';
        } else if (effectIndex == 8) {
            // 81-90: 螺旋
            return '<path d="M300,300 m-150,0 a150,150 0 0,1 300,0 a150,150 0 0,1 -300,0" fill="none" stroke="lime" stroke-width="3" opacity="0.6"/>';
        } else {
            // 91-100: 究極のエフェクト（簡略版）
            return '<circle cx="300" cy="300" r="250" fill="none" stroke="gold" stroke-width="5" opacity="0.8"/>';
        }
    }
    
    // SVG生成
    function generateSVG(uint256 tokenId) public view returns (string memory) {
        string memory bloodline = getBloodline(tokenId);
        string memory ancientForce = getAncientForce(tokenId);
        string memory color = getColor(tokenId);
        string memory effect = getEffect(tokenId);
        
        string memory svg = string(abi.encodePacked(
            '<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">',
            '<defs><linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">',
            '<stop offset="0%" style="stop-color:', color, ';stop-opacity:1" />',
            '<stop offset="100%" style="stop-color:#1a1a1a;stop-opacity:1" />',
            '</linearGradient></defs>',
            '<rect width="600" height="600" fill="url(#grad1)"/>',
            effect,
            '<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="Arial, sans-serif" font-size="40" fill="white" font-weight="bold">',
            '<animate attributeName="opacity" values="0.6;1;0.6" dur="3s" repeatCount="indefinite"/>',
            ancientForce, ' ', bloodline, ' #', tokenId.toString(),
            '</text></svg>'
        ));
        
        return svg;
    }
    
    // メタデータ生成
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        
        string memory bloodline = getBloodline(tokenId);
        string memory ancientForce = getAncientForce(tokenId);
        string memory elementalAffinity = getElementalAffinity(tokenId);
        uint256 arcanePotency = getArcanePotency(tokenId);
        
        string memory svg = generateSVG(tokenId);
        string memory imageUri = string(abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        ));
        
        string memory json = string(abi.encodePacked(
            '{"name":"', ancientForce, ' ', bloodline, ' #', tokenId.toString(), '",',
            '"description":"A rare ', lower(elementalAffinity), ' ', lower(bloodline), 
            ' with ', lower(ancientForce), ' powers. This unique NFT is part of the legendary collection.",',
            '"image":"', imageUri, '",',
            '"attributes":[',
            '{"trait_type":"Bloodline","value":"', bloodline, '"},',
            '{"trait_type":"Ancient Force","value":"', ancientForce, '"},',
            '{"trait_type":"Elemental Affinity","value":"', elementalAffinity, '"},',
            '{"trait_type":"Arcane Potency","value":', arcanePotency.toString(), '}',
            ']}'
        ));
        
        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(bytes(json))
        ));
    }
    
    // 文字列を小文字に変換
    function lower(string memory _base) internal pure returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] >= 0x41 && _baseBytes[i] <= 0x5A) {
                _baseBytes[i] = bytes1(uint8(_baseBytes[i]) + 32);
            }
        }
        return string(_baseBytes);
    }
    
    // tokenIdの存在確認（OpenZeppelin v5では_ownerOfを使用）
    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }
}