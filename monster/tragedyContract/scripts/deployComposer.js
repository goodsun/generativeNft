const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🎨 Deploying Tragedy Modular SVG Composer...\n");
    
    // Load deployment data to get bank addresses
    const deploymentPath = path.join(__dirname, 'deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    // Get bank addresses from deployment data
    const monsterBankAddress = deployment.contracts.banks.monsterBank;
    const backgroundBankAddress = deployment.contracts.banks.backgroundBank;
    const itemBankAddress = deployment.contracts.banks.itemBank;
    const effectBankAddress = deployment.contracts.banks.effectBank;
    
    console.log("\n📍 Using Bank addresses:");
    console.log("  Monster Bank:", monsterBankAddress);
    console.log("  Background Bank:", backgroundBankAddress);
    console.log("  Item Bank:", itemBankAddress);
    console.log("  Effect Bank:", effectBankAddress);
    
    // Deploy Composer
    console.log("\n🚀 Deploying TragedyModularSVGComposer...");
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposer");
    const composer = await Composer.deploy(
        monsterBankAddress,
        backgroundBankAddress,
        itemBankAddress,
        effectBankAddress
    );
    await composer.deployed();
    
    console.log("✅ Composer deployed to:", composer.address);
    
    // Update deployment data
    deployment.contracts.composer = composer.address;
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // Test the composer
    console.log("\n🧪 Testing Composer...");
    try {
        // Test composing Werewolf + Bloodmoon + Crown + Meteor
        const svg = await composer.composeSVG(0, 0, 0, 3);
        console.log("✅ Composed SVG length:", svg.length);
        console.log("✅ First 100 chars:", svg.substring(0, 100) + "...");
        
        // Save test result
        fs.writeFileSync('composed-test.svg', svg);
        console.log("💾 Test SVG saved to: composed-test.svg");
    } catch (error) {
        console.error("❌ Test failed:", error.message);
    }
    
    console.log("\n✨ Composer deployment complete!");
    
    return composer.address;
}

main()
    .then((address) => {
        console.log("\n🎯 Final Composer address:", address);
        process.exit(0);
    })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });