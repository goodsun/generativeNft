// Redeploy only item contracts with scaled down SVGs

const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Redeploying items with account:", deployer.address);
    
    // Item names in order
    const itemNames = [
        'Crown', 'Sword', 'Shield', 'Poison', 'Torch',
        'Wine', 'Scythe', 'Staff', 'Shoulder', 'Amulet'
    ];
    
    // First, generate individual item contracts from the scaled libraries
    console.log("\n1. Generating item contracts from libraries...");
    const generatedDir = path.join(__dirname, '../contracts/layer4/svgs/items');
    if (!fs.existsSync(generatedDir)) {
        fs.mkdirSync(generatedDir, { recursive: true });
    }
    
    // Map library names to item names
    const libToItem = {
        'TragedyArmLib': 'Arm',
        'TragedyHeadLib': 'Head',
        'TragedyCrownLib': 'Crown',
        'TragedySwordLib': 'Sword',
        'TragedyShieldLib': 'Shield',
        'TragedyPoisonLib': 'Poison',
        'TragedyTorchLib': 'Torch',
        'TragedyWineLib': 'Wine',
        'TragedyScytheLib': 'Scythe',
        'TragedyStaffLib': 'Staff',
        'TragedyShoulderLib': 'Shoulder',
        'TragedyAmuletLib': 'Amulet'
    };
    
    const libDir = path.join(__dirname, '../contracts/layer4/generated/items');
    const libFiles = fs.readdirSync(libDir);
    
    for (const libFile of libFiles) {
        const libName = libFile.replace('.sol', '');
        const itemName = libToItem[libName];
        
        // Skip if not in our item list
        if (!itemName || !itemNames.includes(itemName)) continue;
        
        const libPath = path.join(libDir, libFile);
        const libContent = fs.readFileSync(libPath, 'utf8');
        
        // Extract SVG content from library
        const svgMatch = libContent.match(/return string\(abi\.encodePacked\(([\s\S]*?)\)\);/);
        if (!svgMatch) {
            console.error(`Could not extract SVG from ${libFile}`);
            continue;
        }
        
        // Create contract content
        const contractContent = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Tragedy${itemName}
 * @notice Individual SVG contract for ${itemName} item (scaled to 24x24)
 */
contract Tragedy${itemName} {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
${svgMatch[1]}
        ));
    }
}`;
        
        const contractPath = path.join(generatedDir, `Tragedy${itemName}.sol`);
        fs.writeFileSync(contractPath, contractContent);
        console.log(`Generated: Tragedy${itemName}.sol`);
    }
    
    // Compile
    console.log("\n2. Compiling contracts...");
    await hre.run("compile");
    
    // Deploy item contracts
    console.log("\n3. Deploying item contracts...");
    const itemAddresses = [];
    
    for (let i = 0; i < itemNames.length; i++) {
        const itemName = itemNames[i];
        console.log(`\nDeploying Tragedy${itemName}...`);
        
        const Item = await ethers.getContractFactory(`Tragedy${itemName}`);
        const item = await Item.deploy();
        await item.deployed();
        
        itemAddresses.push(item.address);
        console.log(`Tragedy${itemName} deployed to:`, item.address);
    }
    
    // Deploy new Item Bank
    console.log("\n4. Deploying new Item Bank...");
    const ItemBank = await ethers.getContractFactory("TragedyModularItemBank");
    const itemBank = await ItemBank.deploy(itemAddresses);
    await itemBank.deployed();
    console.log("New Item Bank deployed to:", itemBank.address);
    
    // Deploy new Composer with updated banks
    console.log("\n5. Deploying new Composer...");
    
    // Get existing bank addresses
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    const monsterBankAddress = deploymentData.contracts.banks.monsterBank;
    const backgroundBankAddress = deploymentData.contracts.banks.backgroundBank;
    const effectBankAddress = deploymentData.contracts.banks.effectBankV2; // Use V2 with 10 effects
    
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV4");
    const composer = await Composer.deploy(
        monsterBankAddress,
        backgroundBankAddress,
        itemBank.address,  // New item bank
        effectBankAddress
    );
    await composer.deployed();
    console.log("New Composer V7 deployed to:", composer.address);
    
    // Update NFT to use new composer
    console.log("\n6. Updating NFT contract...");
    const nftAddress = deploymentData.contracts.nft;
    const metadataBankAddress = deploymentData.contracts.metadataBank;
    
    const NFT = await ethers.getContractFactory("TragedyNFTV2");
    const nft = NFT.attach(nftAddress);
    
    const tx = await nft.updateContracts(metadataBankAddress, composer.address);
    await tx.wait();
    console.log("NFT updated to use new Composer");
    
    // Update deployment data
    console.log("\n7. Updating deployment data...");
    
    // Update item addresses
    itemNames.forEach((name, i) => {
        deploymentData.contracts.items[name] = itemAddresses[i];
    });
    
    // Add new addresses
    deploymentData.contracts.banks.itemBankV2 = itemBank.address;
    deploymentData.contracts.composerV7 = composer.address;
    
    fs.writeFileSync('./scripts/deployment-result.json', JSON.stringify(deploymentData, null, 2));
    
    console.log("\n✅ Item redeployment complete!");
    console.log("New Item Bank:", itemBank.address);
    console.log("New Composer V7:", composer.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });