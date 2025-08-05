// Clean deployment of all contracts from scratch
// This will deploy everything in the correct order with clear versioning

const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("=== CLEAN DEPLOYMENT START ===");
    console.log("Deploying with account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    
    // Create new deployment data
    const deployment = {
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        network: "bonsoleil",
        contracts: {
            svgs: {
                monsters: {},
                backgrounds: {},
                items: {},
                effects: {}
            },
            banks: {},
            composer: null,
            metadataBank: null,
            nft: null
        }
    };
    
    console.log("\n====== PHASE 1: Deploy Individual SVG Contracts ======");
    
    // 1. Deploy Monster SVGs
    console.log("\n📦 Deploying Monster SVGs...");
    const monsterNames = ['Werewolf', 'Goblin', 'Frankenstein', 'Demon', 'Dragon', 
                         'Zombie', 'Vampire', 'Mummy', 'Succubus', 'Skeleton'];
    const monsterAddresses = [];
    
    for (const name of monsterNames) {
        try {
            const Contract = await ethers.getContractFactory(`Tragedy${name}`);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            monsterAddresses.push(contract.address);
            deployment.contracts.svgs.monsters[name] = contract.address;
            console.log(`  ✓ ${name}: ${contract.address}`);
        } catch (error) {
            console.error(`  ✗ Failed to deploy ${name}:`, error.message);
            process.exit(1);
        }
    }
    
    // 2. Deploy Background SVGs (Pixel version)
    console.log("\n📦 Deploying Background SVGs (Pixel)...");
    const backgroundNames = ['Bloodmoon', 'Abyss', 'Decay', 'Corruption', 'Venom',
                           'Void', 'Inferno', 'Frost', 'Ragnarok', 'Shadow'];
    const backgroundAddresses = [];
    
    for (const name of backgroundNames) {
        try {
            const Contract = await ethers.getContractFactory(`Tragedy${name}Pixel`);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            backgroundAddresses.push(contract.address);
            deployment.contracts.svgs.backgrounds[name] = contract.address;
            console.log(`  ✓ ${name}Pixel: ${contract.address}`);
        } catch (error) {
            console.error(`  ✗ Failed to deploy ${name}Pixel:`, error.message);
            process.exit(1);
        }
    }
    
    // 3. Deploy Item SVGs
    console.log("\n📦 Deploying Item SVGs...");
    const itemNames = ['Crown', 'Sword', 'Shield', 'Poison', 'Torch',
                      'Wine', 'Scythe', 'Staff', 'Shoulder', 'Amulet'];
    const itemAddresses = [];
    
    for (const name of itemNames) {
        try {
            const Contract = await ethers.getContractFactory(`Tragedy${name}`);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            itemAddresses.push(contract.address);
            deployment.contracts.svgs.items[name] = contract.address;
            console.log(`  ✓ ${name}: ${contract.address}`);
        } catch (error) {
            console.error(`  ✗ Failed to deploy ${name}:`, error.message);
            process.exit(1);
        }
    }
    
    // 4. Deploy Effect SVGs
    console.log("\n📦 Deploying Effect SVGs...");
    const effectNames = ['Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats',
                        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'];
    const effectAddresses = [];
    
    for (const name of effectNames) {
        try {
            const Contract = await ethers.getContractFactory(`Tragedy${name}`);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            effectAddresses.push(contract.address);
            deployment.contracts.svgs.effects[name] = contract.address;
            console.log(`  ✓ ${name}: ${contract.address}`);
        } catch (error) {
            console.error(`  ✗ Failed to deploy ${name}:`, error.message);
            process.exit(1);
        }
    }
    
    console.log("\n====== PHASE 2: Deploy Bank Contracts ======");
    
    // 5. Deploy Monster Bank
    console.log("\n🏦 Deploying Monster Bank...");
    const MonsterBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank");
    const monsterBank = await MonsterBank.deploy(monsterAddresses);
    await monsterBank.deployed();
    deployment.contracts.banks.monsterBank = monsterBank.address;
    console.log("  ✓ Monster Bank:", monsterBank.address);
    
    // 6. Deploy Background Bank
    console.log("\n🏦 Deploying Background Bank...");
    const BackgroundBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularBackgroundBank.sol:TragedyModularBackgroundBank");
    const backgroundBank = await BackgroundBank.deploy(backgroundAddresses);
    await backgroundBank.deployed();
    deployment.contracts.banks.backgroundBank = backgroundBank.address;
    console.log("  ✓ Background Bank:", backgroundBank.address);
    
    // 7. Deploy Item Bank
    console.log("\n🏦 Deploying Item Bank...");
    const ItemBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularItemBank.sol:TragedyModularItemBank");
    const itemBank = await ItemBank.deploy(itemAddresses);
    await itemBank.deployed();
    deployment.contracts.banks.itemBank = itemBank.address;
    console.log("  ✓ Item Bank:", itemBank.address);
    
    // 8. Deploy Effect Bank
    console.log("\n🏦 Deploying Effect Bank...");
    const EffectBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularEffectBank.sol:TragedyModularEffectBank");
    const effectBank = await EffectBank.deploy(effectAddresses);
    await effectBank.deployed();
    deployment.contracts.banks.effectBank = effectBank.address;
    console.log("  ✓ Effect Bank:", effectBank.address);
    
    console.log("\n====== PHASE 3: Deploy Composer ======");
    
    // 9. Deploy Composer V5 (latest version with defs handling)
    console.log("\n🎨 Deploying Composer V5...");
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV5");
    const composer = await Composer.deploy(
        monsterBank.address,
        backgroundBank.address,
        itemBank.address,
        effectBank.address
    );
    await composer.deployed();
    deployment.contracts.composer = composer.address;
    console.log("  ✓ Composer V5:", composer.address);
    
    // Test composition
    console.log("\n🧪 Testing composition...");
    try {
        const testSvg = await composer.composeSVG(0, 0, 0, 3); // Meteor effect
        console.log("  ✓ Test composition successful!");
        console.log("    SVG length:", testSvg.length);
        console.log("    Has defs:", testSvg.includes("<defs>"));
    } catch (error) {
        console.error("  ✗ Test composition failed:", error.message);
    }
    
    console.log("\n====== PHASE 4: Deploy Metadata Bank ======");
    
    // 10. Deploy Metadata Bank
    console.log("\n📚 Deploying Metadata Bank...");
    const MetadataBank = await ethers.getContractFactory("TragedySimpleMetadataBank");
    const metadataBank = await MetadataBank.deploy();
    await metadataBank.deployed();
    deployment.contracts.metadataBank = metadataBank.address;
    console.log("  ✓ Metadata Bank:", metadataBank.address);
    
    console.log("\n====== PHASE 5: Deploy NFT Contract ======");
    
    // 11. Deploy NFT
    console.log("\n🎨 Deploying NFT Contract...");
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = await NFT.deploy(
        metadataBank.address,
        composer.address
    );
    await nft.deployed();
    deployment.contracts.nft = nft.address;
    console.log("  ✓ NFT Contract:", nft.address);
    
    // Save deployment data
    console.log("\n====== SAVING DEPLOYMENT DATA ======");
    const deploymentPath = './scripts/deployment-clean.json';
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    console.log(`  ✓ Deployment data saved to ${deploymentPath}`);
    
    // Also copy to viewer directory
    const viewerPath = './viewer/deployment-result.json';
    fs.writeFileSync(viewerPath, JSON.stringify(deployment, null, 2));
    console.log(`  ✓ Deployment data copied to ${viewerPath}`);
    
    // Summary
    console.log("\n=== DEPLOYMENT SUMMARY ===");
    console.log(`Total SVG contracts: ${monsterNames.length + backgroundNames.length + itemNames.length + effectNames.length}`);
    console.log(`  - Monsters: ${monsterNames.length}`);
    console.log(`  - Backgrounds: ${backgroundNames.length}`);
    console.log(`  - Items: ${itemNames.length}`);
    console.log(`  - Effects: ${effectNames.length}`);
    console.log("\nMain contracts:");
    console.log(`  - NFT: ${nft.address}`);
    console.log(`  - Composer: ${composer.address}`);
    console.log(`  - Metadata Bank: ${metadataBank.address}`);
    console.log("\nBank contracts:");
    console.log(`  - Monster Bank: ${monsterBank.address}`);
    console.log(`  - Background Bank: ${backgroundBank.address}`);
    console.log(`  - Item Bank: ${itemBank.address}`);
    console.log(`  - Effect Bank: ${effectBank.address}`);
    
    console.log("\n✅ CLEAN DEPLOYMENT COMPLETE!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });