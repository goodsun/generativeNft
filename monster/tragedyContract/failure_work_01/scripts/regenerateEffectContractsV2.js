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

// 文字列を16進数エンコードする関数（エスケープ問題を回避）
function toHexString(str) {
    let hex = '';
    for (let i = 0; i < str.length; i++) {
        hex += str.charCodeAt(i).toString(16).padStart(2, '0');
    }
    return hex;
}

// エフェクトコントラクトを生成（ライブラリ版）
function generateEffectContractsAsLibrary() {
    const inputDir = path.join(__dirname, '../../assets/effect-fixed');
    const outputDir = path.join(__dirname, '../contracts/layer4/generated/effect');
    
    // 既存のディレクトリを削除して再作成
    if (fs.existsSync(outputDir)) {
        fs.rmSync(outputDir, { recursive: true, force: true });
    }
    fs.mkdirSync(outputDir, { recursive: true });
    
    const effectNames = [
        'Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash', 
        'Blackout', 'Matrix'
    ];
    
    console.log('🎨 Regenerating effect contracts as libraries with fixed coordinates...\n');
    
    effectNames.forEach((name, index) => {
        const fileName = name.toLowerCase() + '.svg';
        const filePath = path.join(inputDir, fileName);
        
        if (!fs.existsSync(filePath)) {
            console.error(`❌ File not found: ${fileName}`);
            return;
        }
        
        const svg = fs.readFileSync(filePath, 'utf8');
        const minified = minifySVG(svg);
        
        // 直接文字列として書き込む（エスケープなし）
        const parts = [];
        const maxLength = 800;
        
        for (let i = 0; i < minified.length; i += maxLength) {
            const part = minified.slice(i, i + maxLength);
            // エスケープ処理
            const escaped = part
                .replace(/\\/g, '\\\\')
                .replace(/'/g, "\\'")
                .replace(/"/g, '\\"')
                .replace(/★/g, '\\u2605');
            parts.push(escaped);
        }
        
        // ライブラリコントラクトコードを生成
        let code = `// SPDX-License-Identifier: MIT
// Auto-generated from effect/${fileName}
pragma solidity ^0.8.20;

library Tragedy${name}Lib {
    function getSVG() internal pure returns (string memory) {
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
        const outputPath = path.join(outputDir, `Tragedy${name}Lib.sol`);
        fs.writeFileSync(outputPath, code);
        console.log(`✅ Generated: Tragedy${name}Lib.sol`);
    });
    
    console.log('\n✨ All effect libraries regenerated!');
}

// 実行
generateEffectContractsAsLibrary();