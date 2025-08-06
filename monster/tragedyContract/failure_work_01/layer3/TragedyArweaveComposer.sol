// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyArweaveComposer
 * @notice SVG composer that uses Arweave URLs for backgrounds/effects and applies color filters
 * @dev This composer generates SVGs with hue rotation filters based on background themes
 */
contract TragedyArweaveComposer {
    
    // Arweave base URL (can be updated if needed)
    string public constant ARWEAVE_BASE = "https://arweave.net/";
    
    // Background Arweave transaction IDs
    string[10] public backgroundTxIds = [
        "Bloodmoon_tx_id",  // 0
        "Abyss_tx_id",      // 1
        "Decay_tx_id",      // 2
        "Corruption_tx_id", // 3
        "Venom_tx_id",      // 4
        "Void_tx_id",       // 5
        "Inferno_tx_id",    // 6
        "Frost_tx_id",      // 7
        "Ragnarok_tx_id",   // 8
        "Shadow_tx_id"      // 9
    ];
    
    // Effect Arweave transaction IDs
    string[10] public effectTxIds = [
        "Seizure_tx_id",    // 0
        "Mindblast_tx_id",  // 1
        "Confusion_tx_id",  // 2
        "Meteor_tx_id",     // 3
        "Bats_tx_id",       // 4
        "Poisoning_tx_id",  // 5
        "Lightning_tx_id",  // 6
        "Blizzard_tx_id",   // 7
        "Burning_tx_id",    // 8
        "Brainwash_tx_id"   // 9
    ];
    
    // Filter parameters for each background theme
    struct FilterParams {
        uint16 hueRotate;    // 0-360 degrees
        uint16 saturate;     // Multiplied by 100 (150 = 1.5)
        uint16 brightness;   // Multiplied by 100 (120 = 1.2)
    }
    
    FilterParams[10] public filterParams = [
        FilterParams(0, 150, 120),     // Bloodmoon: red
        FilterParams(240, 130, 90),    // Abyss: deep blue-purple
        FilterParams(80, 120, 95),     // Decay: sickly yellow-green
        FilterParams(280, 140, 100),   // Corruption: purple
        FilterParams(120, 180, 110),   // Venom: bright green
        FilterParams(0, 20, 70),       // Void: desaturated dark
        FilterParams(20, 160, 120),    // Inferno: orange-red
        FilterParams(200, 140, 120),   // Frost: ice blue
        FilterParams(15, 130, 85),     // Ragnarok: dark red-orange
        FilterParams(220, 50, 60)      // Shadow: dark blue
    ];
    
    // Monster and Item banks (keeping existing approach for on-chain storage)
    address public monsterBank;
    address public itemBank;
    
    // Owner for updating Arweave IDs if needed
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(address _monsterBank, address _itemBank) {
        monsterBank = _monsterBank;
        itemBank = _itemBank;
        owner = msg.sender;
    }
    
    /**
     * @notice Update Arweave transaction ID for a background
     */
    function updateBackgroundTxId(uint8 id, string calldata txId) external onlyOwner {
        require(id < 10, "Invalid background ID");
        backgroundTxIds[id] = txId;
    }
    
    /**
     * @notice Update Arweave transaction ID for an effect
     */
    function updateEffectTxId(uint8 id, string calldata txId) external onlyOwner {
        require(id < 10, "Invalid effect ID");
        effectTxIds[id] = txId;
    }
    
    /**
     * @notice Update filter parameters for a background
     */
    function updateFilterParams(
        uint8 id, 
        uint16 hueRotate, 
        uint16 saturate, 
        uint16 brightness
    ) external onlyOwner {
        require(id < 10, "Invalid background ID");
        filterParams[id] = FilterParams(hueRotate, saturate, brightness);
    }
    
    /**
     * @notice Generate the filter definition for a background
     */
    function generateFilterDef(uint8 background, string memory filterId) internal view returns (string memory) {
        FilterParams memory params = filterParams[background];
        
        return string(abi.encodePacked(
            '<defs>',
            '<filter id="', filterId, '">',
            '<feColorMatrix type="hueRotate" values="', uint2str(params.hueRotate), '"/>',
            '<feColorMatrix type="saturate" values="', uint2str(params.saturate), '"/>',
            '<feComponentTransfer>',
            '<feFuncR type="linear" slope="', uint2str(params.brightness), '"/>',
            '<feFuncG type="linear" slope="', uint2str(params.brightness), '"/>',
            '<feFuncB type="linear" slope="', uint2str(params.brightness), '"/>',
            '</feComponentTransfer>',
            '</filter>',
            '</defs>'
        ));
    }
    
    /**
     * @notice Get monster SVG data as base64
     */
    function getMonsterBase64(uint8 species) internal view returns (string memory) {
        // Call the monster bank to get SVG
        (bool success, bytes memory data) = monsterBank.staticcall(
            abi.encodeWithSignature("getSpeciesSVG(uint8)", species)
        );
        require(success, "Failed to get monster SVG");
        
        string memory svg = abi.decode(data, (string));
        // In production, this would need base64 encoding
        // For now, returning as data URI placeholder
        return string(abi.encodePacked("data:image/svg+xml;base64,", svg));
    }
    
    /**
     * @notice Get item SVG data as base64
     */
    function getItemBase64(uint8 item) internal view returns (string memory) {
        // Call the item bank to get SVG
        (bool success, bytes memory data) = itemBank.staticcall(
            abi.encodeWithSignature("getItemSVG(uint8)", item)
        );
        require(success, "Failed to get item SVG");
        
        string memory svg = abi.decode(data, (string));
        // In production, this would need base64 encoding
        return string(abi.encodePacked("data:image/svg+xml;base64,", svg));
    }
    
    /**
     * @notice Compose the final SVG with all layers and filters
     */
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        // Generate unique filter ID
        string memory filterId = string(abi.encodePacked(
            "filter-bg", uint2str(background), "-", uint2str(block.timestamp % 1000000)
        ));
        
        // Start building SVG
        string memory svg = '<svg width="240" height="240" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">';
        
        // Add filter definition
        svg = string(abi.encodePacked(svg, generateFilterDef(background, filterId)));
        
        // Layer 1: Background (Arweave)
        svg = string(abi.encodePacked(
            svg,
            '<image href="', ARWEAVE_BASE, backgroundTxIds[background], 
            '" x="0" y="0" width="24" height="24"/>'
        ));
        
        // Layer 2: Monster (with filter)
        string memory monsterData = getMonsterBase64(species);
        svg = string(abi.encodePacked(
            svg,
            '<image href="', monsterData, 
            '" x="0" y="0" width="24" height="24" filter="url(#', filterId, ')"/>'
        ));
        
        // Layer 3: Item
        string memory itemData = getItemBase64(item);
        svg = string(abi.encodePacked(
            svg,
            '<image href="', itemData, 
            '" x="0" y="0" width="24" height="24"/>'
        ));
        
        // Layer 4: Effect (Arweave)
        svg = string(abi.encodePacked(
            svg,
            '<image href="', ARWEAVE_BASE, effectTxIds[effect], 
            '" x="0" y="0" width="24" height="24"/>'
        ));
        
        // Close SVG
        svg = string(abi.encodePacked(svg, '</svg>'));
        
        return svg;
    }
    
    /**
     * @notice Convert uint to string with decimal support
     */
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        
        // For decimal values (saturate, brightness)
        if (_i >= 100) {
            uint256 whole = _i / 100;
            uint256 decimal = _i % 100;
            
            if (decimal == 0) {
                return uint2strSimple(whole);
            }
            
            // Return as decimal (e.g., "1.5")
            return string(abi.encodePacked(
                uint2strSimple(whole),
                ".",
                decimal < 10 ? "0" : "",
                uint2strSimple(decimal)
            ));
        }
        
        return uint2strSimple(_i);
    }
    
    /**
     * @notice Simple uint to string conversion
     */
    function uint2strSimple(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}