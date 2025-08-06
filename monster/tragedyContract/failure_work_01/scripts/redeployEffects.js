const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🚀 Redeploying effect contracts with fixed coordinates...\n");
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    // Load current deployment data
    const deploymentPath = path.join(__dirname, 'deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    
    // Effect names
    const effectNames = [
        'Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash', 
        'Blackout', 'Matrix'
    ];
    
    // Deploy each effect contract
    console.log("📦 Deploying individual effect contracts...");
    const effectAddresses = [];
    
    for (let i = 0; i < effectNames.length; i++) {
        const name = effectNames[i];
        console.log(`  Deploying Tragedy${name}...`);
        
        const Contract = await ethers.getContractFactory(`Tragedy${name}`);
        const contract = await Contract.deploy();
        await contract.deployed();
        
        effectAddresses.push(contract.address);
        deployment.contracts.effects[name] = contract.address;
        console.log(`  ✅ ${name}: ${contract.address}`);
    }
    
    // Deploy new Effect Bank with updated addresses
    console.log("\n🏦 Deploying new Effect Bank...");
    const EffectBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularEffectBank.sol:TragedyModularEffectBank");
    const effectBank = await EffectBank.deploy(effectAddresses);
    await effectBank.deployed();
    
    console.log("✅ New Effect Bank deployed to:", effectBank.address);
    
    // Update deployment data
    deployment.contracts.banks.effectBank = effectBank.address;
    deployment.contracts.banks.effectBankV2 = effectBank.address; // Keep track of new version
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // Update NFT contract to use new Effect Bank
    console.log("\n🔄 Updating NFT contract dependencies...");
    const nftContract = await ethers.getContractAt("TragedyNFTV2", deployment.contracts.nft);
    
    // Get current composer address
    const currentComposer = await nftContract.svgComposer();
    console.log("Current Composer:", currentComposer);
    
    // Deploy new Composer with updated Effect Bank
    console.log("\n🎨 Deploying new Composer with updated Effect Bank...");
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV4");
    const newComposer = await Composer.deploy(
        deployment.contracts.banks.monsterBank,
        deployment.contracts.banks.backgroundBank,
        deployment.contracts.banks.itemBank,
        effectBank.address // New effect bank
    );
    await newComposer.deployed();
    
    console.log("✅ New Composer deployed to:", newComposer.address);
    
    // Update NFT contract
    const tx = await nftContract.updateContracts(
        deployment.contracts.metadataBank,
        newComposer.address
    );
    await tx.wait();
    console.log("✅ NFT contract updated!");
    
    // Update deployment data
    deployment.contracts.composerV5 = newComposer.address;
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // Test the new setup
    console.log("\n🧪 Testing updated contracts...");
    try {
        const svg = await newComposer.composeSVG(0, 0, 0, 3); // Werewolf + Bloodmoon + Crown + Meteor
        console.log("✅ Composed SVG length:", svg.length);
        
        // Save test result
        fs.writeFileSync('fixed-meteor-test.svg', svg);
        console.log("💾 Test SVG saved to: fixed-meteor-test.svg");
        
    } catch (error) {
        console.error("❌ Test failed:", error.message);
    }
    
    console.log("\n✨ Effect contracts redeployment complete!");
    console.log("\n📋 Summary:");
    console.log("  New Effect Bank:", effectBank.address);
    console.log("  New Composer V5:", newComposer.address);
    console.log("  NFT Contract:", deployment.contracts.nft);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });