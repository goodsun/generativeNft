// Redeploy only Lightning effect with defs section

const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Redeploying Lightning with account:", deployer.address);
    
    // Load deployment data
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    
    // 1. Deploy new Lightning contract
    console.log("\n⚡ Deploying Lightning effect...");
    const Lightning = await ethers.getContractFactory("TragedyLightning");
    const lightning = await Lightning.deploy();
    await lightning.deployed();
    console.log("✅ Lightning deployed to:", lightning.address);
    
    // Update deployment data
    deploymentData.contracts.effects.Lightning = lightning.address;
    
    // 2. Deploy new Effect Bank with updated Lightning
    console.log("\n🏦 Deploying new Effect Bank...");
    
    // Get all effect addresses in correct order
    const effectNames = ['Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
                        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'];
    
    const effectAddresses = effectNames.map(name => {
        if (name === 'Lightning') {
            return lightning.address; // Use new Lightning address
        }
        return deploymentData.contracts.effects[name];
    });
    
    console.log("\nEffect addresses:");
    effectNames.forEach((name, i) => {
        console.log(`  ${i}. ${name}: ${effectAddresses[i]}`);
    });
    
    const EffectBank = await ethers.getContractFactory("TragedyModularEffectBank");
    const effectBank = await EffectBank.deploy(effectAddresses);
    await effectBank.deployed();
    console.log("\n✅ New Effect Bank V3 deployed to:", effectBank.address);
    
    // 3. Deploy new Composer V5 with updated banks
    console.log("\n🎨 Deploying new Composer V5...");
    const ComposerV5 = await ethers.getContractFactory("TragedyModularSVGComposerV5");
    const composerV5 = await ComposerV5.deploy(
        deploymentData.contracts.banks.monsterBank,
        deploymentData.contracts.banks.backgroundBankPixel,
        deploymentData.contracts.banks.itemBankV2,
        effectBank.address // New effect bank V3
    );
    await composerV5.deployed();
    console.log("✅ Composer V5 deployed to:", composerV5.address);
    
    // 4. Update NFT contract
    console.log("\n🔄 Updating NFT contract...");
    const nft = await ethers.getContractAt("TragedyNFTV2", deploymentData.contracts.nft);
    const tx = await nft.updateContracts(deploymentData.contracts.metadataBank, composerV5.address);
    await tx.wait();
    console.log("✅ NFT updated to use new Composer V5");
    
    // 5. Test composition
    console.log("\n🧪 Testing composition with Lightning effect...");
    try {
        const testSvg = await composerV5.composeSVG(0, 0, 0, 6); // Lightning is index 6
        console.log("✅ Test composition successful!");
        console.log("SVG length:", testSvg.length);
        console.log("Has <defs>:", testSvg.includes("<defs>"));
        console.log("Has </defs>:", testSvg.includes("</defs>"));
        
        // Save test output
        fs.writeFileSync('./test-lightning-fixed.svg', testSvg);
        console.log("Test SVG saved to test-lightning-fixed.svg");
        
    } catch (error) {
        console.error("❌ Test composition failed:", error.message);
    }
    
    // 6. Update deployment data
    console.log("\n📝 Updating deployment data...");
    deploymentData.contracts.banks.effectBankV3 = effectBank.address;
    deploymentData.contracts.composerV5Updated = composerV5.address;
    fs.writeFileSync('./scripts/deployment-result.json', JSON.stringify(deploymentData, null, 2));
    
    console.log("\n✅ Lightning redeploy complete!");
    console.log("New Effect Bank V3:", effectBank.address);
    console.log("Updated Composer V5:", composerV5.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });