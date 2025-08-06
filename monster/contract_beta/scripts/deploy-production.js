const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy individual Monster Banks first
  console.log("\n1. Deploying MonsterBank1...");
  const MonsterBank1 = await hre.ethers.getContractFactory("ArweaveMonsterBank1");
  const monsterBank1 = await MonsterBank1.deploy();
  await monsterBank1.deployed();
  console.log("MonsterBank1 deployed to:", monsterBank1.address);

  console.log("\n2. Deploying MonsterBank2...");
  const MonsterBank2 = await hre.ethers.getContractFactory("ArweaveMonsterBank2");
  const monsterBank2 = await MonsterBank2.deploy();
  await monsterBank2.deployed();
  console.log("MonsterBank2 deployed to:", monsterBank2.address);

  // Deploy Monster Bank V3 (combines the two banks)
  console.log("\n3. Deploying MonsterBankV3...");
  const MonsterBankV3 = await hre.ethers.getContractFactory("ArweaveMonsterBankV3");
  const monsterBankV3 = await MonsterBankV3.deploy(monsterBank1.address, monsterBank2.address);
  await monsterBankV3.deployed();
  console.log("MonsterBankV3 deployed to:", monsterBankV3.address);

  // Deploy individual Item Banks
  console.log("\n4. Deploying ItemBank1...");
  const ItemBank1 = await hre.ethers.getContractFactory("ArweaveItemBank1");
  const itemBank1 = await ItemBank1.deploy();
  await itemBank1.deployed();
  console.log("ItemBank1 deployed to:", itemBank1.address);

  console.log("\n5. Deploying ItemBank2...");
  const ItemBank2 = await hre.ethers.getContractFactory("ArweaveItemBank2");
  const itemBank2 = await ItemBank2.deploy();
  await itemBank2.deployed();
  console.log("ItemBank2 deployed to:", itemBank2.address);

  // Deploy Item Bank V3
  console.log("\n6. Deploying ItemBankV3...");
  const ItemBankV3 = await hre.ethers.getContractFactory("ArweaveItemBankV3");
  const itemBankV3 = await ItemBankV3.deploy(itemBank1.address, itemBank2.address);
  await itemBankV3.deployed();
  console.log("ItemBankV3 deployed to:", itemBankV3.address);

  // Deploy Background Bank
  console.log("\n7. Deploying BackgroundBank...");
  const BackgroundBank = await hre.ethers.getContractFactory("ArweaveBackgroundBank");
  const backgroundBank = await BackgroundBank.deploy();
  await backgroundBank.deployed();
  console.log("BackgroundBank deployed to:", backgroundBank.address);

  // Deploy Effect Bank
  console.log("\n8. Deploying EffectBank...");
  const EffectBank = await hre.ethers.getContractFactory("ArweaveEffectBank");
  const effectBank = await EffectBank.deploy();
  await effectBank.deployed();
  console.log("EffectBank deployed to:", effectBank.address);

  // Deploy Composer V5
  console.log("\n9. Deploying ComposerV5...");
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
  console.log("\n10. Deploying MetadataV5...");
  const MetadataV5 = await hre.ethers.getContractFactory("TragedyMetadataV5");
  const metadataV5 = await MetadataV5.deploy(composerV5.address);
  await metadataV5.deployed();
  console.log("MetadataV5 deployed to:", metadataV5.address);

  // Deploy BankedNFT
  console.log("\n11. Deploying BankedNFT...");
  const BankedNFT = await hre.ethers.getContractFactory("BankedNFT");
  const maxSupply = 10000; // Maximum NFTs that can be minted
  const mintFee = hre.ethers.utils.parseEther("0.01"); // 0.01 ETH mint fee
  const royaltyRate = 250; // 2.5% royalty
  const bankedNFT = await BankedNFT.deploy("Tragedy NFT", "TRAGEDY", maxSupply, mintFee, royaltyRate);
  await bankedNFT.deployed();
  console.log("BankedNFT deployed to:", bankedNFT.address);
  
  // Set the metadata bank
  console.log("Setting metadata bank...");
  const setMetadataTx = await bankedNFT.setMetadataBank(metadataV5.address);
  await setMetadataTx.wait();
  console.log("Metadata bank set successfully!");

  // Save deployment info
  const deployment = {
    network: hre.network.name,
    timestamp: new Date().toISOString(),
    note: "V5 production deployment with individual banks",
    contracts: {
      bankedNFT: bankedNFT.address,
      metadataV5: metadataV5.address,
      composerV5: composerV5.address,
      monsterBankV3: monsterBankV3.address,
      itemBankV3: itemBankV3.address,
      backgroundBank: backgroundBank.address,
      effectBank: effectBank.address,
      // Individual banks for reference
      monsterBank1: monsterBank1.address,
      monsterBank2: monsterBank2.address,
      itemBank1: itemBank1.address,
      itemBank2: itemBank2.address
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