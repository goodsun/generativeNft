const hre = require("hardhat");
const fs = require("fs");

async function main() {
  console.log("🚀 Deploying ALL NEW Tragedy NFT Contracts...\n");

  // Get deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const deploymentInfo = {
    network: hre.network.name,
    deployer: deployer.address,
    timestamp: new Date().toISOString(),
    contracts: {}
  };

  try {
    // Step 1: Deploy Base64 library
    console.log("\n📚 Step 1: Deploying Base64 library...");
    const Base64 = await ethers.getContractFactory("contracts/libraries/Base64.sol:Base64");
    const base64 = await Base64.deploy();
    await base64.deployed();
    console.log("✅ Base64 library deployed to:", base64.address);
    deploymentInfo.contracts.base64Library = base64.address;

    // Step 2: Deploy Monster Bank
    console.log("\n👾 Step 2: Deploying ArweaveMonsterBank...");
    const ArweaveMonsterBank = await ethers.getContractFactory("ArweaveMonsterBank");
    const monsterBank = await ArweaveMonsterBank.deploy();
    await monsterBank.deployed();
    console.log("✅ ArweaveMonsterBank deployed to:", monsterBank.address);
    deploymentInfo.contracts.monsterBank = monsterBank.address;

    // Step 3: Deploy Item Bank
    console.log("\n⚔️ Step 3: Deploying ArweaveItemBank...");
    const ArweaveItemBank = await ethers.getContractFactory("ArweaveItemBank");
    const itemBank = await ArweaveItemBank.deploy();
    await itemBank.deployed();
    console.log("✅ ArweaveItemBank deployed to:", itemBank.address);
    deploymentInfo.contracts.itemBank = itemBank.address;

    // Step 4: Deploy Background Bank
    console.log("\n🌍 Step 4: Deploying ArweaveBackgroundBank...");
    const ArweaveBackgroundBank = await ethers.getContractFactory("ArweaveBackgroundBank");
    const backgroundBank = await ArweaveBackgroundBank.deploy();
    await backgroundBank.deployed();
    console.log("✅ ArweaveBackgroundBank deployed to:", backgroundBank.address);
    deploymentInfo.contracts.backgroundBank = backgroundBank.address;

    // Step 5: Deploy Effect Bank
    console.log("\n✨ Step 5: Deploying ArweaveEffectBank...");
    const ArweaveEffectBank = await ethers.getContractFactory("ArweaveEffectBank");
    const effectBank = await ArweaveEffectBank.deploy();
    await effectBank.deployed();
    console.log("✅ ArweaveEffectBank deployed to:", effectBank.address);
    deploymentInfo.contracts.effectBank = effectBank.address;

    // Step 6: Deploy Composer
    console.log("\n🎨 Step 6: Deploying ArweaveTragedyComposer...");
    const ArweaveTragedyComposer = await ethers.getContractFactory("ArweaveTragedyComposer");
    
    const composer = await ArweaveTragedyComposer.deploy(
      monsterBank.address,
      itemBank.address,
      backgroundBank.address,
      effectBank.address
    );
    await composer.deployed();
    console.log("✅ ArweaveTragedyComposer deployed to:", composer.address);
    deploymentInfo.contracts.composer = composer.address;

    // Step 7: Test the deployment
    console.log("\n🧪 Step 7: Testing deployment...");
    
    // Test Monster Bank
    console.log("\n  Testing MonsterBank...");
    const werewolfSvg = await monsterBank.getSpeciesSVG(0);
    console.log("  - Werewolf SVG length:", werewolfSvg.length);
    const werewolfName = await monsterBank.getMonsterName(0);
    console.log("  - Werewolf name:", werewolfName);

    // Test Item Bank
    console.log("\n  Testing ItemBank...");
    const crownSvg = await itemBank.getItemSVG(0);
    console.log("  - Crown SVG length:", crownSvg.length);
    const crownName = await itemBank.getItemName(0);
    console.log("  - Crown name:", crownName);

    // Test Background Bank
    console.log("\n  Testing BackgroundBank...");
    const bloodmoonUrl = await backgroundBank.getBackgroundUrl(0);
    console.log("  - Bloodmoon URL:", bloodmoonUrl);
    const bloodmoonName = await backgroundBank.getBackgroundName(0);
    console.log("  - Bloodmoon name:", bloodmoonName);

    // Test Effect Bank
    console.log("\n  Testing EffectBank...");
    const seizureUrl = await effectBank.getEffectUrl(0);
    console.log("  - Seizure URL:", seizureUrl);
    const seizureName = await effectBank.getEffectName(0);
    console.log("  - Seizure name:", seizureName);

    // Test Composer
    console.log("\n  Testing Composer...");
    const composedSvg = await composer.composeSVG(0, 0, 0, 0);
    console.log("  - Composed SVG length:", composedSvg.length);
    console.log("  - First 200 chars:", composedSvg.substring(0, 200) + "...");
    
    // Check filter params
    const filterParams = await composer.filterParams(0);
    console.log("  - Bloodmoon filter params:");
    console.log("    - Hue Rotate:", filterParams.hueRotate);
    console.log("    - Saturate:", filterParams.saturate);
    console.log("    - Brightness:", filterParams.brightness);

    console.log("\n✅ All tests passed!");

    // Save deployment info
    const filename = `deployment-${hre.network.name}-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(deploymentInfo, null, 2));
    console.log(`\n📄 Deployment info saved to ${filename}`);

    // Print summary
    console.log("\n" + "=".repeat(60));
    console.log("DEPLOYMENT SUMMARY");
    console.log("=".repeat(60));
    console.log("Network:", hre.network.name);
    console.log("Deployer:", deployer.address);
    console.log("\nContract Addresses:");
    console.log("  Base64 Library:    ", base64.address);
    console.log("  Monster Bank:      ", monsterBank.address);
    console.log("  Item Bank:         ", itemBank.address);
    console.log("  Background Bank:   ", backgroundBank.address);
    console.log("  Effect Bank:       ", effectBank.address);
    console.log("  Composer:          ", composer.address);
    console.log("=".repeat(60));

    console.log("\n⚠️  IMPORTANT NEXT STEPS:");
    console.log("1. Upload actual background SVGs to Arweave");
    console.log("2. Upload actual effect SVGs to Arweave");
    console.log("3. Update BackgroundBank with real Arweave URLs");
    console.log("4. Update EffectBank with real Arweave URLs");
    console.log("5. Deploy NFT contract using this composer");

    // Example command for updating URLs
    console.log("\n📝 Example commands for updating URLs:");
    console.log(`
// Update single URL
await backgroundBank.setBackgroundUrl(0, "https://arweave.net/actual-bloodmoon-tx-id");

// Batch update URLs
await backgroundBank.setMultipleUrls(
  [0, 1, 2, 3, 4],
  [
    "https://arweave.net/bloodmoon-tx",
    "https://arweave.net/abyss-tx",
    "https://arweave.net/decay-tx",
    "https://arweave.net/corruption-tx",
    "https://arweave.net/venom-tx"
  ]
);
    `);

  } catch (error) {
    console.error("\n❌ Deployment failed:", error);
    throw error;
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });