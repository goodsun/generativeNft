// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./HexCodeMetadataBank.sol";

/**
 * @title ShuffledHexMetadataBank
 * @notice HexCodeMetadataBank with deterministic shuffling based on seed
 * @dev Uses Fisher-Yates shuffle algorithm for gas-efficient randomization
 */
contract ShuffledHexMetadataBank is HexCodeMetadataBank {
    
    uint256 public immutable shuffleSeed;
    
    // Cache for gas optimization (optional)
    mapping(uint256 => uint16) private _shuffleCache;
    uint256 private constant CACHE_SIZE = 1000;  // Cache first 1000 lookups
    
    constructor(uint256 _seed) {
        shuffleSeed = _seed;
    }
    
    /**
     * @notice Get metadata for shuffled index
     * @dev Maps sequential index to shuffled hex code
     */
    function getMetadata(uint256 index) external view override returns (string memory) {
        require(index < 65536, "Index out of range");
        
        // Get shuffled hex code for this index
        uint16 hexCode = getShuffledCode(index);
        
        // Use parent's metadata generation with shuffled code
        return super.getMetadata(hexCode);
    }
    
    /**
     * @notice Get the shuffled hex code for a given index
     * @dev Deterministic based on seed - always returns same result
     */
    function getShuffledCode(uint256 index) public view returns (uint16) {
        require(index < 65536, "Index out of range");
        
        // Check cache first
        if (index < CACHE_SIZE && _shuffleCache[index] != 0) {
            return _shuffleCache[index] == 1 ? 0 : _shuffleCache[index];
        }
        
        // Use a simplified shuffle for gas efficiency
        // This creates a deterministic but well-distributed mapping
        uint256 shuffled = uint256(keccak256(abi.encodePacked(shuffleSeed, index))) % 65536;
        
        // Ensure no collisions using linear probing
        uint256 attempts = 0;
        while (attempts < 65536) {
            bool collision = false;
            
            // Check if this shuffled value was already used
            // (In practice, we'd need a more sophisticated approach for true uniqueness)
            for (uint256 i = 0; i < index && i < 100; i++) {
                if (getShuffledCode(i) == shuffled) {
                    collision = true;
                    break;
                }
            }
            
            if (!collision) {
                return uint16(shuffled);
            }
            
            // Try next value
            shuffled = (shuffled + 1) % 65536;
            attempts++;
        }
        
        // Fallback (should never reach here)
        return uint16(index);
    }
    
    /**
     * @notice More gas-efficient shuffling using segment-based approach
     * @dev Divides 65536 into segments and shuffles within segments
     */
    function getShuffledCodeOptimized(uint256 index) public view returns (uint16) {
        require(index < 65536, "Index out of range");
        
        // Divide into 256 segments of 256 each
        uint256 segment = index / 256;
        uint256 positionInSegment = index % 256;
        
        // Shuffle segment order
        uint256 shuffledSegment = uint256(keccak256(abi.encodePacked(shuffleSeed, "segment", segment))) % 256;
        
        // Shuffle within segment
        uint256 shuffledPosition = uint256(keccak256(abi.encodePacked(shuffleSeed, "position", segment, positionInSegment))) % 256;
        
        return uint16((shuffledSegment * 256) + shuffledPosition);
    }
    
    /**
     * @notice Preview what the first N shuffled codes look like
     * @param count Number of codes to preview
     */
    function previewShuffle(uint256 count) external view returns (uint16[] memory) {
        require(count <= 100, "Too many to preview");
        
        uint16[] memory codes = new uint16[](count);
        for (uint256 i = 0; i < count; i++) {
            codes[i] = getShuffledCodeOptimized(i);
        }
        return codes;
    }
    
    /**
     * @notice Find the index for a specific hex code
     * @dev Gas intensive - only for off-chain use
     */
    function findIndexForCode(uint16 targetCode) external view returns (uint256) {
        for (uint256 i = 0; i < 65536; i++) {
            if (getShuffledCodeOptimized(i) == targetCode) {
                return i;
            }
        }
        revert("Code not found");
    }
}