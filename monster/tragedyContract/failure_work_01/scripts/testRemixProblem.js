const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Testing Remix problem...\n");
    
    // V4 address
    const composerAddress = "0x183Fa3B40655abebE5cD5dB329cF97455Df73c89";
    
    // Get contract
    const composer = await ethers.getContractAt("TragedyModularSVGComposerV4", composerAddress);
    
    // Test simple call
    console.log("📝 Testing composeSVG(0, 0, 0, 3)...");
    
    try {
        // Get gas estimate first
        const gasEstimate = await composer.estimateGas.composeSVG(0, 0, 0, 3);
        console.log("⛽ Gas estimate:", gasEstimate.toString());
        
        // Call with explicit gas limit
        const result = await composer.composeSVG(0, 0, 0, 3, {
            gasLimit: gasEstimate.mul(2) // 2x safety margin
        });
        
        console.log("✅ Result length:", result.length);
        console.log("✅ First 100 chars:", result.substring(0, 100));
        
        // Test each bank individually
        console.log("\n🏦 Testing banks directly...");
        const deployment = require('./deployment-result.json');
        
        // Monster Bank
        const monsterBank = await ethers.getContractAt("IMonsterBank", deployment.contracts.banks.monsterBank);
        const monsterSVG = await monsterBank.getSpeciesSVG(0);
        console.log("Monster SVG length:", monsterSVG.length);
        
        // Background Bank
        const bgBank = await ethers.getContractAt("IBackgroundBank", deployment.contracts.banks.backgroundBank);
        const bgSVG = await bgBank.getBackgroundSVG(0);
        console.log("Background SVG length:", bgSVG.length);
        
    } catch (error) {
        console.error("❌ Error:", error);
        console.error("Error data:", error.data);
        console.error("Error reason:", error.reason);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });