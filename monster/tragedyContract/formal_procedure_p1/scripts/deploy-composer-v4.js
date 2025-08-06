const hre = require("hardhat");
const fs = require('fs');

async function main() {
    console.log("============================================================");
    console.log("Deploying Composer V4 with Monster-Only Filters");
    console.log("============================================================");
    
    const [deployer] = await hre.ethers.getSigners();
    const balance = await deployer.getBalance();
    
    console.log("\n📋 Deployment Info:");
    console.log(`  Network: ${hre.network.name}`);
    console.log(`  Deployer: ${deployer.address}`);
    console.log(`  Balance: ${hre.ethers.utils.formatEther(balance)} ETH`);
    
    // Load existing deployments
    let splitBanks = {};
    try {
        const splitDeployment = JSON.parse(fs.readFileSync(`deployment-split-banks-${hre.network.name}-1754451340042.json`, 'utf8'));
        splitBanks = splitDeployment.contracts;
        console.log("\n📄 Split banks deployment found");
    } catch (e) {
        console.error("❌ Could not find deployment files");
        process.exit(1);
    }
    
    // Deploy new Composer V4 with updated filter application
    console.log("\n🎨 Deploying Updated Composer V4 (Monster-Only Filters)...");
    const ArweaveTragedyComposerV4 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV4");
    
    const composer = await ArweaveTragedyComposerV4.deploy(
        splitBanks.monsterBankMain,
        splitBanks.itemBankMain,
        splitBanks.backgroundBank,
        splitBanks.effectBank
    );
    await composer.deployed();
    console.log(`  ✅ Composer V4 deployed to: ${composer.address}`);
    
    // Test composition
    console.log("\n🧪 Testing Composition with Monster-Only Filter...");
    try {
        const svg = await composer.composeSVG(0, 0, 0, 0);
        console.log(`  📏 Generated SVG length: ${svg.length} characters`);
        console.log(`  ✅ Composition successful!`);
        
        // Save a sample
        const sampleFile = `sample-v4-monster-filter-${Date.now()}.svg`;
        fs.writeFileSync(sampleFile, svg);
        console.log(`  💾 Sample saved to: ${sampleFile}`);
    } catch (error) {
        console.error(`  ❌ Composition failed: ${error.message}`);
    }
    
    // Deploy new MetadataBank with V4 composer
    console.log("\n📝 Deploying MetadataBank with V4 Composer...");
    const TragedyMetadataV2 = await hre.ethers.getContractFactory("TragedyMetadataV2");
    const metadataBank = await TragedyMetadataV2.deploy(composer.address);
    await metadataBank.deployed();
    console.log(`  ✅ MetadataBank V4 deployed to: ${metadataBank.address}`);
    
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
            composerV4: composer.address,
            metadataBankV4: metadataBank.address,
            
            // Reference to banks
            monsterBankMain: splitBanks.monsterBankMain,
            itemBankMain: splitBanks.itemBankMain,
            backgroundBank: splitBanks.backgroundBank,
            effectBank: splitBanks.effectBank,
            
            // BankedNFT (unchanged)
            tragedyBankedNft: "0x930Fc003DD8989E8d64b9Bba7673180C369178C5"
        },
        notes: "Composer V4 - Color filters applied to monsters only, items retain original colors"
    };
    
    const filename = `deployment-v4-${hre.network.name}-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(deployment, null, 2));
    console.log(`\n📄 Deployment log saved to: ${filename}`);
    
    console.log("\n============================================================");
    console.log("COMPOSER V4 DEPLOYMENT COMPLETE!");
    console.log("============================================================");
    
    console.log("\n📊 Contract Summary:");
    console.log(`  Composer V4:      ${composer.address}`);
    console.log(`  MetadataBank V4:  ${metadataBank.address}`);
    console.log(`  BankedNFT:        0x930Fc003DD8989E8d64b9Bba7673180C369178C5`);
    
    console.log("\n🎨 Key Change: Color filters now apply to monsters only!");
    console.log("   Items will retain their original colors");
    
    console.log("\n✅ To activate the new composer:");
    console.log(`  1. Connect to BankedNFT at: 0x930Fc003DD8989E8d64b9Bba7673180C369178C5`);
    console.log(`  2. Call setMetadataBank("${metadataBank.address}")`);
    console.log(`  3. All NFTs will now show items with original colors!`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });