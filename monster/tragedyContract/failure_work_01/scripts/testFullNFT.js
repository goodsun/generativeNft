// Test full NFT composition

async function main() {
    const nftAddress = "0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0";
    
    const abi = ["function getSVG(uint256 tokenId) external view returns (string memory)"];
    const nft = new ethers.Contract(nftAddress, abi, ethers.provider);
    
    // Test token ID 1
    console.log("Checking NFT #1 SVG composition...");
    
    try {
        const svg = await nft.getSVG(1);
        
        // Save to file for inspection
        const fs = require('fs');
        fs.writeFileSync('nft-1-full.svg', svg);
        console.log("Full SVG saved to nft-1-full.svg");
        
        // Check SVG structure
        console.log("\nSVG length:", svg.length);
        console.log("ViewBox:", svg.match(/viewBox="([^"]+)"/)?.[1]);
        
        // Count layer elements
        const monsterRects = (svg.match(/<!--Monster-->/g) || []).length;
        const backgroundRects = (svg.match(/<!--Background-->/g) || []).length;
        const itemRects = (svg.match(/<!--Item-->/g) || []).length;
        const effectRects = (svg.match(/<!--Effect-->/g) || []).length;
        
        console.log("\nLayers found:");
        console.log("Monster sections:", monsterRects);
        console.log("Background sections:", backgroundRects);
        console.log("Item sections:", itemRects);
        console.log("Effect sections:", effectRects);
        
        // Check if all layers are present
        const hasMonster = svg.includes('<rect') && svg.indexOf('<rect') < 1000;
        const hasBackground = svg.includes('fill=') && svg.includes('#');
        const hasItem = svg.includes('Crown') || svg.includes('Sword') || svg.length > 5000;
        
        console.log("\nContent check:");
        console.log("Has monster content:", hasMonster);
        console.log("Has background content:", hasBackground);
        console.log("Has item content:", hasItem);
        
    } catch (error) {
        console.error("Error getting SVG:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });