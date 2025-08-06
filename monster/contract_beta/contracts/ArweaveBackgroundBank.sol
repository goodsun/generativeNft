// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArweaveBackgroundBank
 * @notice Stores Arweave URLs for background images
 * @dev Backgrounds are stored on Arweave for permanent storage
 */
contract ArweaveBackgroundBank {
    mapping(uint8 => string) private backgroundUrls;
    
    string[10] public backgroundNames = [
        "Bloodmoon",
        "Abyss",
        "Decay",
        "Corruption",
        "Venom",
        "Void",
        "Inferno",
        "Frost",
        "Ragnarok",
        "Shadow"
    ];
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _initializeUrls();
    }
    
    function _initializeUrls() private {
        // Initialize with actual Arweave URLs
        backgroundUrls[0] = "https://arweave.net/XeooYFmf_rvME-cLCDB-E-F1fOrdUiTSGOoz1q_lONI";
        backgroundUrls[1] = "https://arweave.net/7f4Xexbjb24aOw2z4soba6zaAeYQSWkr1pYAKkZ5h7c";
        backgroundUrls[2] = "https://arweave.net/NBKiR7O_jrBddYDNvdIMfW7t0sc5aIiXuy508WfwPh4";
        backgroundUrls[3] = "https://arweave.net/xFCvtZudtVi8G1ZBSrv59928Xuf68bqtb5z2kDQx50Y";
        backgroundUrls[4] = "https://arweave.net/fT6SUmXAD1DLbVzNkQuKTiN65l-TlPwI6CGXZiZzeIo";
        backgroundUrls[5] = "https://arweave.net/ca3HmME0N1wayBzp03TU9hACYAriGsdd3jURVXhfXHw";
        backgroundUrls[6] = "https://arweave.net/0iMntcJN_7P07V4T5euOk9uVEzhqvoC6vRIxAnCV48U";
        backgroundUrls[7] = "https://arweave.net/bA-7-CU4rveHGA9usO6_TEVucSm1vk6t9-6CPB-0PSQ";
        backgroundUrls[8] = "https://arweave.net/uNVu9Pori_7pEFJ1-WaNg_h3QT0ISdHQf0B_MAXZkgo";
        backgroundUrls[9] = "https://arweave.net/-ZaY-UbqeGLe99zTv1SuFQi39frnTmTDn_g5noQ4bmI";
    }
    
    function getBackgroundUrl(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid background ID");
        return backgroundUrls[id];
    }
    
    function getBackgroundName(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid background ID");
        return backgroundNames[id];
    }
    
    function setBackgroundUrl(uint8 id, string calldata url) external onlyOwner {
        require(id < 10, "Invalid background ID");
        backgroundUrls[id] = url;
    }
    
    // Batch update for gas efficiency
    function setMultipleUrls(uint8[] calldata ids, string[] calldata urls) external onlyOwner {
        require(ids.length == urls.length, "Arrays length mismatch");
        for (uint i = 0; i < ids.length; i++) {
            require(ids[i] < 10, "Invalid background ID");
            backgroundUrls[ids[i]] = urls[i];
        }
    }
}