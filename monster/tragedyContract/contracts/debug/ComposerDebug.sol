// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

contract ComposerDebug {
    IMonsterBank public monsterBank = IMonsterBank(0x604BbbE34BA178bb5630f8a1b6CAB5e4eD99f96b);
    
    // Get raw SVG from bank
    function getRawMonsterSVG(uint8 id) external view returns (string memory) {
        return monsterBank.getSpeciesSVG(id);
    }
    
    // Test extract function step by step
    function testExtractStep1(string memory svg) external pure returns (uint256 startPos, uint256 endPos) {
        bytes memory svgBytes = bytes(svg);
        startPos = 0;
        endPos = svgBytes.length;
        
        // Find first '>'
        for (uint256 i = 0; i < svgBytes.length; i++) {
            if (svgBytes[i] == '>') {
                startPos = i + 1;
                break;
            }
        }
        
        // Find last '</svg'
        for (uint256 i = svgBytes.length - 1; i > startPos; i--) {
            if (svgBytes[i] == '<' && i + 5 < svgBytes.length) {
                if (svgBytes[i + 1] == '/' && 
                    svgBytes[i + 2] == 's' && 
                    svgBytes[i + 3] == 'v' && 
                    svgBytes[i + 4] == 'g') {
                    endPos = i;
                    break;
                }
            }
        }
        
        return (startPos, endPos);
    }
    
    // Simple compose without extraction
    function simpleCompose(uint8 monsterId) external view returns (string memory) {
        string memory monsterSVG = monsterBank.getSpeciesSVG(monsterId);
        return string(abi.encodePacked(
            '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">',
            monsterSVG,
            '</svg>'
        ));
    }
    
    // Get first few bytes of SVG
    function getFirst100Bytes(uint8 monsterId) external view returns (string memory) {
        string memory svg = monsterBank.getSpeciesSVG(monsterId);
        bytes memory svgBytes = bytes(svg);
        uint256 len = svgBytes.length < 100 ? svgBytes.length : 100;
        bytes memory result = new bytes(len);
        for (uint256 i = 0; i < len; i++) {
            result[i] = svgBytes[i];
        }
        return string(result);
    }
}