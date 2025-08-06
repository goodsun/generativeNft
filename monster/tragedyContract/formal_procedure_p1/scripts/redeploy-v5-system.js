const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Redeploying V5 system with the account:", deployer.address);

  // Load current deployment
  const deployment = JSON.parse(fs.readFileSync("viewer/deployment.json", "utf8"));
  
  console.log("Using banks:");
  console.log("- MonsterBankV3:", deployment.contracts.monsterBankV3);
  console.log("- BackgroundBank:", deployment.contracts.backgroundBank);
  console.log("- ItemBankV3:", deployment.contracts.itemBankV3);
  console.log("- EffectBank:", deployment.contracts.effectBank);

  // Deploy new ArweaveTragedyComposerV5
  const ComposerV5 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV5");
  const composerV5 = await ComposerV5.deploy(
    deployment.contracts.monsterBankV3,
    deployment.contracts.backgroundBank,
    deployment.contracts.itemBankV3,
    deployment.contracts.effectBank
  );
  await composerV5.deployed();
  const composerV5Address = composerV5.address;
  console.log("ArweaveTragedyComposerV5 deployed to:", composerV5Address);

  // Verify filterParams were initialized
  console.log("\nVerifying filterParams initialization...");
  try {
    const params0 = await composerV5.filterParams(0);
    console.log("Background 0 (Bloodmoon):", params0[0].toString(), params0[1].toString(), params0[2].toString());
  } catch (e) {
    console.error("Failed to read filterParams!");
  }

  // Deploy new MetadataV5 with the new composer
  const MetadataV5 = await hre.ethers.getContractFactory("TragedyMetadataV5");
  const metadataV5 = await MetadataV5.deploy(composerV5Address);
  await metadataV5.deployed();
  const metadataV5Address = metadataV5.address;
  console.log("TragedyMetadataV5 deployed to:", metadataV5Address);

  // Update BankedNFT to use the new metadata
  const bankedNFT = await hre.ethers.getContractAt("BankedNFT", deployment.contracts.bankedNFT);
  console.log("Setting metadata bank on BankedNFT...");
  const tx = await bankedNFT.setMetadataBank(metadataV5Address);
  await tx.wait();
  console.log("BankedNFT metadata bank updated to:", metadataV5Address);

  // Test the new deployment
  console.log("\nTesting new deployment...");
  try {
    const metadata = await metadataV5.getMetadata(0);
    console.log("✓ getMetadata(0) works! Length:", metadata.length);
  } catch (e) {
    console.error("✗ getMetadata(0) still fails:", e.message);
  }

  // Update deployment.json
  deployment.contracts.composerV5 = composerV5Address;
  deployment.contracts.metadataV5 = metadataV5Address;
  deployment.timestamp = new Date().toISOString();
  deployment.note = "Redeployed V5 system with proper initialization";
  
  fs.writeFileSync("viewer/deployment.json", JSON.stringify(deployment, null, 2));
  console.log("deployment.json updated");

  console.log("\n=== DEPLOYMENT COMPLETE ===");
  console.log("ComposerV5:", composerV5Address);
  console.log("MetadataV5:", metadataV5Address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});