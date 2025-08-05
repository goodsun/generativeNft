const fs = require('fs');
const path = require('path');
const { ethers } = require('hardhat');

// SVGプレビュー用HTMLを生成
function generatePreviewHTML(svgData) {
    return `<!DOCTYPE html>
<html>
<head>
    <title>Tragedy SVG Library Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1a1a1a;
            color: #fff;
            padding: 20px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .item {
            background: #2a2a2a;
            border: 1px solid #444;
            border-radius: 8px;
            padding: 10px;
            text-align: center;
        }
        .item h3 {
            margin: 0 0 10px 0;
            font-size: 14px;
        }
        .svg-container {
            background: #fff;
            border-radius: 4px;
            padding: 10px;
            height: 240px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        svg {
            max-width: 100%;
            max-height: 100%;
        }
        .error {
            color: #ff6b6b;
            padding: 20px;
        }
    </style>
</head>
<body>
    <h1>Tragedy SVG Library Test</h1>
    <div class="grid">
${svgData.map(item => `
        <div class="item">
            <h3>${item.name}</h3>
            <div class="svg-container">
                ${item.error ? `<div class="error">${item.error}</div>` : 
                 `<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">${item.svg}</svg>`}
            </div>
        </div>
`).join('')}
    </div>
</body>
</html>`;
}

// コントラクトからSVGを取得してテスト
async function testLibraries() {
    console.log('🚀 Starting SVG Library Tests...\n');
    
    const results = {
        monsters: [],
        backgrounds: [],
        items: [],
        effects: []
    };
    
    try {
        // 各Bankコントラクトをデプロイしてテスト
        const banks = [
            { name: 'TragedyDetailedMonsterBank', type: 'monsters', method: 'getSpeciesSVG', count: 10 },
            { name: 'TragedyDetailedBackgroundBank', type: 'backgrounds', method: 'getBackgroundSVG', count: 10 },
            { name: 'TragedyDetailedItemBank', type: 'items', method: 'getEquipmentSVG', count: 10 },
            { name: 'TragedyDetailedEffectBank', type: 'effects', method: 'getEffectSVG', count: 10 }
        ];
        
        for (const bank of banks) {
            console.log(`Testing ${bank.name}...`);
            
            // コントラクトをデプロイ
            const Contract = await ethers.getContractFactory(bank.name);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            // 各IDのSVGを取得
            for (let i = 0; i < bank.count; i++) {
                try {
                    const svg = await contract[bank.method](i);
                    results[bank.type].push({
                        name: `${bank.type}-${i}`,
                        svg: svg,
                        error: null
                    });
                    console.log(`  ✅ ID ${i}: Success`);
                } catch (error) {
                    results[bank.type].push({
                        name: `${bank.type}-${i}`,
                        svg: null,
                        error: error.message
                    });
                    console.log(`  ❌ ID ${i}: ${error.message}`);
                }
            }
        }
        
    } catch (error) {
        console.error('Error during testing:', error);
    }
    
    // 結果をHTMLファイルに出力
    const allResults = [
        ...results.monsters,
        ...results.backgrounds,
        ...results.items,
        ...results.effects
    ];
    
    const html = generatePreviewHTML(allResults);
    const outputPath = path.join(__dirname, 'svg-test-results.html');
    fs.writeFileSync(outputPath, html);
    
    console.log(`\n✨ Test complete! Open ${outputPath} in your browser to see the results.`);
}

// Hardhatタスクとして実行
async function main() {
    await testLibraries();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });