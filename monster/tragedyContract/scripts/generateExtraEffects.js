const fs = require('fs');
const path = require('path');

// Generate contracts for Blackout and Matrix effects
const extraEffects = [
    {
        name: 'Blackout',
        svg: '<svg xmlns="http://www.w3.org/2000/svg"width="240"height="240"><rect width="240"height="240"fill="black"><animate attributeName="opacity"values="0;1;1;0"dur="2s"repeatCount="indefinite"/></rect></svg>'
    },
    {
        name: 'Matrix',
        svg: '<svg xmlns="http://www.w3.org/2000/svg"width="240"height="240"><defs><pattern id="matrix"x="0"y="0"width="20"height="20"patternUnits="userSpaceOnUse"><text x="0"y="15"font-size="15"fill="#00ff00"opacity="0.8">0<animate attributeName="opacity"values="0;1;0"dur="1s"repeatCount="indefinite"/></text><text x="10"y="15"font-size="15"fill="#00ff00"opacity="0.8">1<animate attributeName="opacity"values="0;1;0"dur="1.5s"repeatCount="indefinite"/></text></pattern></defs><rect width="240"height="240"fill="black"/><rect width="240"height="240"fill="url(#matrix)"/></svg>'
    }
];

// 設定
const OUTPUT_DIR = '../contracts/layer4/svgs/effect';

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
    str = str.replace(/'/g, "\\'");
    return str.replace(/[^\x00-\x7F]/g, function(char) {
        return '\\u' + ('0000' + char.charCodeAt(0).toString(16)).slice(-4);
    });
}

// コントラクトコードを生成する関数
function generateContract(name, svgContent) {
    const minified = minifySVG(svgContent);
    const escaped = escapeForSolidity(minified);
    
    const contractName = `Tragedy${name}Effect`;
    
    let code = `// SPDX-License-Identifier: MIT
// Auto-generated extra effect
pragma solidity ^0.8.20;

/**
 * @title ${contractName}
 * @notice Individual SVG contract for ${name} effect
 */
contract ${contractName} {
    function getSVG() external pure returns (string memory) {
        return '${escaped}';
    }
}`;
    
    return code;
}

// メイン処理
async function generateExtraEffects() {
    // 出力ディレクトリを確認
    if (!fs.existsSync(OUTPUT_DIR)) {
        fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    }
    
    console.log('Generating extra effect contracts...\n');
    
    for (const effect of extraEffects) {
        // コントラクトコードを生成
        const contractCode = generateContract(effect.name, effect.svg);
        
        // ファイルに書き出し
        const outputPath = path.join(OUTPUT_DIR, `Tragedy${effect.name}Effect.sol`);
        
        fs.writeFileSync(outputPath, contractCode);
        console.log(`✅ Generated: ${outputPath}`);
    }
    
    console.log('\n✨ Extra effects generated successfully!');
}

// 実行
generateExtraEffects().catch(console.error);