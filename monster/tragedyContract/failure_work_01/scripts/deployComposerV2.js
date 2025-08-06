const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🎨 Deploying Tragedy Modular SVG Composer V2...\n");
    
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
    
    // Deploy Composer V2
    console.log("\n🚀 Deploying TragedyModularSVGComposerV2...");
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV2");
    const composer = await Composer.deploy(
        monsterBankAddress,
        backgroundBankAddress,
        itemBankAddress,
        effectBankAddress
    );
    await composer.deployed();
    
    console.log("✅ Composer V2 deployed to:", composer.address);
    
    // Update deployment data
    deployment.contracts.composerV2 = composer.address;
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // Test the composer
    console.log("\n🧪 Testing Composer V2...");
    try {
        // Test extractContent function first
        const testSVG = '<svg viewBox="0 0 24 24"><rect x="0" y="0"/></svg>';
        const extracted = await composer.testExtractContent(testSVG);
        console.log("✅ Extract test result:", extracted);
        
        // Test composing Werewolf + Bloodmoon + Crown + Meteor
        console.log("\n🎯 Composing NFT: Werewolf + Bloodmoon + Crown + Meteor");
        const svg = await composer.composeSVG(0, 0, 0, 3);
        console.log("✅ Composed SVG length:", svg.length);
        console.log("✅ First 200 chars:", svg.substring(0, 200) + "...");
        
        // Save test result
        fs.writeFileSync('composed-v2-test.svg', svg);
        console.log("💾 Test SVG saved to: composed-v2-test.svg");
        
        // Test optional composition (just monster)
        console.log("\n🎯 Testing optional composition (just Werewolf)");
        const simpleSvg = await composer.composeOptionalSVG(0, 255, 255, 255);
        console.log("✅ Simple SVG length:", simpleSvg.length);
        fs.writeFileSync('werewolf-only.svg', simpleSvg);
        console.log("💾 Simple SVG saved to: werewolf-only.svg");
        
    } catch (error) {
        console.error("❌ Test failed:", error.message);
    }
    
    console.log("\n✨ Composer V2 deployment complete!");
    
    return composer.address;
}

main()
    .then((address) => {
        console.log("\n🎯 Final Composer V2 address:", address);
        process.exit(0);
    })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });