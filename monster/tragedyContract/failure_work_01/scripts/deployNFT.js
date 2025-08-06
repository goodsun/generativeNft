const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🎨 Deploying Tragedy NFT Contract...\n");
    
    // Load deployment data
    const deploymentPath = path.join(__dirname, 'deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    // Get required addresses
    const metadataBankAddress = deployment.contracts.metadataBank;
    const composerAddress = deployment.contracts.composerV4; // Using V4
    
    console.log("\n📍 Using addresses:");
    console.log("  Metadata Bank:", metadataBankAddress);
    console.log("  SVG Composer:", composerAddress);
    
    // Deploy NFT contract
    console.log("\n🚀 Deploying TragedyNFT...");
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = await NFT.deploy(metadataBankAddress, composerAddress);
    await nft.deployed();
    
    console.log("✅ NFT contract deployed to:", nft.address);
    
    // Update deployment data
    deployment.contracts.nft = nft.address;
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // Test minting
    console.log("\n🧪 Testing mint function...");
    try {
        const mintPrice = await nft.mintPrice();
        console.log("Mint price:", ethers.utils.formatEther(mintPrice), "ETH");
        
        // Mint a test NFT
        console.log("Minting: Werewolf + Bloodmoon + Crown + Meteor");
        const tx = await nft.mint(0, 0, 0, 3, { value: mintPrice });
        await tx.wait();
        console.log("✅ Minted token #1");
        
        // Get tokenURI
        const tokenURI = await nft.tokenURI(1);
        console.log("✅ Token URI generated (", tokenURI.length, "chars)");
        
        // Decode and save metadata
        const base64Data = tokenURI.split(',')[1];
        const jsonData = Buffer.from(base64Data, 'base64').toString();
        const metadata = JSON.parse(jsonData);
        
        console.log("\n📋 Token Metadata:");
        console.log("  Name:", metadata.name);
        console.log("  Description:", metadata.description);
        console.log("  Attributes:");
        metadata.attributes.forEach(attr => {
            console.log(`    - ${attr.trait_type}: ${attr.value}`);
        });
        
        // Save test metadata
        fs.writeFileSync('test-nft-metadata.json', JSON.stringify(metadata, null, 2));
        console.log("\n💾 Metadata saved to: test-nft-metadata.json");
        
    } catch (error) {
        console.error("❌ Test failed:", error.message);
    }
    
    console.log("\n✨ NFT deployment complete!");
    console.log("\n🎯 Contract addresses:");
    console.log("  NFT:", nft.address);
    console.log("  Composer V4:", composerAddress);
    console.log("  Metadata Bank:", metadataBankAddress);
    
    return nft.address;
}

main()
    .then((address) => {
        console.log("\n🏁 Final NFT address:", address);
        process.exit(0);
    })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });