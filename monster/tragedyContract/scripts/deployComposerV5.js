// Deploy new Composer V5 with proper defs handling

const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying Composer V5 with account:", deployer.address);
    
    // Get existing bank addresses from deployment data
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    
    const monsterBankAddress = deploymentData.contracts.banks.monsterBank;
    const backgroundBankAddress = deploymentData.contracts.banks.backgroundBankPixel; // Use pixel version
    const itemBankAddress = deploymentData.contracts.banks.itemBankV2 || deploymentData.contracts.banks.itemBank;
    const effectBankAddress = deploymentData.contracts.banks.effectBankV2 || deploymentData.contracts.banks.effectBank;
    
    console.log("\nUsing banks:");
    console.log("Monster Bank:", monsterBankAddress);
    console.log("Background Bank (Pixel):", backgroundBankAddress);
    console.log("Item Bank:", itemBankAddress);
    console.log("Effect Bank:", effectBankAddress);
    
    // Deploy Composer V5
    console.log("\n1. Deploying Composer V5...");
    const ComposerV5 = await ethers.getContractFactory("TragedyModularSVGComposerV5");
    const composerV5 = await ComposerV5.deploy(
        monsterBankAddress,
        backgroundBankAddress,
        itemBankAddress,
        effectBankAddress
    );
    await composerV5.deployed();
    console.log("Composer V5 deployed to:", composerV5.address);
    
    // Update NFT to use new composer
    console.log("\n2. Updating NFT contract...");
    const nftAddress = deploymentData.contracts.nft;
    const metadataBankAddress = deploymentData.contracts.metadataBank;
    
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = NFT.attach(nftAddress);
    
    const tx = await nft.updateContracts(metadataBankAddress, composerV5.address);
    await tx.wait();
    console.log("NFT updated to use new Composer V5");
    
    // Test composition
    console.log("\n3. Testing composition...");
    try {
        // Test with effect that has defs (e.g., Meteor = 3)
        const testSvg = await composerV5.composeSVG(0, 0, 0, 3);
        console.log("Test composition successful!");
        console.log("SVG length:", testSvg.length);
        
        // Check if defs is present
        if (testSvg.includes("<defs>") && testSvg.includes("</defs>")) {
            console.log("✓ Defs section preserved");
        } else {
            console.log("⚠ Warning: Defs section not found");
        }
        
        // Check layer order
        const bgIndex = testSvg.indexOf("#1A0000"); // Bloodmoon color
        const effectIndex = testSvg.indexOf("animateTransform"); // Effect animation
        if (bgIndex > 0 && effectIndex > bgIndex) {
            console.log("✓ Layer order appears correct");
        }
        
    } catch (error) {
        console.error("Test composition failed:", error.message);
    }
    
    // Update deployment data
    console.log("\n4. Updating deployment data...");
    deploymentData.contracts.composerV5 = composerV5.address;
    fs.writeFileSync('./scripts/deployment-result.json', JSON.stringify(deploymentData, null, 2));
    
    console.log("\n✅ Composer V5 deployment complete!");
    console.log("Composer V5 address:", composerV5.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });