const hre = require("hardhat");
const fs = require('fs');

async function main() {
    console.log("============================================================");
    console.log("Deploying Final Updated System with Real SVGs");
    console.log("============================================================");
    
    const [deployer] = await hre.ethers.getSigners();
    const balance = await deployer.getBalance();
    
    console.log("\n📋 Deployment Info:");
    console.log(`  Network: ${hre.network.name}`);
    console.log(`  Deployer: ${deployer.address}`);
    console.log(`  Balance: ${hre.ethers.utils.formatEther(balance)} ETH`);
    
    // Load existing deployments
    let splitBanks = {};
    let existingAddresses = {};
    try {
        const splitDeployment = JSON.parse(fs.readFileSync(`deployment-split-banks-${hre.network.name}-1754451340042.json`, 'utf8'));
        splitBanks = splitDeployment.contracts;
        console.log("\n📄 Split banks deployment found");
        
        const existingDeployment = JSON.parse(fs.readFileSync(`deployment-${hre.network.name}-1754448330516.json`, 'utf8'));
        existingAddresses = existingDeployment.contracts;
    } catch (e) {
        console.error("❌ Could not find deployment files");
        process.exit(1);
    }
    
    // Deploy new Composer V3 with updated method names
    console.log("\n🎨 Deploying Updated Composer V3...");
    const ArweaveTragedyComposerV3 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV3");
    
    const composer = await ArweaveTragedyComposerV3.deploy(
        splitBanks.monsterBankMain,
        splitBanks.itemBankMain,
        splitBanks.backgroundBank,
        splitBanks.effectBank
    );
    await composer.deployed();
    console.log(`  ✅ Composer V3 deployed to: ${composer.address}`);
    
    // Test composition
    console.log("\n🧪 Testing Final Composition...");
    try {
        const svg = await composer.composeSVG(0, 0, 0, 0);
        console.log(`  📏 Generated SVG length: ${svg.length} characters`);
        console.log(`  ✅ Composition successful!`);
        
        // Save a sample
        const sampleFile = `sample-final-real-svg-${Date.now()}.svg`;
        fs.writeFileSync(sampleFile, svg);
        console.log(`  💾 Sample saved to: ${sampleFile}`);
    } catch (error) {
        console.error(`  ❌ Composition failed: ${error.message}`);
    }
    
    // Deploy final MetadataBank
    console.log("\n📝 Deploying Final MetadataBank...");
    const TragedyMetadataV3 = await hre.ethers.getContractFactory("TragedyMetadataV2");
    const metadataBank = await TragedyMetadataV3.deploy(composer.address);
    await metadataBank.deployed();
    console.log(`  ✅ MetadataBank Final deployed to: ${metadataBank.address}`);
    
    // Verify metadata generation
    const metadataCount = await metadataBank.getMetadataCount();
    console.log(`  🔍 Metadata count: ${metadataCount.toString()}`);
    
    // Get a sample metadata
    const sampleMetadata = await metadataBank.getMetadata(0);
    console.log(`  📏 Sample metadata length: ${sampleMetadata.length} characters`);
    
    // Save deployment info
    const deployment = {
        network: hre.network.name,
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            // Infrastructure
            base64: existingAddresses.base64,
            
            // Split banks
            monsterBank1: splitBanks.monsterBank1,
            monsterBank2: splitBanks.monsterBank2,
            monsterBankMain: splitBanks.monsterBankMain,
            itemBank1: splitBanks.itemBank1,
            itemBank2: splitBanks.itemBank2,
            itemBankMain: splitBanks.itemBankMain,
            
            // Arweave banks
            backgroundBank: splitBanks.backgroundBank,
            effectBank: splitBanks.effectBank,
            
            // Final contracts
            composerV3: composer.address,
            metadataBankFinal: metadataBank.address,
            
            // BankedNFT
            tragedyBankedNft: "0x930Fc003DD8989E8d64b9Bba7673180C369178C5"
        },
        notes: "Final deployment with real SVGs from assets folder"
    };
    
    const filename = `deployment-final-${hre.network.name}-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(deployment, null, 2));
    console.log(`\n📄 Deployment log saved to: ${filename}`);
    
    console.log("\n============================================================");
    console.log("FINAL DEPLOYMENT COMPLETE!");
    console.log("============================================================");
    
    console.log("\n📊 Final Contract Summary:");
    console.log(`  Composer V3:      ${composer.address}`);
    console.log(`  MetadataBank:     ${metadataBank.address}`);
    console.log(`  BankedNFT:        0x930Fc003DD8989E8d64b9Bba7673180C369178C5`);
    
    console.log("\n🎨 Real SVGs are now fully integrated!");
    console.log("\n✅ To activate the real artwork:");
    console.log(`  1. Connect to BankedNFT at: 0x930Fc003DD8989E8d64b9Bba7673180C369178C5`);
    console.log(`  2. Call setMetadataBank("${metadataBank.address}")`);
    console.log(`  3. All NFTs will now display the real artwork!`);
    
    console.log("\n🌐 View your NFTs at:");
    console.log("  https://yourserver.com/viewer/");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });