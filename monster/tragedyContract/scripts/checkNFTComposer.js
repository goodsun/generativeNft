// Check current composer address in NFT contract

async function main() {
    const nftAddress = "0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0";
    
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = NFT.attach(nftAddress);
    
    console.log("Checking NFT contract at:", nftAddress);
    
    // Get current composer address
    const composerAddress = await nft.svgComposer();
    console.log("Current svgComposer address:", composerAddress);
    
    // Get metadata bank address
    const metadataBankAddress = await nft.metadataBank();
    console.log("Current metadataBank address:", metadataBankAddress);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });