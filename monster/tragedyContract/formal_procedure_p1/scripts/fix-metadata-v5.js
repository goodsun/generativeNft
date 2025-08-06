const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying MetadataV5 with the account:", deployer.address);

  // Load current deployment
  const deployment = JSON.parse(fs.readFileSync("viewer/deployment.json", "utf8"));
  
  console.log("Using existing ComposerV5:", deployment.contracts.composerV5);

  // Deploy new MetadataV5 with correct import
  const MetadataV5 = await hre.ethers.getContractFactory("TragedyMetadataV5");
  const metadataV5 = await MetadataV5.deploy(deployment.contracts.composerV5);
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
  deployment.contracts.metadataV5 = metadataV5Address;
  deployment.timestamp = new Date().toISOString();
  deployment.note = "Fixed MetadataV5 import (V5 instead of V4)";
  
  fs.writeFileSync("viewer/deployment.json", JSON.stringify(deployment, null, 2));
  console.log("deployment.json updated");

  console.log("\n=== DEPLOYMENT COMPLETE ===");
  console.log("MetadataV5:", metadataV5Address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});