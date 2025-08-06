// Test Composer V5 composition directly

const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {
    // Load deployment data
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    
    // Get composer addresses
    const composerV4Address = deploymentData.contracts.composerV4;
    const composerV5Address = deploymentData.contracts.composerV5;
    
    console.log("Composer V4:", composerV4Address);
    console.log("Composer V5:", composerV5Address);
    
    // Get contract instances
    const ComposerV4 = await ethers.getContractFactory("TragedyModularSVGComposerV4");
    const composerV4 = ComposerV4.attach(composerV4Address);
    
    const ComposerV5 = await ethers.getContractFactory("TragedyModularSVGComposerV5");
    const composerV5 = ComposerV5.attach(composerV5Address);
    
    // Test composition with effect that has defs (Meteor = 3)
    console.log("\nTesting with Meteor effect (has defs)...");
    
    try {
        console.log("\n--- Composer V4 Output ---");
        const svgV4 = await composerV4.composeSVG(0, 0, 0, 3);
        console.log("Length:", svgV4.length);
        console.log("Has <defs>:", svgV4.includes("<defs>"));
        console.log("Has </defs>:", svgV4.includes("</defs>"));
        
        // Save V4 output
        fs.writeFileSync('./test-v4.svg', svgV4);
        
        console.log("\n--- Composer V5 Output ---");
        const svgV5 = await composerV5.composeSVG(0, 0, 0, 3);
        console.log("Length:", svgV5.length);
        console.log("Has <defs>:", svgV5.includes("<defs>"));
        console.log("Has </defs>:", svgV5.includes("</defs>"));
        
        // Check structure
        const defsStart = svgV5.indexOf("<defs>");
        const defsEnd = svgV5.indexOf("</defs>");
        const bgStart = svgV5.indexOf("#1A0000"); // Bloodmoon color
        
        console.log("\nPositions:");
        console.log("defs start:", defsStart);
        console.log("defs end:", defsEnd);
        console.log("background start:", bgStart);
        
        if (defsEnd > 0 && bgStart > defsEnd) {
            console.log("✓ Background is after defs (correct)");
        } else {
            console.log("✗ Background position is wrong");
        }
        
        // Save V5 output
        fs.writeFileSync('./test-v5.svg', svgV5);
        
        console.log("\nOutputs saved to test-v4.svg and test-v5.svg");
        
    } catch (error) {
        console.error("Error:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });