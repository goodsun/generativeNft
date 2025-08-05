// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IMaterialBank
 * @notice Interface for material storage system
 */
interface IMaterialBank {
    enum MaterialType {
        SPECIES,    // 0: Monsters, Characters
        EQUIPMENT,  // 1: Items, Weapons, Accessories
        BACKGROUND, // 2: Backgrounds, Environments
        EFFECT,     // 3: Effects, Animations
        SYMBOL,     // 4: Symbols, Icons
        PATTERN,    // 5: Patterns, Textures
        COLOR,      // 6: Color schemes
        CUSTOM      // 7: Custom materials
    }
    
    function getMaterial(MaterialType materialType, uint256 id) external view returns (string memory);
    function getMaterialName(MaterialType materialType, uint256 id) external view returns (string memory);
    function getMaterialCount(MaterialType materialType) external view returns (uint256);
    function isMaterialExists(MaterialType materialType, uint256 id) external view returns (bool);
}

/**
 * @title MaterialBank
 * @notice Universal material storage for NFT projects
 * @dev Store any SVG/visual assets in a reusable way
 */
contract MaterialBank is IMaterialBank {
    
    // Material storage: type => id => SVG data
    mapping(MaterialType => mapping(uint256 => string)) private materials;
    mapping(MaterialType => mapping(uint256 => string)) private materialNames;
    mapping(MaterialType => uint256) private materialCounts;
    
    // Access control
    address public owner;
    mapping(address => bool) public authorized;
    
    // Events
    event MaterialAdded(MaterialType indexed materialType, uint256 indexed id, string name);
    event MaterialUpdated(MaterialType indexed materialType, uint256 indexed id, string name);
    event AuthorizationChanged(address indexed account, bool authorized);
    
    modifier onlyAuthorized() {
        require(msg.sender == owner || authorized[msg.sender], "Not authorized");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @notice Add or update material
     */
    function setMaterial(
        MaterialType materialType,
        uint256 id,
        string memory name,
        string memory svgData
    ) external onlyAuthorized {
        bool isNew = bytes(materials[materialType][id]).length == 0;
        
        materials[materialType][id] = svgData;
        materialNames[materialType][id] = name;
        
        if (isNew) {
            materialCounts[materialType]++;
            emit MaterialAdded(materialType, id, name);
        } else {
            emit MaterialUpdated(materialType, id, name);
        }
    }
    
    /**
     * @notice Batch set materials
     */
    function batchSetMaterials(
        MaterialType materialType,
        uint256[] memory ids,
        string[] memory names,
        string[] memory svgDatas
    ) external onlyAuthorized {
        require(ids.length == names.length && ids.length == svgDatas.length, "Array length mismatch");
        
        for (uint i = 0; i < ids.length; i++) {
            bool isNew = bytes(materials[materialType][ids[i]]).length == 0;
            
            materials[materialType][ids[i]] = svgDatas[i];
            materialNames[materialType][ids[i]] = names[i];
            
            if (isNew) {
                materialCounts[materialType]++;
                emit MaterialAdded(materialType, ids[i], names[i]);
            } else {
                emit MaterialUpdated(materialType, ids[i], names[i]);
            }
        }
    }
    
    /**
     * @notice Get material SVG data
     */
    function getMaterial(MaterialType materialType, uint256 id) external view override returns (string memory) {
        return materials[materialType][id];
    }
    
    /**
     * @notice Get material name
     */
    function getMaterialName(MaterialType materialType, uint256 id) external view override returns (string memory) {
        return materialNames[materialType][id];
    }
    
    /**
     * @notice Get material count for a type
     */
    function getMaterialCount(MaterialType materialType) external view override returns (uint256) {
        return materialCounts[materialType];
    }
    
    /**
     * @notice Check if material exists
     */
    function isMaterialExists(MaterialType materialType, uint256 id) external view override returns (bool) {
        return bytes(materials[materialType][id]).length > 0;
    }
    
    /**
     * @notice Set authorization
     */
    function setAuthorization(address account, bool _authorized) external {
        require(msg.sender == owner, "Only owner");
        authorized[account] = _authorized;
        emit AuthorizationChanged(account, _authorized);
    }
    
    /**
     * @notice Transfer ownership
     */
    function transferOwnership(address newOwner) external {
        require(msg.sender == owner, "Only owner");
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}

/**
 * @title MonsterMaterialBank
 * @notice Pre-populated MaterialBank with Monster NFT assets
 */
contract MonsterMaterialBank is MaterialBank {
    
    constructor() {
        _initializeMonsterMaterials();
    }
    
    function _initializeMonsterMaterials() private {
        // Initialize Species (Monsters)
        _addSpecies(0, "Demon", _getDemonSVG());
        _addSpecies(1, "Dragon", _getDragonSVG());
        _addSpecies(2, "Frankenstein", _getFrankensteinSVG());
        _addSpecies(3, "Goblin", _getGoblinSVG());
        _addSpecies(4, "Mummy", _getMummySVG());
        _addSpecies(5, "Skeleton", _getSkeletonSVG());
        _addSpecies(6, "Vampire", _getVampireSVG());
        _addSpecies(7, "Werewolf", _getWerewolfSVG());
        _addSpecies(8, "Zombie", _getZombieSVG());
        _addSpecies(9, "Succubus", _getSuccubusSVG());
        
        // Initialize Equipment
        _addEquipment(0, "Crown", _getCrownSVG());
        _addEquipment(1, "Sword", _getSwordSVG());
        _addEquipment(2, "Shield", _getShieldSVG());
        _addEquipment(3, "Poison", _getPoisonSVG());
        _addEquipment(4, "Torch", _getTorchSVG());
        _addEquipment(5, "Wine", _getWineSVG());
        _addEquipment(6, "Scythe", _getScytheSVG());
        _addEquipment(7, "Magic Wand", _getMagicWandSVG());
        _addEquipment(8, "Shoulder Armor", _getShoulderArmorSVG());
        _addEquipment(9, "Amulet", _getAmuletSVG());
        
        // Initialize Backgrounds
        _addBackground(0, "Bloodmoon", _getBloodmoonBG());
        _addBackground(1, "Abyss", _getAbyssBG());
        _addBackground(6, "Inferno", _getInfernoBG());
        // Add more...
        
        // Initialize Effects
        _addEffect(0, "Lightning", _getLightningEffect());
        _addEffect(4, "Bats", _getBatsEffect());
        // Add more...
    }
    
    function _addSpecies(uint256 id, string memory name, string memory svg) private {
        materials[MaterialType.SPECIES][id] = svg;
        materialNames[MaterialType.SPECIES][id] = name;
        materialCounts[MaterialType.SPECIES]++;
    }
    
    function _addEquipment(uint256 id, string memory name, string memory svg) private {
        materials[MaterialType.EQUIPMENT][id] = svg;
        materialNames[MaterialType.EQUIPMENT][id] = name;
        materialCounts[MaterialType.EQUIPMENT]++;
    }
    
    function _addBackground(uint256 id, string memory name, string memory svg) private {
        materials[MaterialType.BACKGROUND][id] = svg;
        materialNames[MaterialType.BACKGROUND][id] = name;
        materialCounts[MaterialType.BACKGROUND]++;
    }
    
    function _addEffect(uint256 id, string memory name, string memory svg) private {
        materials[MaterialType.EFFECT][id] = svg;
        materialNames[MaterialType.EFFECT][id] = name;
        materialCounts[MaterialType.EFFECT]++;
    }
    
    // SVG data functions (examples)
    function _getDemonSVG() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="demon">',
            '<rect x="8" y="4" width="8" height="4" fill="#ff0000"/>',
            '<rect x="10" y="8" width="4" height="4" fill="#000000"/>',
            '<rect x="8" y="12" width="8" height="6" fill="#800000"/>',
            '<rect x="6" y="18" width="4" height="2" fill="#000000"/>',
            '<rect x="14" y="18" width="4" height="2" fill="#000000"/>',
            '</g>'
        ));
    }
    
    function _getDragonSVG() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="dragon">',
            '<rect x="6" y="6" width="12" height="8" fill="#008000"/>',
            '<rect x="4" y="8" width="2" height="4" fill="#008000"/>',
            '<rect x="18" y="8" width="2" height="4" fill="#008000"/>',
            '<rect x="8" y="4" width="8" height="4" fill="#00ff00"/>',
            '</g>'
        ));
    }
    
    function _getCrownSVG() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="crown">',
            '<rect x="8" y="2" width="8" height="2" fill="#ffd700"/>',
            '<rect x="8" y="0" width="2" height="2" fill="#ffd700"/>',
            '<rect x="11" y="0" width="2" height="2" fill="#ffd700"/>',
            '<rect x="14" y="0" width="2" height="2" fill="#ffd700"/>',
            '</g>'
        ));
    }
    
    function _getSwordSVG() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="sword">',
            '<rect x="11" y="4" width="2" height="10" fill="#c0c0c0"/>',
            '<rect x="10" y="14" width="4" height="2" fill="#ffd700"/>',
            '<rect x="11" y="16" width="2" height="4" fill="#8b4513"/>',
            '</g>'
        ));
    }
    
    function _getBloodmoonBG() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect width="240" height="240" fill="#1a0000"/>',
            '<circle cx="120" cy="60" r="50" fill="#8b0000"/>',
            '<circle cx="120" cy="60" r="45" fill="#dc143c" opacity="0.8"/>'
        ));
    }
    
    function _getInfernoBG() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<defs>',
                '<linearGradient id="inferno" x1="0%" y1="0%" x2="0%" y2="100%">',
                    '<stop offset="0%" style="stop-color:#ff4500"/>',
                    '<stop offset="100%" style="stop-color:#8b0000"/>',
                '</linearGradient>',
            '</defs>',
            '<rect width="240" height="240" fill="url(#inferno)"/>'
        ));
    }
    
    function _getLightningEffect() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<g opacity="0.8">',
                '<path d="M120,0 L100,80 L140,80 L120,240" stroke="#ffff00" stroke-width="4" fill="none">',
                    '<animate attributeName="opacity" values="0;1;0" dur="0.5s" repeatCount="indefinite"/>',
                '</path>',
            '</g>'
        ));
    }
    
    function _getBatsEffect() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="bats">',
                '<text x="40" y="40" font-size="20" fill="#000">🦇',
                    '<animateTransform attributeName="transform" type="translate" values="0,0; 20,-20; 0,0" dur="4s" repeatCount="indefinite"/>',
                '</text>',
            '</g>'
        ));
    }
    
    // Placeholder functions for remaining SVGs
    function _getFrankensteinSVG() private pure returns (string memory) { return '<g id="frankenstein"></g>'; }
    function _getGoblinSVG() private pure returns (string memory) { return '<g id="goblin"></g>'; }
    function _getMummySVG() private pure returns (string memory) { return '<g id="mummy"></g>'; }
    function _getSkeletonSVG() private pure returns (string memory) { return '<g id="skeleton"></g>'; }
    function _getVampireSVG() private pure returns (string memory) { return '<g id="vampire"></g>'; }
    function _getWerewolfSVG() private pure returns (string memory) { return '<g id="werewolf"></g>'; }
    function _getZombieSVG() private pure returns (string memory) { return '<g id="zombie"></g>'; }
    function _getSuccubusSVG() private pure returns (string memory) { return '<g id="succubus"></g>'; }
    function _getShieldSVG() private pure returns (string memory) { return '<g id="shield"></g>'; }
    function _getPoisonSVG() private pure returns (string memory) { return '<g id="poison"></g>'; }
    function _getTorchSVG() private pure returns (string memory) { return '<g id="torch"></g>'; }
    function _getWineSVG() private pure returns (string memory) { return '<g id="wine"></g>'; }
    function _getScytheSVG() private pure returns (string memory) { return '<g id="scythe"></g>'; }
    function _getMagicWandSVG() private pure returns (string memory) { return '<g id="wand"></g>'; }
    function _getShoulderArmorSVG() private pure returns (string memory) { return '<g id="armor"></g>'; }
    function _getAmuletSVG() private pure returns (string memory) { return '<g id="amulet"></g>'; }
    function _getAbyssBG() private pure returns (string memory) { return '<rect width="240" height="240" fill="#000033"/>'; }
}