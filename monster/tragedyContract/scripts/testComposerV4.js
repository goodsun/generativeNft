const { ethers } = require("hardhat");

async function main() {
    console.log("🧪 Testing Composer V4 SVG extraction...\n");
    
    // Test SVG
    const testSVG = '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><rect x="6" y="2" width="2" height="5" fill="#4A4A4A"/></svg>';
    
    console.log("📝 Test SVG:");
    console.log(testSVG);
    console.log("\nLength:", testSVG.length);
    
    // JavaScript extraction for comparison
    const jsExtract = (svg) => {
        const startPos = svg.indexOf('>') + 1;
        const endPos = svg.lastIndexOf('</svg');
        return svg.substring(startPos, endPos);
    };
    
    const jsResult = jsExtract(testSVG);
    console.log("\n✅ JavaScript extraction result:");
    console.log(jsResult);
    console.log("Length:", jsResult.length);
    
    // Deploy and test V4
    console.log("\n🚀 Deploying Composer V4...");
    
    const deployment = require('./deployment-result.json');
    const Composer = await ethers.getContractFactory("TragedyModularSVGComposerV4");
    const composer = await Composer.deploy(
        deployment.contracts.banks.monsterBank,
        deployment.contracts.banks.backgroundBank,
        deployment.contracts.banks.itemBank,
        deployment.contracts.banks.effectBank
    );
    await composer.deployed();
    
    console.log("✅ Composer V4 deployed to:", composer.address);
    
    // Test extraction
    console.log("\n🧪 Testing Solidity extraction...");
    try {
        const solidityResult = await composer.testExtract(testSVG);
        console.log("✅ Solidity extraction result:");
        console.log(solidityResult);
        console.log("Length:", solidityResult.length);
        console.log("Match with JS:", solidityResult === jsResult);
        
        // Test actual composition
        console.log("\n🎨 Testing full composition...");
        const composed = await composer.composeSVG(0, 0, 0, 3);
        console.log("✅ Composed SVG length:", composed.length);
        console.log("First 200 chars:", composed.substring(0, 200) + "...");
        
        // Save for inspection
        const fs = require('fs');
        fs.writeFileSync('composed-v4-test.svg', composed);
        console.log("💾 Saved to: composed-v4-test.svg");
        
    } catch (error) {
        console.error("❌ Error:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });