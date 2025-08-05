const fs = require('fs');
const path = require('path');

// 個別のコントラクトを生成（ライブラリではなく）
function generateIndividualContract(name, svgContent, type) {
    const minified = minifySVG(svgContent);
    const escaped = escapeForSolidity(minified);
    const chunks = splitString(escaped, 1000);
    
    let code = `// SPDX-License-Identifier: MIT
// Auto-generated from ${type}/${name}.svg
pragma solidity ^0.8.20;

contract Tragedy${name} {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
`;
    
    chunks.forEach((chunk, index) => {
        const isLast = index === chunks.length - 1;
        code += `            '${chunk}'${isLast ? '' : ','}\n`;
    });
    
    code += `        ));
    }
}`;
    
    return code;
}

// Bankコントラクトを生成（外部コントラクトを呼び出す）
function generateModularBank(type, items) {
    const typeName = type.charAt(0).toUpperCase() + type.slice(1);
    const functionName = type === 'monsters' ? 'getSpeciesSVG' : 
                        type === 'bg' ? 'getBackgroundSVG' :
                        type === 'items' ? 'getEquipmentSVG' :
                        'getEffectSVG';
    
    let code = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITragedySVGContract {
    function getSVG() external pure returns (string memory);
}

contract TragedyModular${typeName}Bank {
    mapping(uint8 => address) public svgContracts;
    
    constructor(address[${items.length}] memory _contracts) {
        for (uint8 i = 0; i < ${items.length}; i++) {
            svgContracts[i] = _contracts[i];
        }
    }
    
    function ${functionName}(uint8 id) external view returns (string memory) {
        require(id < ${items.length}, "Invalid ID");
        address svgContract = svgContracts[id];
        require(svgContract != address(0), "Contract not set");
        return ITragedySVGContract(svgContract).getSVG();
    }
    
    function setSVGContract(uint8 id, address contractAddr) external {
        require(id < ${items.length}, "Invalid ID");
        svgContracts[id] = contractAddr;
    }
}`;
    
    return code;
}

// Helper functions (reuse from original script)
function minifySVG(svg) {
    return svg
        .replace(/<!--.*?-->/gs, '')
        .replace(/\n/g, '')
        .replace(/\s+/g, ' ')
        .replace(/>\s+</g, '><')
        .replace(/"\s+/g, '"')
        .replace(/\s+"/g, '"')
        .trim();
}

function escapeForSolidity(str) {
    str = str.replace(/'/g, "\\'");
    return str.replace(/[^\x00-\x7F]/g, function(char) {
        return '\\u' + ('0000' + char.charCodeAt(0).toString(16)).slice(-4);
    });
}

function splitString(str, maxLength) {
    const chunks = [];
    for (let i = 0; i < str.length; i += maxLength) {
        chunks.push(str.slice(i, i + maxLength));
    }
    return chunks;
}

console.log('Generating individual contracts instead of libraries...');