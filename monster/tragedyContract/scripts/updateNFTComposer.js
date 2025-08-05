// Update NFT contract to use new Composer V6

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Updating NFT with account:", deployer.address);
    
    const nftAddress = "0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0";
    const metadataBankAddress = "0x86bc479C30b9E2b8B572d995eDbeCeed147D67e2"; // Keep the same
    const newComposerAddress = "0x88b7F93E1DBDF31E190FD6442135A81944366312"; // Composer V6
    
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = NFT.attach(nftAddress);
    
    console.log("Current composer:", await nft.svgComposer());
    
    // Update contracts
    console.log("Updating to new Composer V6...");
    const tx = await nft.updateContracts(metadataBankAddress, newComposerAddress);
    await tx.wait();
    
    console.log("Updated!");
    console.log("New composer:", await nft.svgComposer());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });