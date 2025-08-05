const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("📚 Deploying Tragedy Metadata Bank...\n");
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    // Deploy Metadata Bank
    console.log("\n🚀 Deploying TragedyMetadataBank...");
    const MetadataBank = await ethers.getContractFactory("TragedySimpleMetadataBank");
    const metadataBank = await MetadataBank.deploy();
    await metadataBank.deployed();
    
    console.log("✅ Metadata Bank deployed to:", metadataBank.address);
    
    // Update deployment data
    const deploymentPath = path.join(__dirname, 'deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    deployment.contracts.metadataBank = metadataBank.address;
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // Test metadata
    console.log("\n🧪 Testing metadata retrieval...");
    try {
        const [werewolfName, werewolfNameJP] = await metadataBank.getSpeciesNames(0);
        console.log("✅ Werewolf:", werewolfName, "/", werewolfNameJP);
        
        const [bloodmoonName, bloodmoonNameJP] = await metadataBank.getBackgroundNames(0);
        console.log("✅ Bloodmoon:", bloodmoonName, "/", bloodmoonNameJP);
        
        const [crownName, crownNameJP] = await metadataBank.getItemNames(0);
        console.log("✅ Crown:", crownName, "/", crownNameJP);
        
        const [meteorName, meteorNameJP] = await metadataBank.getEffectNames(3);
        console.log("✅ Meteor:", meteorName, "/", meteorNameJP);
        
    } catch (error) {
        console.error("❌ Test failed:", error.message);
    }
    
    console.log("\n✨ Metadata Bank deployment complete!");
    
    return metadataBank.address;
}

main()
    .then((address) => {
        console.log("\n🎯 Final Metadata Bank address:", address);
        process.exit(0);
    })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });