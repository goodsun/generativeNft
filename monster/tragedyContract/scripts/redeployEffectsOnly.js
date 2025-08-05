const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

// ライブラリから個別コントラクトを生成
function generateEffectContracts() {
    const effectNames = [
        'Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'
    ];
    
    const outputDir = path.join(__dirname, '../contracts/layer4/svgs/effects');
    
    // ディレクトリ作成
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }
    
    console.log('🔨 Generating effect contracts from libraries...\n');
    
    effectNames.forEach(name => {
        // ライブラリファイルを読み込み
        const libPath = path.join(__dirname, `../contracts/layer4/generated/effect/Tragedy${name}Lib.sol`);
        const libContent = fs.readFileSync(libPath, 'utf8');
        
        // ライブラリからgetSVG関数の内容を抽出
        const match = libContent.match(/return string\(abi\.encodePacked\(([\s\S]*?)\)\);/);
        if (!match) {
            console.error(`❌ Failed to extract SVG from ${name} library`);
            return;
        }
        
        const svgContent = match[1];
        
        // 個別コントラクトを生成
        const contractCode = `// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Tragedy${name}
 * @notice Individual SVG contract for ${name} effect
 */
contract Tragedy${name} {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(${svgContent}));
    }
}`;
        
        const outputPath = path.join(outputDir, `Tragedy${name}.sol`);
        fs.writeFileSync(outputPath, contractCode);
        console.log(`✅ Generated: Tragedy${name}.sol`);
    });
}

async function main() {
    console.log("🚀 Redeploying effect contracts with fixed coordinates...\n");
    
    // 1. Generate contracts from libraries
    generateEffectContracts();
    
    const [deployer] = await ethers.getSigners();
    console.log("\nDeploying with account:", deployer.address);
    
    // Load current deployment data
    const deploymentPath = path.join(__dirname, 'deployment-result.json');
    const deployment = JSON.parse(fs.readFileSync(deploymentPath, 'utf8'));
    
    // Effect names
    const effectNames = [
        'Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'
    ];
    
    // 2. Deploy each effect contract
    console.log("\n📦 Deploying individual effect contracts...");
    const effectAddresses = [];
    
    for (let i = 0; i < effectNames.length; i++) {
        const name = effectNames[i];
        console.log(`  Deploying Tragedy${name}...`);
        
        try {
            const Contract = await ethers.getContractFactory(`Tragedy${name}`);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            effectAddresses.push(contract.address);
            deployment.contracts.effects[name] = contract.address;
            console.log(`  ✅ ${name}: ${contract.address}`);
        } catch (error) {
            console.error(`  ❌ Failed to deploy ${name}:`, error.message);
            return;
        }
    }
    
    // 3. Deploy new Effect Bank
    console.log("\n🏦 Deploying new Effect Bank...");
    const EffectBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularEffectBank.sol:TragedyModularEffectBank");
    const effectBank = await EffectBank.deploy(effectAddresses);
    await effectBank.deployed();
    
    console.log("✅ New Effect Bank deployed to:", effectBank.address);
    
    // 4. Deploy new Composer
    console.log("\n🎨 Deploying new Composer with updated Effect Bank...");
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV4");
    const newComposer = await Composer.deploy(
        deployment.contracts.banks.monsterBank,
        deployment.contracts.banks.backgroundBank,
        deployment.contracts.banks.itemBank,
        effectBank.address // New effect bank
    );
    await newComposer.deployed();
    
    console.log("✅ New Composer V6 deployed to:", newComposer.address);
    
    // 5. Update NFT contract
    console.log("\n🔄 Updating NFT contract...");
    const nftContract = await ethers.getContractAt("TragedyNFTV2", deployment.contracts.nft);
    const tx = await nftContract.updateContracts(
        deployment.contracts.metadataBank,
        newComposer.address
    );
    await tx.wait();
    console.log("✅ NFT contract updated!");
    
    // Update deployment data
    deployment.contracts.banks.effectBankV2 = effectBank.address;
    deployment.contracts.composerV6 = newComposer.address;
    fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
    
    // 6. Test the new setup
    console.log("\n🧪 Testing updated contracts...");
    try {
        const svg = await newComposer.composeSVG(0, 0, 0, 3); // Werewolf + Bloodmoon + Crown + Meteor
        console.log("✅ Composed SVG length:", svg.length);
        
        // Extract just the Meteor part to verify coordinates
        const meteorOnly = await effectBank.getEffectSVG(3);
        console.log("✅ Meteor SVG length:", meteorOnly.length);
        
        // Check if it contains the fixed coordinates
        if (meteorOnly.includes('x="2.4"')) {
            console.log("✅ Coordinates are fixed! (x=\"2.4\" found)");
        } else {
            console.log("⚠️  Coordinates might not be fixed");
        }
        
        // Save test results
        fs.writeFileSync('fixed-composed-test.svg', svg);
        fs.writeFileSync('fixed-meteor-only.svg', meteorOnly);
        console.log("💾 Test SVGs saved");
        
    } catch (error) {
        console.error("❌ Test failed:", error.message);
    }
    
    console.log("\n✨ Effect contracts redeployment complete!");
    console.log("\n📋 Summary:");
    console.log("  Old Effect Bank:", deployment.contracts.banks.effectBank);
    console.log("  New Effect Bank:", effectBank.address);
    console.log("  New Composer V6:", newComposer.address);
    console.log("  NFT Contract:", deployment.contracts.nft);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });