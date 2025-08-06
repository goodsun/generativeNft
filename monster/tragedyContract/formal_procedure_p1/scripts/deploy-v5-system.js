const hre = require("hardhat");
const fs = require("fs");

async function main() {
    console.log("🚀 Deploying V5 System with Synergy Transformations...\n");
    
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
        // 1. Deploy ArweaveItemBank (with Head and Arm)
        console.log("\n1. Deploying ArweaveItemBank with 12 items...");
        const ItemBank = await ethers.getContractFactory("contracts/ArweaveItemBankV2.sol:ArweaveItemBank");
        const itemBank = await ItemBank.deploy();
        await itemBank.deployed();
        console.log("✅ ArweaveItemBank deployed to:", itemBank.address);
        deploymentData.contracts.itemBank = itemBank.address;
        
        // 2. Deploy Monster Bank
        console.log("\n2. Deploying ArweaveMonsterBank...");
        const MonsterBank = await ethers.getContractFactory("contracts/ArweaveMonsterBankV2.sol:ArweaveMonsterBank");
        const monsterBank = await MonsterBank.deploy();
        await monsterBank.deployed();
        console.log("✅ ArweaveMonsterBank deployed to:", monsterBank.address);
        deploymentData.contracts.monsterBank = monsterBank.address;
        
        // 3. Deploy Background Bank
        console.log("\n3. Deploying ArweaveBackgroundBank...");
        const BackgroundBank = await ethers.getContractFactory("ArweaveBackgroundBank");
        const backgroundBank = await BackgroundBank.deploy();
        await backgroundBank.deployed();
        console.log("✅ ArweaveBackgroundBank deployed to:", backgroundBank.address);
        deploymentData.contracts.backgroundBank = backgroundBank.address;
        
        // 4. Deploy Effect Bank
        console.log("\n4. Deploying ArweaveEffectBank...");
        const EffectBank = await ethers.getContractFactory("ArweaveEffectBank");
        const effectBank = await EffectBank.deploy();
        await effectBank.deployed();
        console.log("✅ ArweaveEffectBank deployed to:", effectBank.address);
        deploymentData.contracts.effectBank = effectBank.address;
        
        // 5. Deploy ComposerV5 (with synergy transformations)
        console.log("\n5. Deploying ArweaveTragedyComposerV5...");
        const ComposerV5 = await ethers.getContractFactory("ArweaveTragedyComposerV5");
        const composerV5 = await ComposerV5.deploy(
            monsterBank.address,
            backgroundBank.address,
            itemBank.address,
            effectBank.address
        );
        await composerV5.deployed();
        console.log("✅ ArweaveTragedyComposerV5 deployed to:", composerV5.address);
        deploymentData.contracts.composerV5 = composerV5.address;
        
        // 6. Deploy MetadataV5
        console.log("\n6. Deploying TragedyMetadataV5...");
        const MetadataV5 = await ethers.getContractFactory("TragedyMetadataV5");
        const metadataV5 = await MetadataV5.deploy(composerV5.address);
        await metadataV5.deployed();
        console.log("✅ TragedyMetadataV5 deployed to:", metadataV5.address);
        deploymentData.contracts.metadataV5 = metadataV5.address;
        
        // 7. Deploy BankedNFT
        console.log("\n7. Deploying TragedyBankedNFT...");
        const BankedNFT = await ethers.getContractFactory("TragedyBankedNFT");
        const bankedNFT = await BankedNFT.deploy(
            "Tragedy: The Mythical Cursed-Nightmare",
            "TRAGEDY",
            deployer.address,
            500, // 5% royalty
            metadataV5.address
        );
        await bankedNFT.deployed();
        console.log("✅ TragedyBankedNFT deployed to:", bankedNFT.address);
        deploymentData.contracts.bankedNFT = bankedNFT.address;
        
        // Save deployment data
        const filename = `deployment-v5-${hre.network.name}-${Date.now()}.json`;
        fs.writeFileSync(filename, JSON.stringify(deploymentData, null, 2));
        console.log(`\n💾 Deployment data saved to ${filename}`);
        
        // Print summary
        console.log("\n🎉 V5 System Deployment Complete!");
        console.log("=====================================");
        console.log("Item Bank:", itemBank.address);
        console.log("Monster Bank:", monsterBank.address);
        console.log("Background Bank:", backgroundBank.address);
        console.log("Effect Bank:", effectBank.address);
        console.log("ComposerV5:", composerV5.address);
        console.log("MetadataV5:", metadataV5.address);
        console.log("BankedNFT:", bankedNFT.address);
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
        
        // Test normal case (no transformation)
        console.log("\nTesting normal case (no transformation):");
        const displayItem3 = await composerV5.getDisplayItem(0, 0); // Werewolf=0, Crown=0
        console.log(`Werewolf + Crown: Item ${0} -> Item ${displayItem3}`);
        if (displayItem3 == 0) {
            console.log("✅ No transformation (as expected)");
        }
        
    } catch (error) {
        console.error("❌ Deployment failed:", error);
        deploymentData.error = error.message;
        fs.writeFileSync(
            `deployment-v5-failed-${Date.now()}.json`,
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