const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying TragedyMetadataV3 with account:", deployer.address);
  
  // Get the composer address from previous deployment
  const COMPOSER_V4_ADDRESS = "0x1B63Cb565c453a84a54e6ac5fe3ac5DD2e84a30e";
  
  // Deploy TragedyMetadataV4 (optimized version)
  const TragedyMetadataV4 = await hre.ethers.getContractFactory("TragedyMetadataV4");
  const metadataV4 = await TragedyMetadataV4.deploy(COMPOSER_V4_ADDRESS);
  await metadataV4.deployed();
  
  console.log("TragedyMetadataV4 deployed to:", metadataV4.address);
  
  // Deploy MetadataBankV5 that uses TragedyMetadataV4
  const MetadataBankV5 = await hre.ethers.getContractFactory("MetadataBankV5");
  const metadataBankV5 = await MetadataBankV5.deploy(metadataV4.address);
  await metadataBankV5.deployed();
  
  console.log("MetadataBank V5 deployed to:", metadataBankV5.address);
  
  console.log("\nDeployment complete!");
  console.log("TragedyMetadataV4:", metadataV4.address);
  console.log("MetadataBank V5:", metadataBankV5.address);
  console.log("\nNext steps:");
  console.log("1. Update BankedNFT to use MetadataBank V5");
  console.log("2. Test synergy combinations");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });