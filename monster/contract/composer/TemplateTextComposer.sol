// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ITextComposer.sol";
import "../bank/MaterialBank.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/utils/Strings.sol";

/**
 * @title ITextMaterialBank
 * @notice Interface for text template storage
 */
interface ITextMaterialBank {
    function getTemplate(uint256 templateId) external view returns (string memory);
    function getPlaceholder(string memory key) external view returns (string memory);
    function getLegendaryText(uint256 tokenId) external view returns (string memory);
}

/**
 * @title TemplateTextComposer
 * @notice Text composer using template system with placeholders
 * @dev Supports {PLACEHOLDER} style replacements
 */
contract TemplateTextComposer is ITextComposer {
    using Strings for uint256;
    
    ITextMaterialBank public immutable textBank;
    
    // Default placeholders (can be overridden by textBank)
    mapping(string => string[]) private defaultValues;
    
    constructor(address _textBank) {
        textBank = ITextMaterialBank(_textBank);
        _initializeDefaults();
    }
    
    function _initializeDefaults() private {
        // Default character names
        string[10] memory chars = ["Demon", "Dragon", "Frankenstein", "Goblin", "Mummy", 
                                   "Skeleton", "Vampire", "Werewolf", "Zombie", "Succubus"];
        for (uint i = 0; i < 10; i++) {
            defaultValues["CHAR"].push(chars[i]);
        }
        
        // Default items
        string[10] memory items = ["Crown", "Sword", "Shield", "Poison", "Torch", 
                                   "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"];
        for (uint i = 0; i < 10; i++) {
            defaultValues["ITEM"].push(items[i]);
        }
    }
    
    /**
     * @notice Compose name with template system
     */
    function composeName(
        uint256 tokenId,
        uint8 characterId,
        uint8 itemId
    ) external view override returns (string memory) {
        // Check for legendary override first
        string memory legendaryName = textBank.getLegendaryText(tokenId);
        if (bytes(legendaryName).length > 0) {
            return legendaryName;
        }
        
        // Get name template
        string memory template = textBank.getTemplate(0); // Template ID 0 for names
        if (bytes(template).length == 0) {
            template = "{CHAR} #{ID}"; // Default template
        }
        
        // Replace placeholders
        return replacePlaceholders(template, tokenId, characterId, itemId, 0, 0);
    }
    
    /**
     * @notice Compose description with template system
     */
    function composeDescription(
        uint8 characterId,
        uint8 itemId,
        uint8 backgroundId,
        uint8 effectId
    ) external view override returns (string memory) {
        // Get description template
        string memory template = textBank.getTemplate(1); // Template ID 1 for descriptions
        if (bytes(template).length == 0) {
            template = "A {BG}-touched {CHAR} wielding {ITEM}, cursed with {EFFECT}.";
        }
        
        return replacePlaceholders(template, 0, characterId, itemId, backgroundId, effectId);
    }
    
    /**
     * @notice Compose story with template system
     */
    function composeStory(
        uint256 seed,
        uint8[] memory attributes
    ) external view override returns (string memory) {
        require(attributes.length >= 4, "Need 4 attributes");
        
        // Select story template based on seed
        uint256 templateId = 100 + (seed % 10); // Story templates start at 100
        string memory template = textBank.getTemplate(templateId);
        
        if (bytes(template).length == 0) {
            // Default story templates
            if (seed % 3 == 0) {
                template = "In the {BG} realm, a {CHAR} found the {ITEM}. Now {EFFECT} consumes them.";
            } else if (seed % 3 == 1) {
                template = "The {CHAR} of {BG} wields {ITEM} to channel {EFFECT} powers.";
            } else {
                template = "Once noble, this {CHAR} fell to {BG}'s corruption. The {ITEM} amplifies their {EFFECT}.";
            }
        }
        
        return replacePlaceholders(
            template, 
            seed, 
            attributes[0], 
            attributes[1], 
            attributes[2], 
            attributes[3]
        );
    }
    
    /**
     * @notice Replace placeholders in template
     */
    function replacePlaceholders(
        string memory template,
        uint256 tokenId,
        uint8 charId,
        uint8 itemId,
        uint8 bgId,
        uint8 effectId
    ) public view returns (string memory) {
        // This is a simplified version - in production would use more sophisticated replacement
        string memory result = template;
        
        // Replace {ID}
        result = replace(result, "{ID}", tokenId.toString());
        
        // Replace {CHAR}
        string memory charName = getValueFor("CHAR", charId);
        result = replace(result, "{CHAR}", charName);
        
        // Replace {ITEM}
        string memory itemName = getValueFor("ITEM", itemId);
        result = replace(result, "{ITEM}", itemName);
        
        // Replace {BG} / {BACKGROUND}
        string memory bgName = getValueFor("BG", bgId);
        result = replace(result, "{BG}", bgName);
        result = replace(result, "{BACKGROUND}", bgName);
        
        // Replace {EFFECT} / {EX}
        string memory effectName = getValueFor("EFFECT", effectId);
        result = replace(result, "{EFFECT}", effectName);
        result = replace(result, "{EX}", effectName);
        
        return result;
    }
    
    /**
     * @notice Get value for placeholder
     */
    function getValueFor(string memory key, uint8 index) private view returns (string memory) {
        // First check textBank
        string memory value = textBank.getPlaceholder(string(abi.encodePacked(key, "_", index.toString())));
        if (bytes(value).length > 0) {
            return value;
        }
        
        // Fall back to defaults
        if (index < defaultValues[key].length) {
            return defaultValues[key][index];
        }
        
        return string(abi.encodePacked(key, index.toString()));
    }
    
    /**
     * @notice Simple string replacement (production would use better algorithm)
     */
    function replace(
        string memory str,
        string memory find,
        string memory replacement
    ) private pure returns (string memory) {
        // This is a placeholder - real implementation would do actual replacement
        // For now, return concatenated for demonstration
        return str; // In production: implement actual string replacement
    }
}

/**
 * @title TextMaterialBank
 * @notice Storage for text templates and values
 */
contract TextMaterialBank is ITextMaterialBank, IMaterialBank {
    
    // Template storage
    mapping(uint256 => string) public templates;
    mapping(string => string) public placeholders;
    mapping(uint256 => string) public legendaryTexts;
    
    // Material interface compliance
    mapping(MaterialType => mapping(uint256 => string)) private materials;
    
    constructor() {
        _initializeTemplates();
        _initializeLegendaries();
    }
    
    function _initializeTemplates() private {
        // Name templates
        templates[0] = "{CHAR} #{ID}";
        templates[1] = "The {EFFECT} {CHAR}";
        templates[2] = "{CHAR} of {BG}";
        templates[3] = "{ITEM}-wielding {CHAR}";
        
        // Description templates
        templates[10] = "A {BG}-touched {CHAR} wielding {ITEM}, cursed with {EFFECT}.";
        templates[11] = "In the realm of {BG}, this {CHAR} found the {ITEM}. {EFFECT} follows.";
        templates[12] = "The {EFFECT} curse manifests in this {CHAR} from {BG} lands.";
        
        // Story templates
        templates[100] = "Long ago in {BG}, a {CHAR} discovered {ITEM}. The {EFFECT} curse began that day...";
        templates[101] = "They say the {CHAR} still roams {BG}, {ITEM} in hand, spreading {EFFECT}.";
        templates[102] = "Beware the {EFFECT} of the {BG} {CHAR}, for their {ITEM} knows no mercy.";
        
        // Special combo templates
        templates[200] = "The legendary {CHAR} {ITEM} combo unleashes devastating {EFFECT} in {BG}!";
        templates[201] = "When {CHAR} meets {ITEM} in {BG}, {EFFECT} becomes destiny.";
    }
    
    function _initializeLegendaries() private {
        // Legendary overrides - return complete string
        legendaryTexts[0] = "GENESIS - The First";
        legendaryTexts[666] = "THE BEAST - Apocalypse Incarnate";
        legendaryTexts[1337] = "ELITE HACKER - Master of the Digital Realm";
        legendaryTexts[9999] = "OMEGA - The Final Form";
        
        // Word-based legendaries
        legendaryTexts[0x60D5] = "GODS - Divine Collection";
        legendaryTexts[0xD715] = "DVLS - Demonic Legion";
        legendaryTexts[0x12B0] = "ROBO - Mechanical Army";
        legendaryTexts[0x1234] = "WIZS - Arcane Masters";
    }
    
    function getTemplate(uint256 templateId) external view override returns (string memory) {
        return templates[templateId];
    }
    
    function getPlaceholder(string memory key) external view override returns (string memory) {
        return placeholders[key];
    }
    
    function getLegendaryText(uint256 tokenId) external view override returns (string memory) {
        return legendaryTexts[tokenId];
    }
    
    /**
     * @notice Set custom template
     */
    function setTemplate(uint256 templateId, string memory template) external {
        templates[templateId] = template;
    }
    
    /**
     * @notice Set placeholder value
     */
    function setPlaceholder(string memory key, string memory value) external {
        placeholders[key] = value;
    }
    
    /**
     * @notice Batch set placeholders for an attribute type
     */
    function setPlaceholderArray(string memory baseKey, string[] memory values) external {
        for (uint i = 0; i < values.length; i++) {
            placeholders[string(abi.encodePacked(baseKey, "_", i.toString()))] = values[i];
        }
    }
    
    // IMaterialBank implementation
    function getMaterial(MaterialType materialType, uint256 id) external view override returns (string memory) {
        if (materialType == MaterialType.CUSTOM) {
            return templates[id];
        }
        return materials[materialType][id];
    }
    
    function getMaterialName(MaterialType, uint256) external pure override returns (string memory) {
        return "Text Template";
    }
    
    function getMaterialCount(MaterialType) external pure override returns (uint256) {
        return 1000; // Arbitrary large number
    }
    
    function isMaterialExists(MaterialType materialType, uint256 id) external view override returns (bool) {
        if (materialType == MaterialType.CUSTOM) {
            return bytes(templates[id]).length > 0;
        }
        return bytes(materials[materialType][id]).length > 0;
    }
}

/**
 * @title MultilingualTextComposer
 * @notice Text composer with multi-language support
 */
contract MultilingualTextComposer is TemplateTextComposer {
    
    mapping(string => address) public languageBanks;
    string public currentLanguage = "EN";
    
    constructor(address _defaultTextBank) TemplateTextComposer(_defaultTextBank) {}
    
    function setLanguageBank(string memory lang, address bankAddress) external {
        languageBanks[lang] = bankAddress;
    }
    
    function setCurrentLanguage(string memory lang) external {
        currentLanguage = lang;
    }
    
    function getActiveTextBank() public view returns (address) {
        address langBank = languageBanks[currentLanguage];
        return langBank != address(0) ? langBank : address(textBank);
    }
}