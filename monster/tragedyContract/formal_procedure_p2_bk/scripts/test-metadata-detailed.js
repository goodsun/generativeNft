const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Testing with account:", deployer.address);

  const metadataAddress = "0xD8a3054b94ad7f389C9ff694445970ba3c310044";
  console.log("MetadataV5:", metadataAddress);

  // Get contracts
  const metadata = await hre.ethers.getContractAt("TragedyMetadataV5", metadataAddress);
  const composerAddr = await metadata.composer();
  const composer = await hre.ethers.getContractAt("ArweaveTragedyComposerV5", composerAddr);
  
  console.log("Composer:", composerAddr);

  // Test specific index that's failing
  const testIndex = 7019; // 0x1b6b
  console.log("\nTesting index:", testIndex);
  
  try {
    // Decode token ID
    const tokenId = testIndex + 1;
    console.log("Token ID:", tokenId);
    
    const decoded = await metadata.decodeTokenId(tokenId);
    console.log("Decoded values:");
    console.log("- Species:", decoded.species.toString());
    console.log("- Background:", decoded.background.toString());
    console.log("- Item:", decoded.item.toString());
    console.log("- Effect:", decoded.effect.toString());
    
    // Test each bank individually
    const banks = await Promise.all([
      composer.monsterBank(),
      composer.backgroundBank(),
      composer.itemBank(),
      composer.effectBank()
    ]);
    
    console.log("\nBank addresses:");
    console.log("- MonsterBank:", banks[0]);
    console.log("- BackgroundBank:", banks[1]);
    console.log("- ItemBank:", banks[2]);
    console.log("- EffectBank:", banks[3]);
    
    // Test each getName call
    console.log("\nTesting getName calls:");
    
    try {
      const monsterBank = await hre.ethers.getContractAt("IMonsterBank", banks[0]);
      const monsterName = await monsterBank.getMonsterName(decoded.species);
      console.log("✓ Monster name:", monsterName);
    } catch (e) {
      console.log("✗ Monster name error:", e.message);
    }
    
    try {
      const backgroundBank = await hre.ethers.getContractAt("IBackgroundBank", banks[1]);
      const backgroundName = await backgroundBank.getBackgroundName(decoded.background);
      console.log("✓ Background name:", backgroundName);
    } catch (e) {
      console.log("✗ Background name error:", e.message);
    }
    
    try {
      const itemBank = await hre.ethers.getContractAt("IItemBank", banks[2]);
      const itemName = await itemBank.getItemName(decoded.item);
      console.log("✓ Item name:", itemName);
    } catch (e) {
      console.log("✗ Item name error:", e.message);
    }
    
    try {
      const effectBank = await hre.ethers.getContractAt("IEffectBank", banks[3]);
      const effectName = await effectBank.getEffectName(decoded.effect);
      console.log("✓ Effect name:", effectName);
    } catch (e) {
      console.log("✗ Effect name error:", e.message);
    }
    
    // Test composeSVG
    console.log("\nTesting composeSVG:");
    try {
      const svg = await composer.composeSVG(
        decoded.species,
        decoded.background,
        decoded.item,
        decoded.effect
      );
      console.log("✓ SVG generated, length:", svg.length);
    } catch (e) {
      console.log("✗ ComposeSVG error:", e.message);
    }
    
    // Finally test getMetadata
    console.log("\nTesting getMetadata:");
    try {
      const metadataResult = await metadata.getMetadata(testIndex);
      console.log("✓ Success! Metadata length:", metadataResult.length);
    } catch (e) {
      console.log("✗ GetMetadata error:", e.message);
    }
    
  } catch (error) {
    console.error("Error:", error);
  }
}

// Define minimal interfaces
const IMonsterBankABI = [
  "function getMonsterName(uint8 id) view returns (string)"
];

const IBackgroundBankABI = [
  "function getBackgroundName(uint8 id) view returns (string)"
];

const IItemBankABI = [
  "function getItemName(uint8 id) view returns (string)"
];

const IEffectBankABI = [
  "function getEffectName(uint8 id) view returns (string)"
];

// Register ABIs
hre.ethers.utils.Interface.getAbiCoder()._getCoder = function(param) {
  if (param.type === "IMonsterBank") return IMonsterBankABI;
  if (param.type === "IBackgroundBank") return IBackgroundBankABI;
  if (param.type === "IItemBank") return IItemBankABI;
  if (param.type === "IEffectBank") return IEffectBankABI;
  return this._getCoder.call(this, param);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});