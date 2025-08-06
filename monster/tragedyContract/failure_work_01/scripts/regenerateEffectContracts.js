const fs = require('fs');
const path = require('path');

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
function escapeSpecialChars(str) {
    return str
        .replace(/\\/g, '\\\\')
        .replace(/'/g, "\\'") // シングルクォートもエスケープ
        .replace(/"/g, '\\"')
        .replace(/★/g, '\\u2605'); // ★をUnicodeエスケープ
}

// SVG文字列を複数の部分に分割する関数
function splitSVGString(svg, maxLength = 1000) {
    const escaped = escapeSpecialChars(svg);
    const parts = [];
    
    for (let i = 0; i < escaped.length; i += maxLength) {
        parts.push(escaped.slice(i, i + maxLength));
    }
    
    return parts;
}

// エフェクトコントラクトを生成
function generateEffectContracts() {
    const inputDir = path.join(__dirname, '../../assets/effect-fixed');
    const outputDir = path.join(__dirname, '../contracts/layer4/svgs/effects');
    
    // 出力ディレクトリを作成
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }
    
    const effectNames = [
        'Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash', 
        'Blackout', 'Matrix'
    ];
    
    console.log('🎨 Regenerating effect contracts with fixed coordinates...\n');
    
    effectNames.forEach((name, index) => {
        const fileName = name.toLowerCase() + '.svg';
        const filePath = path.join(inputDir, fileName);
        
        if (!fs.existsSync(filePath)) {
            console.error(`❌ File not found: ${fileName}`);
            return;
        }
        
        const svg = fs.readFileSync(filePath, 'utf8');
        const minified = minifySVG(svg);
        const parts = splitSVGString(minified);
        
        // コントラクトコードを生成
        let code = `// SPDX-License-Identifier: MIT
// Auto-generated from effects/${fileName}
pragma solidity ^0.8.20;

/**
 * @title Tragedy${name}
 * @notice Individual SVG contract for ${name}
 */
contract Tragedy${name} {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
`;
        
        // 各パートを追加
        parts.forEach((part, i) => {
            if (i > 0) code += ',\n';
            code += `            '${part}'`;
        });
        
        code += `
        ));
    }
}`;
        
        // ファイルに書き込み
        const outputPath = path.join(outputDir, `Tragedy${name}.sol`);
        fs.writeFileSync(outputPath, code);
        console.log(`✅ Generated: Tragedy${name}.sol`);
    });
    
    console.log('\n✨ All effect contracts regenerated!');
}

// 実行
generateEffectContracts();