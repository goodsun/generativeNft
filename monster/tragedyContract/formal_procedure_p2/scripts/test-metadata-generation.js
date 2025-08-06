const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Testing with account:", deployer.address);

  const metadataAddress = "0xD8a3054b94ad7f389C9ff694445970ba3c310044";
  const composerAddress = "0x32f2f311D444FbEe826EdB8094c4a32BaaEFfE62";
  
  console.log("MetadataV5:", metadataAddress);
  console.log("ComposerV5:", composerAddress);

  // Test the specific failing call from MetadataV5
  const composerAbi = [
    "function composeSVG(uint8,uint8,uint8,uint8) view returns (string)",
    "function filterParams(uint8) view returns (uint16,uint16,uint16)",
    "function monsterBank() view returns (address)",
    "function backgroundBank() view returns (address)",
    "function itemBank() view returns (address)",
    "function effectBank() view returns (address)"
  ];
  
  const composer = new hre.ethers.Contract(composerAddress, composerAbi, deployer);
  
  // Decode token ID 1 (which is index 0)
  const tokenId = 1;
  const seed = hre.ethers.BigNumber.from(hre.ethers.utils.solidityKeccak256(["uint256"], [tokenId]));
  const species = seed.mod(10).toNumber();
  const background = seed.shr(8).mod(10).toNumber();
  const item = seed.shr(16).mod(10).toNumber();
  const effect = seed.shr(24).mod(10).toNumber();
  
  console.log("\nDecoded tokenId 1:");
  console.log("Species:", species);
  console.log("Background:", background);
  console.log("Item:", item);
  console.log("Effect:", effect);
  
  // Test filterParams for this background
  console.log("\nTesting filterParams for background", background);
  try {
    const params = await composer.filterParams(background);
    console.log("✓ Filter params:", params[0].toString(), params[1].toString(), params[2].toString());
  } catch (e) {
    console.log("✗ Filter params error:", e.message);
    
    // Test all backgrounds to see which work
    console.log("\nTesting all backgrounds 0-9:");
    for (let i = 0; i < 10; i++) {
      try {
        const params = await composer.filterParams(i);
        console.log(`✓ Background ${i}: ${params[0]}, ${params[1]}, ${params[2]}`);
      } catch (e2) {
        console.log(`✗ Background ${i}: failed`);
      }
    }
  }
  
  // Test the full metadata generation path
  console.log("\nTesting full metadata generation...");
  const metadata = new hre.ethers.Contract(metadataAddress, [
    "function generateMetadata(uint256,uint8,uint8,uint8,uint8) view returns (string)"
  ], deployer);
  
  try {
    const result = await metadata.generateMetadata(tokenId, species, background, item, effect);
    console.log("✓ Metadata generated successfully!");
    console.log("Length:", result.length);
    
    // Parse and display the metadata
    if (result.startsWith("data:application/json;base64,")) {
      const base64Data = result.substring(29);
      const jsonData = Buffer.from(base64Data, 'base64').toString('utf-8');
      const parsed = JSON.parse(jsonData);
      console.log("\nMetadata:");
      console.log("Name:", parsed.name);
      console.log("Description:", parsed.description);
      console.log("Attributes:");
      parsed.attributes.forEach(attr => {
        console.log(`  ${attr.trait_type}: ${attr.value}`);
      });
    }
  } catch (e) {
    console.log("✗ Metadata generation error:", e.message);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});