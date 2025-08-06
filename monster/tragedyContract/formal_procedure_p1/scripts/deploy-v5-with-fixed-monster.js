const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Fixed Monster Bank V3 with Succubus fix
  const FIXED_MONSTER_BANK_V3 = "0x315A5C0FEf9fB193e2EaF4eE22D112DEC98A386F";
  
  // Load current deployment
  const deployment = JSON.parse(fs.readFileSync("viewer/deployment.json", "utf8"));
  
  console.log("Using banks:");
  console.log("- MonsterBankV3 (FIXED):", FIXED_MONSTER_BANK_V3);
  console.log("- BackgroundBank:", deployment.contracts.backgroundBank);
  console.log("- ItemBankV3:", deployment.contracts.itemBankV3);
  console.log("- EffectBank:", deployment.contracts.effectBank);

  // Deploy ArweaveTragedyComposerV5 with fixed MonsterBankV3
  const ComposerV5 = await hre.ethers.getContractFactory("ArweaveTragedyComposerV5");
  const composerV5 = await ComposerV5.deploy(
    FIXED_MONSTER_BANK_V3,  // Use the fixed MonsterBankV3
    deployment.contracts.backgroundBank,
    deployment.contracts.itemBankV3,
    deployment.contracts.effectBank
  );
  await composerV5.deployed();
  const composerV5Address = composerV5.address;
  console.log("ArweaveTragedyComposerV5 deployed to:", composerV5Address);

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

  // Update deployment.json
  deployment.contracts.composerV5 = composerV5Address;
  deployment.contracts.metadataV5 = metadataV5Address;
  deployment.contracts.monsterBankV3 = FIXED_MONSTER_BANK_V3;  // Update to fixed version
  deployment.timestamp = new Date().toISOString();
  deployment.note = "V5 system with fixed MonsterBankV3 (Succubus fix)";
  
  fs.writeFileSync("viewer/deployment.json", JSON.stringify(deployment, null, 2));
  console.log("deployment.json updated");

  console.log("\n=== DEPLOYMENT COMPLETE ===");
  console.log("ComposerV5:", composerV5Address);
  console.log("MetadataV5:", metadataV5Address);
  console.log("MonsterBankV3 (FIXED):", FIXED_MONSTER_BANK_V3);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});