const fs = require('fs');
const path = require('path');

// 設定
const MAX_STRING_LENGTH = 1000; // Solidityの文字列リテラル制限
const ASSETS_DIR = '../../assets';
const OUTPUT_DIR = '../contracts/layer4/generated';

// SVGをminifyする関数
function minifySVG(svg) {
    return svg
        .replace(/<!--.*?-->/gs, '') // コメント削除
        .replace(/\n/g, '') // 改行削除
        .replace(/\s+/g, ' ') // 連続する空白を1つに
        .replace(/>\s+</g, '><') // タグ間の空白削除
        .replace(/"\s+/g, '"') // 属性後の空白削除
        .replace(/\s+"/g, '"') // 属性前の空白削除
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

// ライブラリコードを生成する関数
function generateLibrary(name, svgContent, type) {
    const minified = minifySVG(svgContent);
    const escaped = escapeForSolidity(minified);
    const chunks = splitString(escaped, MAX_STRING_LENGTH);
    
    let code = `// SPDX-License-Identifier: MIT
// Auto-generated from ${type}/${name}.svg
pragma solidity ^0.8.20;

library Tragedy${name}Lib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
`;
    
    // チャンクを追加
    chunks.forEach((chunk, index) => {
        const isLast = index === chunks.length - 1;
        code += `            '${chunk}'${isLast ? '' : ','}\n`;
    });
    
    code += `        ));
    }
}`;
    
    return code;
}

// メイン処理
async function generateAllLibraries() {
    const types = ['monsters', 'bg', 'items', 'effect'];
    
    // 出力ディレクトリを作成
    if (!fs.existsSync(OUTPUT_DIR)) {
        fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }
    
    for (const type of types) {
        const dirPath = path.join(ASSETS_DIR, type);
        const files = fs.readdirSync(dirPath).filter(f => f.endsWith('.svg'));
        
        console.log(`\nProcessing ${type}...`);
        
        for (const file of files) {
            const name = file.replace('.svg', '');
            const svgPath = path.join(dirPath, file);
            const svgContent = fs.readFileSync(svgPath, 'utf8');
            
            // ライブラリコードを生成
            const libCode = generateLibrary(
                name.charAt(0).toUpperCase() + name.slice(1), // capitalize
                svgContent,
                type
            );
            
            // ファイルに書き出し
            const outputPath = path.join(OUTPUT_DIR, `${type}`, `Tragedy${name.charAt(0).toUpperCase() + name.slice(1)}Lib.sol`);
            const outputDirType = path.join(OUTPUT_DIR, type);
            
            if (!fs.existsSync(outputDirType)) {
                fs.mkdirSync(outputDirType, { recursive: true });
            }
            
            fs.writeFileSync(outputPath, libCode);
            console.log(`  ✅ Generated: ${outputPath}`);
        }
    }
    
    console.log('\n✨ All libraries generated successfully!');
}

// 実行
generateAllLibraries().catch(console.error);