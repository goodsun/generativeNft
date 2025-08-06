const { ethers } = require("hardhat");

async function main() {
    // Test a single library
    const TestLib = await ethers.getContractFactory("TestSingleLib");
    const test = await TestLib.deploy();
    await test.deployed();
    
    console.log("Getting Demon SVG...");
    const svg = await test.getDemonSVG();
    
    console.log("\n=== SVG Output ===");
    console.log("Length:", svg.length);
    console.log("\nFirst 500 chars:");
    console.log(svg.substring(0, 500));
    console.log("\n...truncated...");
    
    // Write to HTML file for visual inspection
    const fs = require('fs');
    const html = `<!DOCTYPE html>
<html>
<head><title>Demon SVG Test</title></head>
<body style="background: #333; padding: 50px;">
    <div style="background: white; padding: 20px; display: inline-block;">
        ${svg}
    </div>
</body>
</html>`;
    
    fs.writeFileSync('demon-test.html', html);
    console.log("\n✅ HTML file created: demon-test.html");
}

main().catch(console.error);