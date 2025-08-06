const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🧪 Testing Deployed SVG on Bon-Soleil Network\n");
    
    // Load deployment data
    const deploymentPath = path.join(__dirname, '../scripts/deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    
    try {
        // Get Monster Bank
        const monsterBank = await ethers.getContractAt(
            "contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank",
            deployment.contracts.banks.monsterBank
        );
        
        console.log("📍 Monster Bank Address:", deployment.contracts.banks.monsterBank);
        console.log("\n🐺 Getting Werewolf SVG (id: 0)...");
        
        // Get Werewolf SVG
        const svg = await monsterBank.getSpeciesSVG(0);
        
        console.log("\n📊 SVG Stats:");
        console.log("- Length:", svg.length, "characters");
        console.log("- Starts with:", svg.substring(0, 50) + "...");
        console.log("- Ends with:", "..." + svg.substring(svg.length - 50));
        
        // Check for the xmlns issue
        const xmlnsIndex = svg.indexOf('xmlns');
        if (xmlnsIndex > 0) {
            console.log("\n🔍 Checking xmlns attribute:");
            console.log("- Position:", xmlnsIndex);
            console.log("- Context:", svg.substring(xmlnsIndex - 10, xmlnsIndex + 40));
            
            // Check if there's a space before xmlns
            const charBefore = svg.charAt(xmlnsIndex - 1);
            console.log("- Character before xmlns:", charBefore === ' ' ? 'SPACE' : `'${charBefore}'`);
        }
        
        // Save to file for inspection
        const outputPath = path.join(__dirname, 'werewolf-test.svg');
        fs.writeFileSync(outputPath, svg);
        console.log("\n💾 SVG saved to:", outputPath);
        
        // Test other SVGs
        console.log("\n🧪 Testing other SVGs...");
        const tests = [
            { bank: 'backgroundBank', method: 'getBackgroundSVG', id: 0, name: 'Bloodmoon' },
            { bank: 'itemBank', method: 'getItemSVG', id: 0, name: 'Crown' },
            { bank: 'effectBank', method: 'getEffectSVG', id: 0, name: 'Seizure' }
        ];
        
        for (const test of tests) {
            const bankAddress = deployment.contracts.banks[test.bank];
            const bank = await ethers.getContractAt(
                `contracts/layer4/svgs/TragedyModular${test.bank.replace('Bank', '')}Bank.sol:TragedyModular${test.bank.charAt(0).toUpperCase() + test.bank.slice(1).replace('Bank', '')}Bank`,
                bankAddress
            );
            
            const svg = await bank[test.method](test.id);
            console.log(`- ${test.name}: ${svg.length} chars`);
            
            // Check xmlns
            const xmlnsIdx = svg.indexOf('xmlns');
            if (xmlnsIdx > 0) {
                const before = svg.charAt(xmlnsIdx - 1);
                if (before !== ' ') {
                    console.log(`  ⚠️ Missing space before xmlns in ${test.name}!`);
                }
            }
        }
        
        console.log("\n✅ Test complete!");
        
    } catch (error) {
        console.error("\n❌ Error:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });