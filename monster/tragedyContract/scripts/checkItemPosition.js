// Check item SVG positioning

async function main() {
    const [deployer] = await ethers.getSigners();
    
    // Get Crown contract address from deployment-result.json
    const fs = require('fs');
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    const crownAddress = deploymentData.contracts.items.Crown;
    
    console.log("Checking Crown SVG at:", crownAddress);
    
    // Get Crown contract
    const Crown = await ethers.getContractFactory("TragedyCrown");
    const crown = Crown.attach(crownAddress);
    
    // Get SVG
    const svg = await crown.getSVG();
    console.log("\nCrown SVG:");
    console.log(svg);
    
    // Extract and analyze coordinates
    const rectMatches = svg.match(/rect x="(\d+)" y="(\d+)"/g);
    if (rectMatches) {
        console.log("\nRect elements found:");
        rectMatches.forEach(match => console.log(match));
    }
    
    // Check viewBox
    const viewBoxMatch = svg.match(/viewBox="([^"]+)"/);
    if (viewBoxMatch) {
        console.log("\nViewBox:", viewBoxMatch[1]);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });