const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Redeploying MetadataV5 with the account:", deployer.address);

  // Load current deployment
  const deployment = JSON.parse(fs.readFileSync("viewer/deployment.json", "utf8"));
  
  console.log("Using existing ComposerV5:", deployment.contracts.composerV5);

  // Deploy new MetadataV5 with JSON comma fix
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

  // Test the new deployment
  console.log("\nTesting new deployment...");
  try {
    const metadata = await metadataV5.getMetadata(0);
    console.log("✓ getMetadata(0) works! Length:", metadata.length);
    
    // Parse and validate JSON
    if (metadata.startsWith("data:application/json;base64,")) {
      const base64Data = metadata.substring(29);
      const jsonData = Buffer.from(base64Data, 'base64').toString('utf-8');
      try {
        JSON.parse(jsonData);
        console.log("✓ JSON is valid!");
      } catch (e) {
        console.error("✗ JSON is still invalid:", e.message);
        console.error("JSON:", jsonData);
      }
    }
  } catch (e) {
    console.error("✗ getMetadata(0) still fails:", e.message);
  }

  // Update deployment.json
  deployment.contracts.metadataV5 = metadataV5Address;
  deployment.timestamp = new Date().toISOString();
  deployment.note = "Fixed JSON comma issue in MetadataV5";
  
  fs.writeFileSync("viewer/deployment.json", JSON.stringify(deployment, null, 2));
  console.log("deployment.json updated");

  console.log("\n=== DEPLOYMENT COMPLETE ===");
  console.log("MetadataV5:", metadataV5Address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});