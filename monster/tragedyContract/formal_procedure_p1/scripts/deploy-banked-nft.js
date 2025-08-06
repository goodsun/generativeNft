const hre = require("hardhat");
const fs = require('fs');

async function main() {
    console.log("============================================================");
    console.log("Deploying BankedNFT System");
    console.log("============================================================");
    
    const [deployer] = await hre.ethers.getSigners();
    const balance = await deployer.getBalance();
    
    console.log("\n📋 Deployment Info:");
    console.log(`  Network: ${hre.network.name}`);
    console.log(`  Deployer: ${deployer.address}`);
    console.log(`  Balance: ${hre.ethers.utils.formatEther(balance)} ETH`);
    
    // Load existing deployment for composer address
    let composerAddress;
    try {
        const existingDeployment = JSON.parse(fs.readFileSync(`deployment-${hre.network.name}-1754448348930.json`, 'utf8'));
        composerAddress = existingDeployment.contracts.composer;
        console.log(`  Using existing Composer: ${composerAddress}`);
    } catch (e) {
        console.error("❌ Could not find existing deployment file");
        console.log("  Please run 01-deploy-all.js first to deploy the composer");
        process.exit(1);
    }
    
    // Deploy TragedyMetadataV2 as the MetadataBank
    console.log("\n📝 Step 1/2: Deploying TragedyMetadataV2 (MetadataBank)...");
    const TragedyMetadataV2 = await hre.ethers.getContractFactory("TragedyMetadataV2");
    const metadataBank = await TragedyMetadataV2.deploy(composerAddress);
    await metadataBank.deployed();
    console.log(`  ✅ MetadataBank deployed to: ${metadataBank.address}`);
    
    // Verify it works
    const metadataCount = await metadataBank.getMetadataCount();
    console.log(`  🔍 Metadata count: ${metadataCount.toString()}`);
    
    // Deploy TragedyBankedNFT
    console.log("\n🎨 Step 2/2: Deploying TragedyBankedNFT...");
    const TragedyBankedNFT = await hre.ethers.getContractFactory("TragedyBankedNFT");
    const bankedNft = await TragedyBankedNFT.deploy(metadataBank.address);
    await bankedNft.deployed();
    console.log(`  ✅ BankedNFT deployed to: ${bankedNft.address}`);
    
    // Verify configuration
    const [name, symbol, maxSupply, mintFee, totalMinted] = await Promise.all([
        bankedNft.name(),
        bankedNft.symbol(),
        bankedNft.maxSupply(),
        bankedNft.mintFee(),
        bankedNft.totalMinted()
    ]);
    
    console.log("\n🔍 BankedNFT Configuration:");
    console.log(`  Name: ${name}`);
    console.log(`  Symbol: ${symbol}`);
    console.log(`  Max Supply: ${maxSupply}`);
    console.log(`  Mint Fee: ${hre.ethers.utils.formatEther(mintFee)} ETH`);
    console.log(`  Total Minted: ${totalMinted}`);
    
    // Test minting
    console.log("\n🧪 Testing Mint Function...");
    try {
        const mintTx = await bankedNft.mint({ value: mintFee });
        console.log(`  📡 Transaction: ${mintTx.hash}`);
        const receipt = await mintTx.wait();
        console.log(`  ✅ Test mint successful! Gas used: ${receipt.gasUsed.toString()}`);
        
        // Get the minted token's metadata
        const tokenURI = await bankedNft.tokenURI(1);
        console.log(`  📏 Metadata length: ${tokenURI.length} characters`);
        
        // Decode and display metadata
        if (tokenURI.startsWith('data:application/json;base64,')) {
            const base64Json = tokenURI.replace('data:application/json;base64,', '');
            const jsonString = Buffer.from(base64Json, 'base64').toString();
            const metadata = JSON.parse(jsonString);
            console.log(`  🏷️ Token Name: ${metadata.name}`);
            console.log(`  📝 Description: ${metadata.description}`);
            console.log(`  🎯 Attributes: ${metadata.attributes.length} traits`);
        }
    } catch (error) {
        console.error(`  ❌ Test mint failed: ${error.message}`);
    }
    
    // Save deployment info
    const deployment = {
        network: hre.network.name,
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        contracts: {
            composer: composerAddress,
            metadataBank: metadataBank.address,
            tragedyBankedNft: bankedNft.address
        }
    };
    
    const filename = `deployment-banked-${hre.network.name}-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(deployment, null, 2));
    console.log(`\n📄 Deployment log saved to: ${filename}`);
    
    console.log("\n============================================================");
    console.log("BANKED NFT DEPLOYMENT COMPLETE!");
    console.log("============================================================");
    
    console.log("\n📊 Contract Summary:");
    console.log(`  Composer:         ${composerAddress}`);
    console.log(`  MetadataBank:     ${metadataBank.address}`);
    console.log(`  TragedyBankedNFT: ${bankedNft.address}`);
    
    console.log("\n✅ BankedNFT system is ready!");
    console.log("📝 Open viewer/banked-viewer.html to interact with the contracts");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });