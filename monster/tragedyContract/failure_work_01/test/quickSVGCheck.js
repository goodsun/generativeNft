const { ethers } = require("hardhat");

async function main() {
    console.log("🧪 Quick SVG Check on Bon-Soleil\n");
    
    // Deployed Monster Bank address (3rd deployment)
    const monsterBankAddress = "0x604BbbE34BA178bb5630f8a1b6CAB5e4eD99f96b";
    
    // Simple ABI for getSpeciesSVG
    const abi = [
        "function getSpeciesSVG(uint8 id) external view returns (string memory)"
    ];
    
    try {
        // Connect to Monster Bank
        const monsterBank = new ethers.Contract(monsterBankAddress, abi, ethers.provider);
        
        console.log("Getting Werewolf SVG...");
        const svg = await monsterBank.getSpeciesSVG(0);
        
        console.log("\n📊 Results:");
        console.log("- Length:", svg.length);
        console.log("- First 100 chars:", svg.substring(0, 100));
        console.log("\n- Last 100 chars:", svg.substring(svg.length - 100));
        
        // Check for xmlns issue
        const xmlnsPos = svg.indexOf('xmlns');
        if (xmlnsPos > 0) {
            console.log("\n🔍 xmlns check:");
            console.log("- Found at position:", xmlnsPos);
            console.log("- Context:", svg.substring(xmlnsPos - 20, xmlnsPos + 30));
            console.log("- Char before:", svg.charCodeAt(xmlnsPos - 1), `'${svg.charAt(xmlnsPos - 1)}'`);
        }
        
        // Save to file
        const fs = require('fs');
        fs.writeFileSync('werewolf-bonsoleil.svg', svg);
        console.log("\n💾 Saved to: werewolf-bonsoleil.svg");
        
    } catch (error) {
        console.error("❌ Error:", error.message);
    }
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });