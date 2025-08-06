const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🧪 Full System Test\n");
    console.log("="  .repeat(50));
    
    // Load deployment data
    const deploymentPath = path.join(__dirname, '../scripts/deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    
    console.log("📋 Testing deployed contracts from:", deploymentPath);
    console.log("Network:", deployment.network);
    console.log("Deployer:", deployment.deployer);
    console.log("");
    
    const results = {
        monsters: [],
        backgrounds: [],
        items: [],
        effects: []
    };
    
    // Test Monster Bank
    console.log("🦾 Testing Monster Bank...");
    const monsterBank = await ethers.getContractAt(
        "contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank",
        deployment.contracts.banks.monsterBank
    );
    
    for (let i = 0; i < 10; i++) {
        try {
            const svg = await monsterBank.getSpeciesSVG(i);
            const name = Object.keys(deployment.contracts.monsters)[i];
            results.monsters.push({
                id: i,
                name: name,
                length: svg.length,
                preview: svg.substring(0, 30) + "..."
            });
            console.log(`  ✅ ${i}: ${name} - ${svg.length} chars`);
        } catch (error) {
            console.log(`  ❌ ${i}: Error - ${error.message}`);
        }
    }
    
    // Test Background Bank
    console.log("\n🌅 Testing Background Bank...");
    const bgBank = await ethers.getContractAt(
        "contracts/layer4/svgs/TragedyModularBackgroundBank.sol:TragedyModularBackgroundBank",
        deployment.contracts.banks.backgroundBank
    );
    
    for (let i = 0; i < 10; i++) {
        try {
            const svg = await bgBank.getBackgroundSVG(i);
            const name = Object.keys(deployment.contracts.backgrounds)[i];
            results.backgrounds.push({
                id: i,
                name: name,
                length: svg.length,
                preview: svg.substring(0, 30) + "..."
            });
            console.log(`  ✅ ${i}: ${name} - ${svg.length} chars`);
        } catch (error) {
            console.log(`  ❌ ${i}: Error - ${error.message}`);
        }
    }
    
    // Test Item Bank
    console.log("\n⚔️ Testing Item Bank...");
    const itemBank = await ethers.getContractAt(
        "contracts/layer4/svgs/TragedyModularItemBank.sol:TragedyModularItemBank",
        deployment.contracts.banks.itemBank
    );
    
    for (let i = 0; i < 10; i++) {
        try {
            const svg = await itemBank.getItemSVG(i);
            const name = Object.keys(deployment.contracts.items)[i];
            results.items.push({
                id: i,
                name: name,
                length: svg.length,
                preview: svg.substring(0, 30) + "..."
            });
            console.log(`  ✅ ${i}: ${name} - ${svg.length} chars`);
        } catch (error) {
            console.log(`  ❌ ${i}: Error - ${error.message}`);
        }
    }
    
    // Test Effect Bank
    console.log("\n✨ Testing Effect Bank...");
    const effectBank = await ethers.getContractAt(
        "contracts/layer4/svgs/TragedyModularEffectBank.sol:TragedyModularEffectBank",
        deployment.contracts.banks.effectBank
    );
    
    for (let i = 0; i < 12; i++) {
        try {
            const svg = await effectBank.getEffectSVG(i);
            const name = Object.keys(deployment.contracts.effects)[i] || `Extra${i-10}`;
            results.effects.push({
                id: i,
                name: name,
                length: svg.length,
                preview: svg.substring(0, 30) + "..."
            });
            console.log(`  ✅ ${i}: ${name} - ${svg.length} chars`);
        } catch (error) {
            console.log(`  ❌ ${i}: Error - ${error.message}`);
        }
    }
    
    // Summary
    console.log("\n" + "="  .repeat(50));
    console.log("📊 Test Summary:");
    console.log(`  - Monsters tested: ${results.monsters.length}/10`);
    console.log(`  - Backgrounds tested: ${results.backgrounds.length}/10`);
    console.log(`  - Items tested: ${results.items.length}/10`);
    console.log(`  - Effects tested: ${results.effects.length}/12`);
    
    const total = results.monsters.length + results.backgrounds.length + 
                  results.items.length + results.effects.length;
    console.log(`  - Total SVGs retrieved: ${total}/42`);
    
    if (total === 42) {
        console.log("\n✨ ALL TESTS PASSED! System is fully operational!");
    } else {
        console.log("\n⚠️ Some tests failed. Check errors above.");
    }
    
    // Save test results
    const resultsPath = path.join(__dirname, 'test-results.json');
    fs.writeFileSync(resultsPath, JSON.stringify(results, null, 2));
    console.log(`\n📄 Test results saved to: ${resultsPath}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("\n❌ Test failed:", error);
        process.exit(1);
    });