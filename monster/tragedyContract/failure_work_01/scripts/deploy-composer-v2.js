const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying ArweaveTragedyComposerV2 (Fixed Base64)...\n");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  // Use existing bank addresses
  const MONSTER_BANK = "0xD7C12a83a3d4fBf5285bB6F668f517eE131081FE";
  const ITEM_BANK = "0xa0c9178E06d3872509a5bD96D66F8B5d14182521";
  const BACKGROUND_BANK = "0xdab2daE6338cA3b69dE67ee60Bd7C99fBD870E38";
  const EFFECT_BANK = "0x32F4B2b7F1e40a9323e75929761182ce0afB0CC9";

  console.log("Using existing banks:");
  console.log("  Monster Bank:", MONSTER_BANK);
  console.log("  Item Bank:", ITEM_BANK);
  console.log("  Background Bank:", BACKGROUND_BANK);
  console.log("  Effect Bank:", EFFECT_BANK);

  // Deploy new composer
  console.log("\n🎨 Deploying ArweaveTragedyComposerV2...");
  const ArweaveTragedyComposerV2 = await ethers.getContractFactory("ArweaveTragedyComposerV2");
  
  const composer = await ArweaveTragedyComposerV2.deploy(
    MONSTER_BANK,
    ITEM_BANK,
    BACKGROUND_BANK,
    EFFECT_BANK
  );
  await composer.deployed();
  console.log("✅ ArweaveTragedyComposerV2 deployed to:", composer.address);

  // Test the new composer
  console.log("\n🧪 Testing new composer...");
  const svg = await composer.composeSVG(1, 1, 1, 1);
  console.log("Generated SVG length:", svg.length);
  
  // Check if base64 is properly formatted
  const base64Match = svg.match(/data:image\/svg\+xml;base64,([A-Za-z0-9+/=]+)/g);
  console.log("Base64 data URIs found:", base64Match ? base64Match.length : 0);
  
  if (base64Match && base64Match.length > 0) {
    // Try to decode first base64
    const firstBase64 = base64Match[0].split(',')[1];
    try {
      const decoded = Buffer.from(firstBase64, 'base64').toString('utf8');
      console.log("First base64 decoded successfully!");
      console.log("Decoded content starts with:", decoded.substring(0, 50) + "...");
    } catch (e) {
      console.error("Failed to decode base64:", e.message);
    }
  }

  console.log("\n✅ Deployment complete!");
  console.log("\n📋 New Composer Address:", composer.address);
  console.log("\n💡 Update your viewer HTML with this new address!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });