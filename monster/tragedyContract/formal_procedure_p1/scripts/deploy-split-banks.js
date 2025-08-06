const hre = require("hardhat");
const fs = require('fs');

async function main() {
    console.log("============================================================");
    console.log("Deploying Split Banks with Real SVGs");
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
    
    // Deploy Monster Banks
    console.log("\n👾 Deploying Monster Banks...");
    
    const MonsterBank1 = await hre.ethers.getContractFactory("ArweaveMonsterBank1");
    const monsterBank1 = await MonsterBank1.deploy();
    await monsterBank1.deployed();
    console.log(`  ✅ Monster Bank 1 (0-4) deployed to: ${monsterBank1.address}`);
    
    const MonsterBank2 = await hre.ethers.getContractFactory("ArweaveMonsterBank2");
    const monsterBank2 = await MonsterBank2.deploy();
    await monsterBank2.deployed();
    console.log(`  ✅ Monster Bank 2 (5-9) deployed to: ${monsterBank2.address}`);
    
    const MonsterBankMain = await hre.ethers.getContractFactory("ArweaveMonsterBankV3");
    const monsterBankMain = await MonsterBankMain.deploy(monsterBank1.address, monsterBank2.address);
    await monsterBankMain.deployed();
    console.log(`  ✅ Monster Bank Main deployed to: ${monsterBankMain.address}`);
    
    // Verify Monster Bank
    const werewolfSVG = await monsterBankMain.getMonsterSVG(0);
    const werewolfName = await monsterBankMain.getMonsterName(0);
    console.log(`  🔍 Werewolf: ${werewolfName} - SVG length: ${werewolfSVG.length} chars`);
    
    const succubusSVG = await monsterBankMain.getMonsterSVG(8);
    const succubusName = await monsterBankMain.getMonsterName(8);
    console.log(`  🔍 Succubus: ${succubusName} - SVG length: ${succubusSVG.length} chars`);
    
    // Deploy Item Banks
    console.log("\n⚔️ Deploying Item Banks...");
    
    const ItemBank1 = await hre.ethers.getContractFactory("ArweaveItemBank1");
    const itemBank1 = await ItemBank1.deploy();
    await itemBank1.deployed();
    console.log(`  ✅ Item Bank 1 (0-4) deployed to: ${itemBank1.address}`);
    
    const ItemBank2 = await hre.ethers.getContractFactory("ArweaveItemBank2");
    const itemBank2 = await ItemBank2.deploy();
    await itemBank2.deployed();
    console.log(`  ✅ Item Bank 2 (5-9) deployed to: ${itemBank2.address}`);
    
    const ItemBankMain = await hre.ethers.getContractFactory("ArweaveItemBankV3");
    const itemBankMain = await ItemBankMain.deploy(itemBank1.address, itemBank2.address);
    await itemBankMain.deployed();
    console.log(`  ✅ Item Bank Main deployed to: ${itemBankMain.address}`);
    
    // Verify Item Bank
    const crownSVG = await itemBankMain.getItemSVG(0);
    const crownName = await itemBankMain.getItemName(0);
    console.log(`  🔍 Crown: ${crownName} - SVG length: ${crownSVG.length} chars`);
    
    const amuletSVG = await itemBankMain.getItemSVG(9);
    const amuletName = await itemBankMain.getItemName(9);
    console.log(`  🔍 Amulet: ${amuletName} - SVG length: ${amuletSVG.length} chars`);
    
    // Deploy new Composer with updated banks
    console.log("\n🎨 Deploying Updated Composer...");
    const ArweaveTragedyComposerV4 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV2");
    
    const composer = await ArweaveTragedyComposerV4.deploy(
        monsterBankMain.address,
        itemBankMain.address,
        existingAddresses.backgroundBank,
        existingAddresses.effectBank
    );
    await composer.deployed();
    console.log(`  ✅ Composer V4 deployed to: ${composer.address}`);
    
    // Test composition
    console.log("\n🧪 Testing Updated Composition...");
    try {
        const svg = await composer.composeSVG(0, 0, 0, 0);
        console.log(`  📏 Generated SVG length: ${svg.length} characters`);
        console.log(`  ✅ Composition successful!`);
        
        // Save a sample
        const sampleFile = `sample-real-svg-split-${Date.now()}.svg`;
        fs.writeFileSync(sampleFile, svg);
        console.log(`  💾 Sample saved to: ${sampleFile}`);
    } catch (error) {
        console.error(`  ❌ Composition failed: ${error.message}`);
    }
    
    // Deploy new MetadataBank with updated composer
    console.log("\n📝 Deploying Updated MetadataBank...");
    const TragedyMetadataV3 = await hre.ethers.getContractFactory("TragedyMetadataV2");
    const metadataBank = await TragedyMetadataV3.deploy(composer.address);
    await metadataBank.deployed();
    console.log(`  ✅ MetadataBank V3 deployed to: ${metadataBank.address}`);
    
    // Verify metadata generation
    const metadataCount = await metadataBank.getMetadataCount();
    console.log(`  🔍 Metadata count: ${metadataCount.toString()}`);
    
    // Save deployment info
    const deployment = {
        network: hre.network.name,
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            base64: existingAddresses.base64,
            monsterBank1: monsterBank1.address,
            monsterBank2: monsterBank2.address,
            monsterBankMain: monsterBankMain.address,
            itemBank1: itemBank1.address,
            itemBank2: itemBank2.address,
            itemBankMain: itemBankMain.address,
            backgroundBank: existingAddresses.backgroundBank,
            effectBank: existingAddresses.effectBank,
            composerV4: composer.address,
            metadataBankV3: metadataBank.address
        },
        notes: "Split banks with real SVGs from assets folder"
    };
    
    const filename = `deployment-split-banks-${hre.network.name}-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(deployment, null, 2));
    console.log(`\n📄 Deployment log saved to: ${filename}`);
    
    console.log("\n============================================================");
    console.log("SPLIT BANKS DEPLOYMENT COMPLETE!");
    console.log("============================================================");
    
    console.log("\n📊 Contract Summary:");
    console.log(`  Monster Bank Main: ${monsterBankMain.address}`);
    console.log(`  Item Bank Main:    ${itemBankMain.address}`);
    console.log(`  Composer V4:       ${composer.address}`);
    console.log(`  MetadataBank V3:   ${metadataBank.address}`);
    
    console.log("\n🎨 Real SVGs are now on-chain!");
    console.log("✅ To update BankedNFT:");
    console.log(`  1. Call setMetadataBank(${metadataBank.address}) on the BankedNFT`);
    console.log("  2. The NFTs will now use the real artwork!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });