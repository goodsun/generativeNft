// Check all item SVG positioning

async function main() {
    const [deployer] = await ethers.getSigners();
    
    // Load deployment data
    const fs = require('fs');
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    const itemAddresses = deploymentData.contracts.items;
    
    const abi = ["function getSVG() external pure returns (string memory)"];
    
    for (const [itemName, address] of Object.entries(itemAddresses)) {
        console.log(`\n=== ${itemName} ===`);
        console.log(`Address: ${address}`);
        
        const item = new ethers.Contract(address, abi, deployer);
        const svg = await item.getSVG();
        
        // Extract rect coordinates
        const rectPattern = /<rect[^>]*x="([^"]*)"[^>]*y="([^"]*)"[^>]*>/g;
        let match;
        const coords = [];
        while ((match = rectPattern.exec(svg)) !== null) {
            coords.push({ x: parseFloat(match[1]), y: parseFloat(match[2]) });
        }
        
        if (coords.length > 0) {
            const avgX = coords.reduce((sum, c) => sum + c.x, 0) / coords.length;
            const avgY = coords.reduce((sum, c) => sum + c.y, 0) / coords.length;
            const minY = Math.min(...coords.map(c => c.y));
            const maxY = Math.max(...coords.map(c => c.y));
            
            console.log(`Average position: x=${avgX.toFixed(1)}, y=${avgY.toFixed(1)}`);
            console.log(`Y range: ${minY} to ${maxY}`);
            
            // Categorize position
            if (avgY < 8) console.log("Position: TOP (head area)");
            else if (avgY < 16) console.log("Position: MIDDLE (body area)");
            else console.log("Position: BOTTOM (feet area)");
        }
        
        // Also check for circle elements (some items might use circles)
        const circlePattern = /<circle[^>]*cx="([^"]*)"[^>]*cy="([^"]*)"[^>]*>/g;
        const circles = [];
        while ((match = circlePattern.exec(svg)) !== null) {
            circles.push({ cx: parseFloat(match[1]), cy: parseFloat(match[2]) });
        }
        if (circles.length > 0) {
            console.log(`Found ${circles.length} circle elements`);
        }
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });