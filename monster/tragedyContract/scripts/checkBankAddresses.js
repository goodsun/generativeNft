const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Checking Bank contract addresses...\n");
    
    const deployment = require('./deployment-result.json');
    
    // Monster Bank ABI
    const bankABI = [
        {
            "inputs": [{"type": "uint256"}],
            "name": "svgContracts",
            "outputs": [{"type": "address"}],
            "stateMutability": "view",
            "type": "function"
        }
    ];
    
    // Check Monster Bank
    console.log("🦾 Monster Bank:", deployment.contracts.banks.monsterBank);
    const monsterBank = new ethers.Contract(deployment.contracts.banks.monsterBank, bankABI, ethers.provider);
    
    console.log("Checking stored addresses:");
    for (let i = 0; i < 10; i++) {
        const addr = await monsterBank.svgContracts(i);
        console.log(`  [${i}] ${addr}`);
    }
    
    // Check deployment addresses
    console.log("\n📋 Expected addresses from deployment:");
    const monsters = Object.entries(deployment.contracts.monsters);
    monsters.forEach(([name, addr], i) => {
        console.log(`  [${i}] ${name}: ${addr}`);
    });
    
    // Check if a specific monster contract works
    console.log("\n🧪 Testing Werewolf contract directly...");
    const werewolfABI = [{
        "inputs": [],
        "name": "getSVG",
        "outputs": [{"type": "string"}],
        "stateMutability": "pure",
        "type": "function"
    }];
    
    const werewolf = new ethers.Contract(deployment.contracts.monsters.Werewolf, werewolfABI, ethers.provider);
    try {
        const svg = await werewolf.getSVG();
        console.log("✅ Werewolf SVG length:", svg.length);
    } catch (error) {
        console.error("❌ Error calling Werewolf:", error.message);
    }
}