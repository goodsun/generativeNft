const hre = require("hardhat");

async function main() {
  console.log("🔄 Updating Arweave URLs...\n");

  const [deployer] = await ethers.getSigners();
  console.log("Updating with account:", deployer.address);

  // Contract addresses from deployment
  const BACKGROUND_BANK = "0xdab2daE6338cA3b69dE67ee60Bd7C99fBD870E38";
  const EFFECT_BANK = "0x32F4B2b7F1e40a9323e75929761182ce0afB0CC9";

  // Actual Arweave URLs
  const backgroundUrls = {
    0: "https://arweave.net/XeooYFmf_rvME-cLCDB-E-F1fOrdUiTSGOoz1q_lONI", // bloodmoon
    1: "https://arweave.net/7f4Xexbjb24aOw2z4soba6zaAeYQSWkr1pYAKkZ5h7c", // abyss
    2: "https://arweave.net/NBKiR7O_jrBddYDNvdIMfW7t0sc5aIiXuy508WfwPh4", // decay
    3: "https://arweave.net/xFCvtZudtVi8G1ZBSrv59928Xuf68bqtb5z2kDQx50Y", // corruption
    4: "https://arweave.net/fT6SUmXAD1DLbVzNkQuKTiN65l-TlPwI6CGXZiZzeIo", // venom
    5: "https://arweave.net/ca3HmME0N1wayBzp03TU9hACYAriGsdd3jURVXhfXHw", // void
    6: "https://arweave.net/0iMntcJN_7P07V4T5euOk9uVEzhqvoC6vRIxAnCV48U", // inferno
    7: "https://arweave.net/bA-7-CU4rveHGA9usO6_TEVucSm1vk6t9-6CPB-0PSQ", // frost
    8: "https://arweave.net/uNVu9Pori_7pEFJ1-WaNg_h3QT0ISdHQf0B_MAXZkgo", // ragnarok
    9: "https://arweave.net/-ZaY-UbqeGLe99zTv1SuFQi39frnTmTDn_g5noQ4bmI"  // shadow
  };

  const effectUrls = {
    0: "https://arweave.net/8szL-F1P2dHg3XLlYA5EXf3BVzQGfeH_CF_B-MjuNE4", // seizure
    1: "https://arweave.net/DdiqAGyJ4XDW1EFdgKBXo6fStbW-Ks2Y3f3AM96A2A0", // mindblast
    2: "https://arweave.net/1-QnPkLT5KI7eQD420wrB3m7n9hXj77rTpanb5773A0", // confusion
    3: "https://arweave.net/TdHsWKEvCIaKhgUcaGVpbs5bLE2V5metBywUhN81Ay4", // meteor
    4: "https://arweave.net/gj9yctWGFj2QhsNxLIFdtPLedkZxz460wVjdc3DwKko", // bats
    5: "https://arweave.net/aIAfVjyQEPzqqn6OtABZzFJg2yYSUWdet3Zt0EAzPnQ", // poisoning
    6: "https://arweave.net/23iGDqX0Uok653Hy3oo1o_Y-haNnzcHMW1LPmOi8IwI", // lightning
    7: "https://arweave.net/dQ5Y3zR80WV6KNnoh214zRk--xEdnMdKtDxI-YMGITM", // blizzard
    8: "https://arweave.net/5dC56SGjfZd29Jb_NIlwcUBYtm0VrkE1q53EsN52ZTA", // burning
    9: "https://arweave.net/M2iMAG1UD9QpqF9OkkUrK56LlLmjhFaeN0fqSyUxPvU"  // brainwash
  };

  // Get contract instances
  const BackgroundBank = await ethers.getContractFactory("ArweaveBackgroundBank");
  const backgroundBank = BackgroundBank.attach(BACKGROUND_BANK);

  const EffectBank = await ethers.getContractFactory("ArweaveEffectBank");
  const effectBank = EffectBank.attach(EFFECT_BANK);

  // Update Background URLs
  console.log("📸 Updating Background URLs...");
  const bgIds = Object.keys(backgroundUrls).map(k => parseInt(k));
  const bgUrls = bgIds.map(id => backgroundUrls[id]);
  
  const bgTx = await backgroundBank.setMultipleUrls(bgIds, bgUrls);
  console.log("Transaction hash:", bgTx.hash);
  await bgTx.wait();
  console.log("✅ Background URLs updated!");

  // Update Effect URLs
  console.log("\n✨ Updating Effect URLs...");
  const effectIds = Object.keys(effectUrls).map(k => parseInt(k));
  const effUrls = effectIds.map(id => effectUrls[id]);
  
  const effTx = await effectBank.setMultipleUrls(effectIds, effUrls);
  console.log("Transaction hash:", effTx.hash);
  await effTx.wait();
  console.log("✅ Effect URLs updated!");

  // Verify updates
  console.log("\n🔍 Verifying updates...");
  const bloodmoonUrl = await backgroundBank.getBackgroundUrl(0);
  console.log("Bloodmoon URL:", bloodmoonUrl);
  
  const seizureUrl = await effectBank.getEffectUrl(0);
  console.log("Seizure URL:", seizureUrl);

  console.log("\n✅ All URLs updated successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });