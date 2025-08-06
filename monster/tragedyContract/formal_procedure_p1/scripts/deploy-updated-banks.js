const hre = require("hardhat");
const fs = require('fs');

async function main() {
    console.log("============================================================");
    console.log("Deploying Updated Banks with Real SVGs");
    console.log("============================================================");
    
    const [deployer] = await hre.ethers.getSigners();
    const balance = await deployer.getBalance();
    
    console.log("\n📋 Deployment Info:");
    console.log(`  Network: ${hre.network.name}`);
    console.log(`  Deployer: ${deployer.address}`);
    console.log(`  Balance: ${hre.ethers.utils.formatEther(balance)} ETH`);
    
    // Load existing deployment
    let existingAddresses = {};
    try {
        const existingDeployment = JSON.parse(fs.readFileSync(`deployment-${hre.network.name}-1754448330516.json`, 'utf8'));
        existingAddresses = existingDeployment.contracts;
        console.log("\n📄 Existing deployment found");
    } catch (e) {
        console.error("❌ Could not find existing deployment file");
        process.exit(1);
    }
    
    console.log("\n⚠️  WARNING: Large contracts detected!");
    console.log("  MonsterBank and ItemBank contain full SVGs");
    console.log("  This may require optimization for mainnet deployment");
    
    // Deploy Base64 Library (reuse existing)
    console.log("\n🔧 Using existing Base64 Library...");
    console.log(`  ✅ Base64 at: ${existingAddresses.base64}`);
    
    // Deploy new Monster Bank
    console.log("\n👾 Deploying Updated Monster Bank...");
    const ArweaveMonsterBankV2 = await hre.ethers.getContractFactory("ArweaveMonsterBankV2");
    const monsterBank = await ArweaveMonsterBankV2.deploy();
    await monsterBank.deployed();
    console.log(`  ✅ Monster Bank V2 deployed to: ${monsterBank.address}`);
    
    // Verify Monster Bank
    const werewolfSVG = await monsterBank.getMonsterSVG(0);
    console.log(`  🔍 Werewolf SVG length: ${werewolfSVG.length} chars`);
    console.log(`  🔍 First 50 chars: ${werewolfSVG.substring(0, 50)}...`);
    
    // Deploy new Item Bank
    console.log("\n⚔️ Deploying Updated Item Bank...");
    const ArweaveItemBankV2 = await hre.ethers.getContractFactory("ArweaveItemBankV2");
    const itemBank = await ArweaveItemBankV2.deploy();
    await itemBank.deployed();
    console.log(`  ✅ Item Bank V2 deployed to: ${itemBank.address}`);
    
    // Verify Item Bank
    const crownSVG = await itemBank.getItemSVG(0);
    console.log(`  🔍 Crown SVG length: ${crownSVG.length} chars`);
    console.log(`  🔍 First 50 chars: ${crownSVG.substring(0, 50)}...`);
    
    console.log("\n🎨 Deploying Updated Composer...");
    console.log("  ⚠️  Note: We need to deploy a new composer to use the new banks");
    
    // Deploy new Composer with updated banks
    const ArweaveTragedyComposerV3 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV2", {
        libraries: {
            Base64: existingAddresses.base64
        }
    });
    
    const composer = await ArweaveTragedyComposerV3.deploy(
        monsterBank.address,
        itemBank.address,
        existingAddresses.backgroundBank,
        existingAddresses.effectBank
    );
    await composer.deployed();
    console.log(`  ✅ Composer V3 deployed to: ${composer.address}`);
    
    // Test composition
    console.log("\n🧪 Testing Updated Composition...");
    try {
        const svg = await composer.composeSVG(0, 0, 0, 0);
        console.log(`  📏 Generated SVG length: ${svg.length} characters`);
        console.log(`  ✅ Composition successful!`);
        
        // Save a sample
        const sampleFile = `sample-real-svg-${Date.now()}.svg`;
        fs.writeFileSync(sampleFile, svg);
        console.log(`  💾 Sample saved to: ${sampleFile}`);
    } catch (error) {
        console.error(`  ❌ Composition failed: ${error.message}`);
    }
    
    // Save deployment info
    const deployment = {
        network: hre.network.name,
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            base64: existingAddresses.base64,
            monsterBankV2: monsterBank.address,
            itemBankV2: itemBank.address,
            backgroundBank: existingAddresses.backgroundBank,
            effectBank: existingAddresses.effectBank,
            composerV3: composer.address
        },
        notes: "Updated with real SVGs from assets folder"
    };
    
    const filename = `deployment-updated-banks-${hre.network.name}-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(deployment, null, 2));
    console.log(`\n📄 Deployment log saved to: ${filename}`);
    
    console.log("\n============================================================");
    console.log("UPDATED BANKS DEPLOYMENT COMPLETE!");
    console.log("============================================================");
    
    console.log("\n📊 Contract Summary:");
    console.log(`  Monster Bank V2:  ${monsterBank.address}`);
    console.log(`  Item Bank V2:     ${itemBank.address}`);
    console.log(`  Composer V3:      ${composer.address}`);
    
    console.log("\n🎨 Real SVGs are now on-chain!");
    console.log("⚠️  Note: To use these with existing NFTs, you'll need to:");
    console.log("  1. Deploy a new MetadataBank using the new composer");
    console.log("  2. Update the BankedNFT to use the new MetadataBank");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });