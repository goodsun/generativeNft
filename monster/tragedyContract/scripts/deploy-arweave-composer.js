const hre = require("hardhat");

async function main() {
  console.log("Deploying TragedyArweaveComposerV2...\n");

  // Get deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // TODO: Replace with actual deployed bank addresses
  // These should be the addresses of your existing MonsterBank and ItemBank contracts
  const MONSTER_BANK_ADDRESS = "0x0000000000000000000000000000000000000000"; // Replace with actual address
  const ITEM_BANK_ADDRESS = "0x0000000000000000000000000000000000000000"; // Replace with actual address

  // For testing, deploy mock banks
  if (MONSTER_BANK_ADDRESS === "0x0000000000000000000000000000000000000000") {
    console.log("\n⚠️  No bank addresses provided, deploying mock banks for testing...");
    
    const MockMonsterBank = await ethers.getContractFactory("MockMonsterBank");
    const mockMonsterBank = await MockMonsterBank.deploy();
    await mockMonsterBank.deployed();
    console.log("MockMonsterBank deployed to:", mockMonsterBank.address);

    const MockItemBank = await ethers.getContractFactory("MockItemBank");
    const mockItemBank = await MockItemBank.deploy();
    await mockItemBank.deployed();
    console.log("MockItemBank deployed to:", mockItemBank.address);

    MONSTER_BANK_ADDRESS = mockMonsterBank.address;
    ITEM_BANK_ADDRESS = mockItemBank.address;
  }

  // Deploy Base64 library
  console.log("\nDeploying Base64 library...");
  const Base64 = await ethers.getContractFactory("Base64");
  const base64 = await Base64.deploy();
  await base64.deployed();
  console.log("Base64 library deployed to:", base64.address);

  // Deploy TragedyArweaveComposerV2
  console.log("\nDeploying TragedyArweaveComposerV2...");
  const TragedyArweaveComposerV2 = await ethers.getContractFactory("TragedyArweaveComposerV2", {
    libraries: {
      Base64: base64.address
    }
  });
  
  const composer = await TragedyArweaveComposerV2.deploy(
    MONSTER_BANK_ADDRESS,
    ITEM_BANK_ADDRESS
  );
  await composer.deployed();
  console.log("TragedyArweaveComposerV2 deployed to:", composer.address);

  // Configure Arweave URLs (example URLs - replace with actual Arweave transaction IDs)
  console.log("\nConfiguring Arweave URLs...");
  
  const backgroundUrls = [
    "https://arweave.net/Bloodmoon-tx-id",
    "https://arweave.net/Abyss-tx-id",
    "https://arweave.net/Decay-tx-id",
    "https://arweave.net/Corruption-tx-id",
    "https://arweave.net/Venom-tx-id",
    "https://arweave.net/Void-tx-id",
    "https://arweave.net/Inferno-tx-id",
    "https://arweave.net/Frost-tx-id",
    "https://arweave.net/Ragnarok-tx-id",
    "https://arweave.net/Shadow-tx-id"
  ];

  const effectUrls = [
    "https://arweave.net/Seizure-tx-id",
    "https://arweave.net/Mindblast-tx-id",
    "https://arweave.net/Confusion-tx-id",
    "https://arweave.net/Meteor-tx-id",
    "https://arweave.net/Bats-tx-id",
    "https://arweave.net/Poisoning-tx-id",
    "https://arweave.net/Lightning-tx-id",
    "https://arweave.net/Blizzard-tx-id",
    "https://arweave.net/Burning-tx-id",
    "https://arweave.net/Brainwash-tx-id"
  ];

  // Set background URLs
  for (let i = 0; i < backgroundUrls.length; i++) {
    await composer.setBackgroundUrl(i, backgroundUrls[i]);
    console.log(`Set background URL ${i}: ${backgroundUrls[i]}`);
  }

  // Set effect URLs
  for (let i = 0; i < effectUrls.length; i++) {
    await composer.setEffectUrl(i, effectUrls[i]);
    console.log(`Set effect URL ${i}: ${effectUrls[i]}`);
  }

  console.log("\n✅ Deployment complete!");
  console.log("\nDeployment Summary:");
  console.log("===================");
  console.log("Base64 Library:", base64.address);
  console.log("TragedyArweaveComposerV2:", composer.address);
  console.log("Monster Bank:", MONSTER_BANK_ADDRESS);
  console.log("Item Bank:", ITEM_BANK_ADDRESS);
  console.log("Owner:", deployer.address);

  // Test composition
  console.log("\n🧪 Testing SVG composition...");
  try {
    const svg = await composer.composeSVG(0, 0, 0, 0);
    console.log("✅ SVG generation successful!");
    console.log("SVG length:", svg.length, "characters");
    console.log("First 200 chars:", svg.substring(0, 200) + "...");
  } catch (error) {
    console.error("❌ SVG generation failed:", error);
  }

  // Save deployment info
  const fs = require("fs");
  const deploymentInfo = {
    network: hre.network.name,
    deployer: deployer.address,
    timestamp: new Date().toISOString(),
    contracts: {
      base64Library: base64.address,
      composer: composer.address,
      monsterBank: MONSTER_BANK_ADDRESS,
      itemBank: ITEM_BANK_ADDRESS
    }
  };

  fs.writeFileSync(
    `deployment-${hre.network.name}-${Date.now()}.json`,
    JSON.stringify(deploymentInfo, null, 2)
  );
  console.log("\n📄 Deployment info saved to deployment-*.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });