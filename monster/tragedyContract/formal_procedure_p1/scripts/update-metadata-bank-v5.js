const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Updating MetadataBank with account:", deployer.address);
  
  // Contract addresses
  const BANKED_NFT_ADDRESS = "0x930Fc003DD8989E8d64b9Bba7673180C369178C5";
  const METADATA_BANK_V5_ADDRESS = "0xe2c75EfF8d193E03170B580AC06E2b2E13E0AC27";
  
  // Get BankedNFT contract
  const BankedNFT = await hre.ethers.getContractFactory("BankedNFT");
  const bankedNFT = BankedNFT.attach(BANKED_NFT_ADDRESS);
  
  // Update MetadataBank
  console.log("Setting MetadataBank to V5:", METADATA_BANK_V5_ADDRESS);
  const tx = await bankedNFT.setMetadataBank(METADATA_BANK_V5_ADDRESS);
  await tx.wait();
  
  console.log("MetadataBank updated successfully!");
  
  // Verify the update
  const currentMetadataBank = await bankedNFT.metadataBank();
  console.log("Current MetadataBank:", currentMetadataBank);
  
  if (currentMetadataBank.toLowerCase() === METADATA_BANK_V5_ADDRESS.toLowerCase()) {
    console.log("✅ MetadataBank successfully updated to V5 with synergy system!");
  } else {
    console.log("❌ MetadataBank update failed!");
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });