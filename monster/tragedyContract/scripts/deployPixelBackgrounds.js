// Deploy new pixel art backgrounds

const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying pixel backgrounds with account:", deployer.address);
    
    // Background names in order
    const backgroundNames = [
        'Bloodmoon', 'Abyss', 'Decay', 'Corruption', 'Venom',
        'Void', 'Inferno', 'Frost', 'Ragnarok', 'Shadow'
    ];
    
    // Deploy background contracts
    console.log("\n1. Deploying background contracts...");
    const backgroundAddresses = [];
    
    for (let i = 0; i < backgroundNames.length; i++) {
        const bgName = backgroundNames[i];
        console.log(`\nDeploying Tragedy${bgName}Pixel...`);
        
        const Background = await ethers.getContractFactory(`Tragedy${bgName}Pixel`);
        const background = await Background.deploy();
        await background.deployed();
        
        backgroundAddresses.push(background.address);
        console.log(`Tragedy${bgName}Pixel deployed to:`, background.address);
    }
    
    // Deploy new Background Bank
    console.log("\n2. Deploying new Background Bank...");
    const BackgroundBank = await ethers.getContractFactory("TragedyModularBackgroundBank");
    const backgroundBank = await BackgroundBank.deploy(backgroundAddresses);
    await backgroundBank.deployed();
    console.log("New Background Bank deployed to:", backgroundBank.address);
    
    // Deploy new Composer (V8) with updated banks
    console.log("\n3. Deploying new Composer...");
    
    // Get existing bank addresses
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    const monsterBankAddress = deploymentData.contracts.banks.monsterBank;
    const itemBankAddress = deploymentData.contracts.banks.itemBankV2 || deploymentData.contracts.banks.itemBank;
    const effectBankAddress = deploymentData.contracts.banks.effectBankV2 || deploymentData.contracts.banks.effectBank;
    
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV4");
    const composer = await Composer.deploy(
        monsterBankAddress,
        backgroundBank.address,  // New pixel background bank
        itemBankAddress,
        effectBankAddress
    );
    await composer.deployed();
    console.log("New Composer V8 deployed to:", composer.address);
    
    // Update NFT to use new composer
    console.log("\n4. Updating NFT contract...");
    const nftAddress = deploymentData.contracts.nft;
    const metadataBankAddress = deploymentData.contracts.metadataBank;
    
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = NFT.attach(nftAddress);
    
    const tx = await nft.updateContracts(metadataBankAddress, composer.address);
    await tx.wait();
    console.log("NFT updated to use new Composer");
    
    // Update deployment data
    console.log("\n5. Updating deployment data...");
    
    // Store new background addresses
    deploymentData.contracts.backgroundsPixel = {};
    backgroundNames.forEach((name, i) => {
        deploymentData.contracts.backgroundsPixel[name] = backgroundAddresses[i];
    });
    
    // Add new addresses
    deploymentData.contracts.banks.backgroundBankPixel = backgroundBank.address;
    deploymentData.contracts.composerV8 = composer.address;
    
    fs.writeFileSync('./scripts/deployment-result.json', JSON.stringify(deploymentData, null, 2));
    
    console.log("\n✅ Pixel background deployment complete!");
    console.log("New Background Bank:", backgroundBank.address);
    console.log("New Composer V8:", composer.address);
    
    // Test with a sample composition
    console.log("\n6. Testing composition...");
    try {
        const testSvg = await composer.composeSVG(0, 0, 0, 0);
        console.log("Test composition successful!");
        console.log("SVG length:", testSvg.length);
    } catch (error) {
        console.error("Test composition failed:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });