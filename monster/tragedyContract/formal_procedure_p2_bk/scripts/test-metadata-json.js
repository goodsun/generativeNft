const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Testing with account:", deployer.address);

  const metadataAddress = "0x4ED9c3b8d35536974C7D0058F67342Bee6F32e26";
  console.log("MetadataV5:", metadataAddress);

  const metadata = new hre.ethers.Contract(metadataAddress, [
    "function getMetadata(uint256) view returns (string)",
    "function decodeTokenId(uint256) view returns (uint8,uint8,uint8,uint8)"
  ], deployer);
  
  // Test a few different indices
  const testIndices = [0, 1, 100, 500, 1000];
  
  for (const index of testIndices) {
    console.log(`\n=== Testing index ${index} ===`);
    
    try {
      const metadataResult = await metadata.getMetadata(index);
      
      // Extract base64 data
      if (metadataResult.startsWith("data:application/json;base64,")) {
        const base64Data = metadataResult.substring(29);
        const jsonData = Buffer.from(base64Data, 'base64').toString('utf-8');
        
        // Try to parse JSON
        try {
          const parsed = JSON.parse(jsonData);
          console.log("✓ Valid JSON");
          console.log("Name:", parsed.name);
          console.log("Attributes:", parsed.attributes.length);
          
          // Check for double commas
          if (jsonData.includes(",,")) {
            console.log("⚠️  WARNING: Double comma found in JSON!");
            const doubleCommaIndex = jsonData.indexOf(",,");
            console.log("Context:", jsonData.substring(doubleCommaIndex - 20, doubleCommaIndex + 20));
          }
        } catch (e) {
          console.log("✗ Invalid JSON:", e.message);
          console.log("Raw JSON:", jsonData);
          
          // Find the error location
          const match = e.message.match(/position (\d+)/);
          if (match) {
            const pos = parseInt(match[1]);
            console.log("Error context:", jsonData.substring(pos - 50, pos + 50));
          }
        }
      }
      
      // Decode token ID to understand the combination
      const tokenId = index + 1;
      const decoded = await metadata.decodeTokenId(tokenId);
      console.log("Combination - Species:", decoded[0], "Background:", decoded[1], "Item:", decoded[2], "Effect:", decoded[3]);
      
    } catch (error) {
      console.error("Error at index", index, ":", error.message);
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});