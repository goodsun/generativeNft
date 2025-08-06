// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interfaces for material banks
interface IMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

interface IBackgroundBank {
    function getBackgroundSVG(uint8 id) external view returns (string memory);
}

interface IItemBank {
    function getItemSVG(uint8 id) external view returns (string memory);
}

interface IEffectBank {
    function getEffectSVG(uint8 id) external view returns (string memory);
}

/**
 * @title TragedyModularSVGComposerV5
 * @notice Enhanced composer that preserves effect defs and properly layers SVG content
 */
contract TragedyModularSVGComposerV5 {
    IMonsterBank public monsterBank;
    IBackgroundBank public backgroundBank;
    IItemBank public itemBank;
    IEffectBank public effectBank;
    
    constructor(
        address _monsterBank,
        address _backgroundBank,
        address _itemBank,
        address _effectBank
    ) {
        monsterBank = IMonsterBank(_monsterBank);
        backgroundBank = IBackgroundBank(_backgroundBank);
        itemBank = IItemBank(_itemBank);
        effectBank = IEffectBank(_effectBank);
    }
    
    /**
     * @notice Extract content between SVG tags (simple version for non-effect layers)
     */
    function extractSVGContent(string memory svg) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        
        // Find first '>'
        uint256 startPos = 0;
        for (uint256 i = 0; i < svgBytes.length; i++) {
            if (svgBytes[i] == '>') {
                startPos = i + 1;
                break;
            }
        }
        
        // Find '</svg'
        uint256 endPos = svgBytes.length;
        for (uint256 i = svgBytes.length - 5; i > 0; i--) {
            if (svgBytes[i] == '<' && 
                svgBytes[i+1] == '/' && 
                svgBytes[i+2] == 's' && 
                svgBytes[i+3] == 'v' && 
                svgBytes[i+4] == 'g') {
                endPos = i;
                break;
            }
        }
        
        // Extract content
        bytes memory content = new bytes(endPos - startPos);
        for (uint256 i = 0; i < content.length; i++) {
            content[i] = svgBytes[startPos + i];
        }
        
        return string(content);
    }
    
    /**
     * @notice Find position after </defs> in effect SVG
     */
    function findDefsEndPosition(string memory svg) internal pure returns (uint256) {
        bytes memory svgBytes = bytes(svg);
        
        // Look for </defs>
        for (uint256 i = 0; i < svgBytes.length - 7; i++) {
            if (svgBytes[i] == '<' && 
                svgBytes[i+1] == '/' && 
                svgBytes[i+2] == 'd' && 
                svgBytes[i+3] == 'e' && 
                svgBytes[i+4] == 'f' && 
                svgBytes[i+5] == 's' && 
                svgBytes[i+6] == '>') {
                return i + 7; // Position after </defs>
            }
        }
        
        // If no defs found, return position after opening SVG tag
        for (uint256 i = 0; i < svgBytes.length; i++) {
            if (svgBytes[i] == '>') {
                return i + 1;
            }
        }
        
        return 0;
    }
    
    /**
     * @notice Extract SVG header including defs from effect
     */
    function extractSVGHeaderWithDefs(string memory svg, uint256 defsEndPos) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        bytes memory header = new bytes(defsEndPos);
        
        for (uint256 i = 0; i < defsEndPos; i++) {
            header[i] = svgBytes[i];
        }
        
        return string(header);
    }
    
    /**
     * @notice Extract remaining content after defs from effect
     */
    function extractContentAfterDefs(string memory svg, uint256 defsEndPos) internal pure returns (string memory) {
        bytes memory svgBytes = bytes(svg);
        
        // Find </svg position
        uint256 endPos = svgBytes.length;
        for (uint256 i = svgBytes.length - 5; i > 0; i--) {
            if (svgBytes[i] == '<' && 
                svgBytes[i+1] == '/' && 
                svgBytes[i+2] == 's' && 
                svgBytes[i+3] == 'v' && 
                svgBytes[i+4] == 'g') {
                endPos = i;
                break;
            }
        }
        
        // Extract content between defsEndPos and </svg>
        bytes memory content = new bytes(endPos - defsEndPos);
        for (uint256 i = 0; i < content.length; i++) {
            content[i] = svgBytes[defsEndPos + i];
        }
        
        return string(content);
    }
    
    /**
     * @notice Compose SVG with proper layer ordering and defs preservation
     */
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory) {
        // Get all SVGs
        string memory effectSVG = effectBank.getEffectSVG(effect);
        string memory backgroundContent = extractSVGContent(backgroundBank.getBackgroundSVG(background));
        string memory monsterContent = extractSVGContent(monsterBank.getSpeciesSVG(species));
        string memory itemContent = extractSVGContent(itemBank.getItemSVG(item));
        
        // Find defs end position in effect SVG
        uint256 defsEndPos = findDefsEndPosition(effectSVG);
        
        // Extract effect parts
        string memory effectHeader = extractSVGHeaderWithDefs(effectSVG, defsEndPos);
        string memory effectContent = extractContentAfterDefs(effectSVG, defsEndPos);
        
        // Compose final SVG with proper ordering
        return string(abi.encodePacked(
            effectHeader,              // SVG opening tag + defs
            backgroundContent,         // Background layer
            monsterContent,           // Monster layer
            itemContent,              // Item layer
            effectContent,            // Effect content (animations, etc)
            "</svg>"                  // Closing tag
        ));
    }
}