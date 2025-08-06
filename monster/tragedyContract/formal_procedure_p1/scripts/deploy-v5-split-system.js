const hre = require("hardhat");
const fs = require("fs");

async function main() {
    console.log("🚀 Deploying V5 Split System with Synergy Transformations...\n");
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    
    const deploymentData = {
        timestamp: new Date().toISOString(),
        network: hre.network.name,
        deployer: deployer.address,
        contracts: {}
    };
    
    try {
        // 1. Deploy Item Banks (split into 2 contracts)
        console.log("\n1. Deploying ArweaveItemBank1 (0-5)...");
        const ItemBank1 = await ethers.getContractFactory("ArweaveItemBank1");
        const itemBank1 = await ItemBank1.deploy();
        await itemBank1.deployed();
        console.log("✅ ArweaveItemBank1 deployed to:", itemBank1.address);
        deploymentData.contracts.itemBank1 = itemBank1.address;
        
        console.log("\n2. Deploying ArweaveItemBank2 (6-11)...");
        const ItemBank2 = await ethers.getContractFactory("ArweaveItemBank2");
        const itemBank2 = await ItemBank2.deploy();
        await itemBank2.deployed();
        console.log("✅ ArweaveItemBank2 deployed to:", itemBank2.address);
        deploymentData.contracts.itemBank2 = itemBank2.address;
        
        // 2. Deploy Item Bank V3 (unified interface)
        console.log("\n3. Deploying ArweaveItemBankV3Fixed...");
        const ItemBankV3 = await ethers.getContractFactory("ArweaveItemBankV3Fixed");
        const itemBankV3 = await ItemBankV3.deploy(itemBank1.address, itemBank2.address);
        await itemBankV3.deployed();
        console.log("✅ ArweaveItemBankV3Fixed deployed to:", itemBankV3.address);
        deploymentData.contracts.itemBankV3 = itemBankV3.address;
        
        // 3. Deploy Monster Banks (split into 2 contracts)
        console.log("\n4. Deploying ArweaveMonsterBank1 (0-4)...");
        const MonsterBank1 = await ethers.getContractFactory("ArweaveMonsterBank1");
        const monsterBank1 = await MonsterBank1.deploy();
        await monsterBank1.deployed();
        console.log("✅ ArweaveMonsterBank1 deployed to:", monsterBank1.address);
        deploymentData.contracts.monsterBank1 = monsterBank1.address;
        
        console.log("\n5. Deploying ArweaveMonsterBank2 (5-9)...");
        const MonsterBank2 = await ethers.getContractFactory("ArweaveMonsterBank2");
        const monsterBank2 = await MonsterBank2.deploy();
        await monsterBank2.deployed();
        console.log("✅ ArweaveMonsterBank2 deployed to:", monsterBank2.address);
        deploymentData.contracts.monsterBank2 = monsterBank2.address;
        
        // 4. Deploy Monster Bank V3 (unified interface)
        console.log("\n6. Deploying ArweaveMonsterBankV3...");
        const MonsterBankV3 = await ethers.getContractFactory("ArweaveMonsterBankV3");
        const monsterBankV3 = await MonsterBankV3.deploy(monsterBank1.address, monsterBank2.address);
        await monsterBankV3.deployed();
        console.log("✅ ArweaveMonsterBankV3 deployed to:", monsterBankV3.address);
        deploymentData.contracts.monsterBankV3 = monsterBankV3.address;
        
        // 5. Deploy Background Bank
        console.log("\n7. Deploying ArweaveBackgroundBank...");
        const BackgroundBank = await ethers.getContractFactory("ArweaveBackgroundBank");
        const backgroundBank = await BackgroundBank.deploy();
        await backgroundBank.deployed();
        console.log("✅ ArweaveBackgroundBank deployed to:", backgroundBank.address);
        deploymentData.contracts.backgroundBank = backgroundBank.address;
        
        // 6. Deploy Effect Bank
        console.log("\n8. Deploying ArweaveEffectBank...");
        const EffectBank = await ethers.getContractFactory("ArweaveEffectBank");
        const effectBank = await EffectBank.deploy();
        await effectBank.deployed();
        console.log("✅ ArweaveEffectBank deployed to:", effectBank.address);
        deploymentData.contracts.effectBank = effectBank.address;
        
        // 7. Deploy ComposerV5 (with synergy transformations)
        console.log("\n9. Deploying ArweaveTragedyComposerV5...");
        const ComposerV5 = await ethers.getContractFactory("ArweaveTragedyComposerV5");
        const composerV5 = await ComposerV5.deploy(
            monsterBankV3.address,
            backgroundBank.address,
            itemBankV3.address,
            effectBank.address
        );
        await composerV5.deployed();
        console.log("✅ ArweaveTragedyComposerV5 deployed to:", composerV5.address);
        deploymentData.contracts.composerV5 = composerV5.address;
        
        // 8. Deploy MetadataV5
        console.log("\n10. Deploying TragedyMetadataV5...");
        const MetadataV5 = await ethers.getContractFactory("TragedyMetadataV5");
        const metadataV5 = await MetadataV5.deploy(composerV5.address);
        await metadataV5.deployed();
        console.log("✅ TragedyMetadataV5 deployed to:", metadataV5.address);
        deploymentData.contracts.metadataV5 = metadataV5.address;
        
        // 9. Deploy BankedNFT
        console.log("\n11. Deploying TragedyBankedNFT...");
        const BankedNFT = await ethers.getContractFactory("TragedyBankedNFT");
        const bankedNFT = await BankedNFT.deploy(
            metadataV5.address
        );
        await bankedNFT.deployed();
        console.log("✅ TragedyBankedNFT deployed to:", bankedNFT.address);
        deploymentData.contracts.bankedNFT = bankedNFT.address;
        
        // Save deployment data
        const filename = `deployment-v5-split-${hre.network.name}-${Date.now()}.json`;
        fs.writeFileSync(filename, JSON.stringify(deploymentData, null, 2));
        console.log(`\n💾 Deployment data saved to ${filename}`);
        
        // Print summary
        console.log("\n🎉 V5 Split System Deployment Complete!");
        console.log("=====================================");
        console.log("Item Banks:");
        console.log("  - Bank1:", itemBank1.address);
        console.log("  - Bank2:", itemBank2.address);
        console.log("  - BankV3:", itemBankV3.address);
        console.log("Monster Banks:");
        console.log("  - Bank1:", monsterBank1.address);
        console.log("  - Bank2:", monsterBank2.address);
        console.log("  - BankV3:", monsterBankV3.address);
        console.log("Other Banks:");
        console.log("  - Background:", backgroundBank.address);
        console.log("  - Effect:", effectBank.address);
        console.log("Core Contracts:");
        console.log("  - ComposerV5:", composerV5.address);
        console.log("  - MetadataV5:", metadataV5.address);
        console.log("  - BankedNFT:", bankedNFT.address);
        console.log("=====================================");
        
        // Test synergy transformations
        console.log("\n🧪 Testing Synergy Transformations...");
        
        // Test Werewolf + Amulet transformation
        console.log("\nTesting Werewolf + Amulet -> Head transformation:");
        const displayItem1 = await composerV5.getDisplayItem(0, 9); // Werewolf=0, Amulet=9
        console.log(`Werewolf + Amulet: Item ${9} -> Item ${displayItem1}`);
        if (displayItem1 == 10) {
            console.log("✅ Transformation successful: Amulet -> Head");
        }
        
        // Test Frankenstein + Shoulder transformation
        console.log("\nTesting Frankenstein + Shoulder -> Arm transformation:");
        const displayItem2 = await composerV5.getDisplayItem(2, 8); // Frankenstein=2, Shoulder=8
        console.log(`Frankenstein + Shoulder: Item ${8} -> Item ${displayItem2}`);
        if (displayItem2 == 11) {
            console.log("✅ Transformation successful: Shoulder -> Arm");
        }
        
        // Test item names
        console.log("\n🔍 Testing item names:");
        const headName = await itemBankV3.getItemName(10);
        const armName = await itemBankV3.getItemName(11);
        console.log(`Item 10: ${headName}`);
        console.log(`Item 11: ${armName}`);
        
        // Generate sample metadata
        console.log("\n📊 Generating sample metadata...");
        const sampleMetadata = await metadataV5.getMetadata(0); // Token ID 1
        const decodedMetadata = Buffer.from(sampleMetadata.split(',')[1], 'base64').toString();
        const metadata = JSON.parse(decodedMetadata);
        console.log("Sample metadata attributes:");
        metadata.attributes.forEach(attr => {
            console.log(`  - ${attr.trait_type}: ${attr.value}`);
        });
        
    } catch (error) {
        console.error("❌ Deployment failed:", error);
        deploymentData.error = error.message;
        fs.writeFileSync(
            `deployment-v5-split-failed-${Date.now()}.json`,
            JSON.stringify(deploymentData, null, 2)
        );
        process.exit(1);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });