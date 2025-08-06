const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Testing with account:", deployer.address);

  const metadataAddress = "0xD8a3054b94ad7f389C9ff694445970ba3c310044";
  console.log("MetadataV5:", metadataAddress);

  // Create contract instance with minimal ABI
  const abi = [
    "function composer() view returns (address)",
    "function getMetadataCount() view returns (uint256)",
    "function decodeTokenId(uint256) view returns (uint8,uint8,uint8,uint8)",
    "function getMetadata(uint256) view returns (string)"
  ];
  
  const metadata = new hre.ethers.Contract(metadataAddress, abi, deployer);
  
  try {
    // Test composer
    console.log("\nTesting composer()...");
    const composerAddr = await metadata.composer();
    console.log("Composer address:", composerAddr);
    
    // Test getMetadataCount
    console.log("\nTesting getMetadataCount()...");
    const count = await metadata.getMetadataCount();
    console.log("Metadata count:", count.toString());
    
    // Test decodeTokenId
    console.log("\nTesting decodeTokenId(1)...");
    const decoded = await metadata.decodeTokenId(1);
    console.log("Decoded values:", decoded);
    
    // Test getMetadata
    console.log("\nTesting getMetadata(0)...");
    const metadataResult = await metadata.getMetadata(0);
    console.log("Success! Metadata length:", metadataResult.length);
    console.log("First 100 chars:", metadataResult.substring(0, 100));
    
  } catch (error) {
    console.error("Error:", error.message);
    if (error.data) {
      console.error("Error data:", error.data);
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});