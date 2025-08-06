const hre = require("hardhat");

async function main() {
    console.log("🚀 Deploying Fixed Composer and Metadata...\n");
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    // Existing V5 deployment addresses
    const CONTRACTS = {
        monsterBankV3: "0x41717f85854D631F7cb856D634fBf396beb68C93",
        backgroundBank: "0x1103d4c6108705610B08c2FFA696e3589579931E",
        itemBankV3: "0x2A76B76D2024bDf8018459cbf789A5B0bd277Fdc",
        effectBank: "0xA1D8e09E0F6559e992e2882555F60bE67F4e73a9",
        bankedNFT: "0xb0C8bCef9bBEd995b18E0fe6cB7029cB7c90E796"
    };
    
    try {
        // 1. Deploy Fixed Composer
        console.log("1. Deploying ArweaveTragedyComposerV5Fixed...");
        const ComposerFixed = await ethers.getContractFactory("ArweaveTragedyComposerV5Fixed");
        const composerFixed = await ComposerFixed.deploy(
            CONTRACTS.monsterBankV3,
            CONTRACTS.backgroundBank,
            CONTRACTS.itemBankV3,
            CONTRACTS.effectBank
        );
        await composerFixed.deployed();
        console.log("✅ ComposerV5Fixed deployed to:", composerFixed.address);
        
        // 2. Deploy Fixed Metadata
        console.log("\n2. Deploying TragedyMetadataV5Fixed...");
        const MetadataFixed = await ethers.getContractFactory("TragedyMetadataV5Fixed");
        const metadataFixed = await MetadataFixed.deploy(
            composerFixed.address, // Use the new fixed composer
            CONTRACTS.monsterBankV3,
            CONTRACTS.backgroundBank,
            CONTRACTS.itemBankV3,
            CONTRACTS.effectBank
        );
        await metadataFixed.deployed();
        console.log("✅ MetadataV5Fixed deployed to:", metadataFixed.address);
        
        // 3. Update BankedNFT
        console.log("\n3. Updating BankedNFT metadata bank...");
        const nft = await ethers.getContractAt("BankedNFT", CONTRACTS.bankedNFT);
        const tx = await nft.setMetadataBank(metadataFixed.address);
        await tx.wait();
        console.log("✅ BankedNFT updated to use new metadata bank");
        
        // 4. Test the setup
        console.log("\n🧪 Testing the complete setup...");
        
        // Test Composer
        console.log("\nTesting Composer...");
        try {
            const svg = await composerFixed.composeSVG(0, 0, 0, 0);
            console.log("✅ Composer works! SVG length:", svg.length);
        } catch (e) {
            console.log("❌ Composer error:", e.message);
        }
        
        // Test Metadata
        console.log("\nTesting Metadata...");
        try {
            const metadata = await metadataFixed.getMetadata(0);
            console.log("✅ Metadata works! Preview:", metadata.substring(0, 100) + "...");
            
            // Decode and show attributes
            const decoded = Buffer.from(metadata.split(',')[1], 'base64').toString();
            const json = JSON.parse(decoded);
            console.log("\nGenerated attributes:");
            json.attributes.forEach(attr => {
                console.log(`  - ${attr.trait_type}: ${attr.value}`);
            });
        } catch (e) {
            console.log("❌ Metadata error:", e.message);
        }
        
        // Test NFT tokenURI
        console.log("\nTesting NFT tokenURI...");
        try {
            const uri = await nft.tokenURI(1);
            console.log("✅ NFT tokenURI works!");
        } catch (e) {
            console.log("❌ NFT tokenURI error:", e.message);
        }
        
        console.log("\n🎉 Deployment complete!");
        console.log("=====================================");
        console.log("ComposerV5Fixed:", composerFixed.address);
        console.log("MetadataV5Fixed:", metadataFixed.address);
        console.log("=====================================");
        
    } catch (error) {
        console.error("❌ Deployment failed:", error);
        process.exit(1);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });