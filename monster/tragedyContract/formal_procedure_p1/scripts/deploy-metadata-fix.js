const hre = require("hardhat");

async function main() {
    console.log("🚀 Deploying Fixed Metadata Contract...\n");
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    // V5 deployment addresses
    const CONTRACTS = {
        composerV5: "0x4036C601b705d68cA91281fdD1D665236ABbFde7",
        monsterBankV3: "0x41717f85854D631F7cb856D634fBf396beb68C93",
        backgroundBank: "0x1103d4c6108705610B08c2FFA696e3589579931E",
        itemBankV3: "0x2A76B76D2024bDf8018459cbf789A5B0bd277Fdc",
        effectBank: "0xA1D8e09E0F6559e992e2882555F60bE67F4e73a9",
        bankedNFT: "0xb0C8bCef9bBEd995b18E0fe6cB7029cB7c90E796"
    };
    
    try {
        // Deploy TragedyMetadataV5Fixed
        console.log("Deploying TragedyMetadataV5Fixed...");
        const MetadataFixed = await ethers.getContractFactory("TragedyMetadataV5Fixed");
        const metadataFixed = await MetadataFixed.deploy(
            CONTRACTS.composerV5,
            CONTRACTS.monsterBankV3,
            CONTRACTS.backgroundBank,
            CONTRACTS.itemBankV3,
            CONTRACTS.effectBank
        );
        await metadataFixed.deployed();
        console.log("✅ TragedyMetadataV5Fixed deployed to:", metadataFixed.address);
        
        // Update BankedNFT to use new metadata
        console.log("\nUpdating BankedNFT metadata bank...");
        const nft = await ethers.getContractAt("BankedNFT", CONTRACTS.bankedNFT);
        const tx = await nft.setMetadataBank(metadataFixed.address);
        await tx.wait();
        console.log("✅ BankedNFT updated to use new metadata bank");
        
        // Test the new setup
        console.log("\n🧪 Testing metadata generation...");
        const metadataCount = await metadataFixed.getMetadataCount();
        console.log("Metadata count:", metadataCount.toString());
        
        try {
            const metadata = await metadataFixed.getMetadata(0);
            console.log("✅ Metadata for token 1 generated successfully");
            console.log("Preview:", metadata.substring(0, 100) + "...");
            
            // Decode and show attributes
            const decoded = Buffer.from(metadata.split(',')[1], 'base64').toString();
            const json = JSON.parse(decoded);
            console.log("\nAttributes:");
            json.attributes.forEach(attr => {
                console.log(`  - ${attr.trait_type}: ${attr.value}`);
            });
        } catch (error) {
            console.log("❌ Error generating metadata:", error.message);
        }
        
        console.log("\n🎉 Deployment complete!");
        console.log("New metadata contract:", metadataFixed.address);
        
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