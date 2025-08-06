const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy Monster Bank V3 (includes all monsters)
  console.log("\n1. Deploying MonsterBankV3...");
  const MonsterBankV3 = await hre.ethers.getContractFactory("ArweaveMonsterBankV3");
  const monsterBankV3 = await MonsterBankV3.deploy();
  await monsterBankV3.deployed();
  console.log("MonsterBankV3 deployed to:", monsterBankV3.address);

  // Deploy Background Bank
  console.log("\n2. Deploying BackgroundBank...");
  const BackgroundBank = await hre.ethers.getContractFactory("ArweaveBackgroundBank");
  const backgroundBank = await BackgroundBank.deploy();
  await backgroundBank.deployed();
  console.log("BackgroundBank deployed to:", backgroundBank.address);

  // Deploy Item Bank V3
  console.log("\n3. Deploying ItemBankV3...");
  const ItemBankV3 = await hre.ethers.getContractFactory("ArweaveItemBankV3");
  const itemBankV3 = await ItemBankV3.deploy();
  await itemBankV3.deployed();
  console.log("ItemBankV3 deployed to:", itemBankV3.address);

  // Deploy Effect Bank
  console.log("\n4. Deploying EffectBank...");
  const EffectBank = await hre.ethers.getContractFactory("ArweaveEffectBank");
  const effectBank = await EffectBank.deploy();
  await effectBank.deployed();
  console.log("EffectBank deployed to:", effectBank.address);

  // Deploy Composer V5
  console.log("\n5. Deploying ComposerV5...");
  const ComposerV5 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV5");
  const composerV5 = await ComposerV5.deploy(
    monsterBankV3.address,
    backgroundBank.address,
    itemBankV3.address,
    effectBank.address
  );
  await composerV5.deployed();
  console.log("ComposerV5 deployed to:", composerV5.address);

  // Deploy Metadata V5
  console.log("\n6. Deploying MetadataV5...");
  const MetadataV5 = await hre.ethers.getContractFactory("TragedyMetadataV5");
  const metadataV5 = await MetadataV5.deploy(composerV5.address);
  await metadataV5.deployed();
  console.log("MetadataV5 deployed to:", metadataV5.address);

  // Deploy BankedNFT (if not already deployed)
  console.log("\n7. Deploying BankedNFT...");
  const BankedNFT = await hre.ethers.getContractFactory("BankedNFT");
  const bankedNFT = await BankedNFT.deploy("Tragedy NFT", "TRAGEDY", metadataV5.address);
  await bankedNFT.deployed();
  console.log("BankedNFT deployed to:", bankedNFT.address);

  // Save deployment info
  const deployment = {
    network: hre.network.name,
    timestamp: new Date().toISOString(),
    note: "V5 production deployment",
    contracts: {
      bankedNFT: bankedNFT.address,
      metadataV5: metadataV5.address,
      composerV5: composerV5.address,
      monsterBankV3: monsterBankV3.address,
      itemBankV3: itemBankV3.address,
      backgroundBank: backgroundBank.address,
      effectBank: effectBank.address
    }
  };

  const deploymentPath = `deployments/${hre.network.name}-${Date.now()}.json`;
  fs.mkdirSync('deployments', { recursive: true });
  fs.writeFileSync(deploymentPath, JSON.stringify(deployment, null, 2));
  
  // Also update viewer deployment.json
  fs.writeFileSync('viewer/deployment.json', JSON.stringify(deployment, null, 2));

  console.log("\n=== DEPLOYMENT COMPLETE ===");
  console.log("Deployment saved to:", deploymentPath);
  console.log("\nContract addresses:");
  console.log("- BankedNFT:", bankedNFT.address);
  console.log("- MetadataV5:", metadataV5.address);
  console.log("- ComposerV5:", composerV5.address);
  console.log("- MonsterBankV3:", monsterBankV3.address);
  console.log("- ItemBankV3:", itemBankV3.address);
  console.log("- BackgroundBank:", backgroundBank.address);
  console.log("- EffectBank:", effectBank.address);

  // Verify deployment
  console.log("\n=== VERIFYING DEPLOYMENT ===");
  try {
    const testMetadata = await metadataV5.getMetadata(0);
    console.log("✓ Metadata generation works!");
    
    const metadataCount = await metadataV5.getMetadataCount();
    console.log("✓ Metadata count:", metadataCount.toString());
    
    const composerAddress = await metadataV5.composer();
    console.log("✓ Composer link verified:", composerAddress === composerV5.address);
  } catch (error) {
    console.error("✗ Verification failed:", error.message);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});