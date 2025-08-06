const { ethers } = require("hardhat");

async function main() {
    console.log("Checking MetadataBank status...\n");
    
    const NFT_ADDRESS = "0xb0C8bCef9bBEd995b18E0fe6cB7029cB7c90E796";
    const METADATA_BANK_ADDRESS = "0xbFD4e357e0552Dd26b1A4877a5DB8DDC2E4198C4";
    
    // Get contracts
    const nft = await ethers.getContractAt("BankedNFT", NFT_ADDRESS);
    const metadataBank = await ethers.getContractAt("IMetadataBank", METADATA_BANK_ADDRESS);
    
    // Check NFT's metadataBank setting
    const nftMetadataBank = await nft.metadataBank();
    console.log("NFT's MetadataBank address:", nftMetadataBank);
    console.log("Expected MetadataBank address:", METADATA_BANK_ADDRESS);
    console.log("MetadataBank correctly set:", nftMetadataBank.toLowerCase() === METADATA_BANK_ADDRESS.toLowerCase());
    
    // Check metadata count
    const metadataCount = await metadataBank.getMetadataCount();
    console.log("\nMetadata count in bank:", metadataCount.toString());
    
    // Try to get metadata for index 0 if available
    if (metadataCount > 0) {
        try {
            const metadata = await metadataBank.getMetadata(0);
            console.log("\nFirst metadata URI:", metadata);
        } catch (error) {
            console.log("\nError getting metadata:", error.message);
        }
    }
    
    // Try to call tokenURI for token 1
    console.log("\nTrying to get tokenURI for token 1...");
    try {
        const uri = await nft.tokenURI(1);
        console.log("Token URI:", uri);
    } catch (error) {
        console.log("Error:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });