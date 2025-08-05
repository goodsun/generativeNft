const fs = require('fs');
const path = require('path');

// 設定
const MAX_STRING_LENGTH = 1000; // Solidityの文字列リテラル制限
const ASSETS_DIR = '../../assets';
const OUTPUT_DIR = '../contracts/layer4/svgs';

// SVGをminifyする関数
function minifySVG(svg) {
    return svg
        .replace(/<!--.*?-->/gs, '') // コメント削除
        .replace(/[\r\n\t]/g, ' ') // 改行とタブを空白に変換
        .replace(/\s{2,}/g, ' ') // 連続する空白を1つに
        .replace(/>\s+</g, '><') // タグ間の空白削除
        .replace(/\s+>/g, '>') // タグ終了前の空白削除
        .trim();
}

// 特殊文字をエスケープする関数
function escapeForSolidity(str) {
    // シングルクォートをエスケープ
    str = str.replace(/'/g, "\\'");
    
    // Unicode文字を検出してエスケープ（例：★ → \u2605）
    return str.replace(/[^\x00-\x7F]/g, function(char) {
        return '\\u' + ('0000' + char.charCodeAt(0).toString(16)).slice(-4);
    });
}

// 文字列を指定長で分割する関数
function splitString(str, maxLength) {
    const chunks = [];
    for (let i = 0; i < str.length; i += maxLength) {
        chunks.push(str.slice(i, i + maxLength));
    }
    return chunks;
}

// コントラクトコードを生成する関数
function generateContract(name, svgContent, type, suffix = '') {
    const minified = minifySVG(svgContent);
    const escaped = escapeForSolidity(minified);
    const chunks = splitString(escaped, MAX_STRING_LENGTH);
    
    // コントラクト名にサフィックスを追加
    const contractName = `Tragedy${name}${suffix}`;
    
    let code = `// SPDX-License-Identifier: MIT
// Auto-generated from ${type}/${name}.svg
pragma solidity ^0.8.20;

/**
 * @title ${contractName}
 * @notice Individual SVG contract for ${name}
 */
contract ${contractName} {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
`;
    
    // チャンクを追加
    chunks.forEach((chunk, index) => {
        const isLast = index === chunks.length - 1;
        code += `            '${chunk}'${isLast ? '' : ','}
`;
    });
    
    code += `        ));
    }
}`;
    
    return code;
}

// メイン処理
async function generateAllContracts() {
    const typeConfig = {
        'monsters': { suffix: '', names: ['Werewolf', 'Goblin', 'Frankenstein', 'Demon', 'Dragon', 'Zombie', 'Vampire', 'Mummy', 'Succubus', 'Skeleton'] },
        'bg': { suffix: 'BG', names: ['Bloodmoon', 'Abyss', 'Decay', 'Corruption', 'Venom', 'Void', 'Inferno', 'Frost', 'Ragnarok', 'Shadow'] },
        'items': { suffix: 'Item', names: ['Crown', 'Sword', 'Shield', 'Poison', 'Torch', 'Wine', 'Scythe', 'Staff', 'Shoulder', 'Amulet'] },
        'effect': { suffix: 'Effect', names: ['Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'] }
    };
    
    // 出力ディレクトリを作成
    if (!fs.existsSync(OUTPUT_DIR)) {
        fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }
    
    let totalContracts = 0;
    
    for (const [type, config] of Object.entries(typeConfig)) {
        const dirPath = path.join(ASSETS_DIR, type);
        
        console.log(`\nProcessing ${type}...`);
        
        // 各タイプ用のサブディレクトリを作成
        const outputTypeDir = path.join(OUTPUT_DIR, type);
        if (!fs.existsSync(outputTypeDir)) {
            fs.mkdirSync(outputTypeDir, { recursive: true });
        }
        
        for (const name of config.names) {
            // ファイル名の最初の文字を小文字に変換してSVGファイルを探す
            const fileName = name.charAt(0).toLowerCase() + name.slice(1) + '.svg';
            const svgPath = path.join(dirPath, fileName);
            
            try {
                const svgContent = fs.readFileSync(svgPath, 'utf8');
                
                // コントラクトコードを生成
                const contractCode = generateContract(
                    name,
                    svgContent,
                    type,
                    config.suffix
                );
                
                // ファイルに書き出し
                const outputPath = path.join(outputTypeDir, `Tragedy${name}${config.suffix}.sol`);
                
                fs.writeFileSync(outputPath, contractCode);
                console.log(`  ✅ Generated: ${outputPath}`);
                totalContracts++;
            } catch (error) {
                console.error(`  ❌ Error processing ${fileName}: ${error.message}`);
            }
        }
    }
    
    console.log(`\n✨ All contracts generated successfully!`);
    console.log(`📊 Total contracts: ${totalContracts}`);
    
    // Bank interface contracts も生成
    console.log('\n📦 Generating Bank interface contracts...');
    generateBankInterfaces();
}

// Bank用のインターフェースコントラクトを生成
function generateBankInterfaces() {
    const bankTypes = [
        { name: 'Monster', count: 10 },
        { name: 'Background', count: 10 },
        { name: 'Item', count: 10 },
        { name: 'Effect', count: 12 }
    ];
    
    for (const bank of bankTypes) {
        const code = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// SVG contract interface
interface ISVGContract {
    function getSVG() external pure returns (string memory);
}

/**
 * @title TragedyModular${bank.name}Bank
 * @notice ${bank.name} bank that uses external calls to individual SVG contracts
 */
contract TragedyModular${bank.name}Bank {
    // Pre-deployed contract addresses
    address[${bank.count}] public svgContracts;
    
    constructor(address[${bank.count}] memory _contracts) {
        svgContracts = _contracts;
    }
    
    function get${bank.name === 'Monster' ? 'Species' : bank.name}SVG(uint8 id) external view returns (string memory) {
        require(id < ${bank.count}, "Invalid ID");
        address svgContract = svgContracts[id];
        require(svgContract != address(0), "Contract not set");
        
        // External call to SVG contract
        return ISVGContract(svgContract).getSVG();
    }
    
    function setContract(uint8 id, address contractAddress) external {
        require(id < ${bank.count}, "Invalid ID");
        svgContracts[id] = contractAddress;
    }
}`;
        
        const outputPath = path.join(OUTPUT_DIR, `TragedyModular${bank.name}Bank.sol`);
        fs.writeFileSync(outputPath, code);
        console.log(`  ✅ Generated: ${outputPath}`);
    }
}

// 実行
generateAllContracts().catch(console.error);