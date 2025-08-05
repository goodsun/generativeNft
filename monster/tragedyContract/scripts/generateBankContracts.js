const fs = require('fs');
const path = require('path');

// Bankコントラクトを生成する関数
function generateBankContract(type, items) {
    const typeName = type.charAt(0).toUpperCase() + type.slice(1);
    const functionName = type === 'monsters' ? 'getSpeciesSVG' : 
                        type === 'bg' ? 'getBackgroundSVG' :
                        type === 'items' ? 'getEquipmentSVG' :
                        'getEffectSVG';
    
    let code = `// SPDX-License-Identifier: MIT
// Auto-generated Bank Contract
pragma solidity ^0.8.20;

`;
    
    // Import statements
    items.forEach(item => {
        code += `import "./${type}/Tragedy${item}Lib.sol";\n`;
    });
    
    code += `
contract TragedyDetailed${typeName}Bank {
    
    function ${functionName}(uint8 id) external pure returns (string memory) {
`;
    
    // Add if statements
    items.forEach((item, index) => {
        code += `        if (id == ${index}) return Tragedy${item}Lib.getSVG();\n`;
    });
    
    code += `        revert("Invalid ID");
    }
}`;
    
    return code;
}

// メイン処理
async function generateBanks() {
    const config = {
        'monsters': ['Werewolf', 'Goblin', 'Frankenstein', 'Demon', 'Dragon', 
                     'Zombie', 'Vampire', 'Mummy', 'Succubus', 'Skeleton'],
        'bg': ['Bloodmoon', 'Abyss', 'Decay', 'Corruption', 'Venom',
               'Void', 'Inferno', 'Frost', 'Ragnarok', 'Shadow'],
        'items': ['Crown', 'Sword', 'Shield', 'Poison', 'Torch',
                  'Wine', 'Scythe', 'Staff', 'Shoulder', 'Amulet'],
        'effect': ['Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats',
                   'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash']
    };
    
    const OUTPUT_DIR = '../contracts/layer4/generated';
    
    for (const [type, items] of Object.entries(config)) {
        const bankCode = generateBankContract(type, items);
        const outputPath = path.join(OUTPUT_DIR, `TragedyDetailed${type.charAt(0).toUpperCase() + type.slice(1)}Bank.sol`);
        
        fs.writeFileSync(outputPath, bankCode);
        console.log(`✅ Generated: ${outputPath}`);
    }
}

generateBanks().catch(console.error);