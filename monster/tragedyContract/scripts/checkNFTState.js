const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Checking NFT contract state...\n");
    
    const nftAddress = "0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0";
    const nft = await ethers.getContractAt("TragedyNFTV2", nftAddress);
    
    // Check contract addresses
    const metadataBank = await nft.metadataBank();
    const svgComposer = await nft.svgComposer();
    
    console.log("📍 Contract addresses:");
    console.log("  Metadata Bank:", metadataBank);
    console.log("  SVG Composer:", svgComposer);
    
    // Check if they are zero addresses
    if (metadataBank === "0x0000000000000000000000000000000000000000") {
        console.log("❌ Metadata Bank is zero address!");
    }
    
    // Get expected addresses
    const deployment = require('./deployment-result.json');
    console.log("\n📋 Expected addresses:");
    console.log("  Metadata Bank:", deployment.contracts.metadataBank);
    console.log("  SVG Composer:", deployment.contracts.composerV4);
    
    // Check token #1
    try {
        const attrs = await nft.tokenAttributes(1);
        console.log("\n🎯 Token #1 attributes:");
        console.log("  Species:", attrs.species);
        console.log("  Background:", attrs.background);
        console.log("  Item:", attrs.item);
        console.log("  Effect:", attrs.effect);
    } catch (error) {
        console.log("\n❌ Error getting token attributes:", error.message);
    }
}

main().catch(console.error);