// Check item SVG positioning by direct call

async function main() {
    const [deployer] = await ethers.getSigners();
    
    // Crown contract address
    const crownAddress = "0xB420dAE87e71E54A8d651FeeB4B2973b9B5279C8";
    
    console.log("Checking Crown SVG at:", crownAddress);
    
    // Direct contract call using ABI
    const abi = ["function getSVG() external pure returns (string memory)"];
    const crown = new ethers.Contract(crownAddress, abi, deployer);
    
    // Get SVG
    const svg = await crown.getSVG();
    console.log("\nCrown SVG (first 500 chars):");
    console.log(svg.substring(0, 500) + "...");
    
    // Extract all rect elements with coordinates
    const rectPattern = /<rect[^>]*x="([^"]*)"[^>]*y="([^"]*)"[^>]*>/g;
    let match;
    const coords = [];
    while ((match = rectPattern.exec(svg)) !== null) {
        coords.push({ x: match[1], y: match[2] });
    }
    
    console.log("\nRect coordinates found:");
    coords.forEach((coord, i) => {
        console.log(`Rect ${i}: x="${coord.x}" y="${coord.y}"`);
    });
    
    // Check if coordinates are centered (around x=12, y=12)
    const avgX = coords.reduce((sum, c) => sum + parseFloat(c.x), 0) / coords.length;
    const avgY = coords.reduce((sum, c) => sum + parseFloat(c.y), 0) / coords.length;
    console.log(`\nAverage position: x=${avgX.toFixed(1)}, y=${avgY.toFixed(1)}`);
    
    // Check viewBox
    const viewBoxMatch = svg.match(/viewBox="([^"]+)"/);
    if (viewBoxMatch) {
        console.log("ViewBox:", viewBoxMatch[1]);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });