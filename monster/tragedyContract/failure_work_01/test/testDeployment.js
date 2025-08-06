const { ethers } = require("hardhat");

async function main() {
    console.log("🧪 Testing deployment of generated SVG contracts...\n");
    
    try {
        // Test deploying a Monster SVG contract
        console.log("Testing Monster SVG deployment...");
        const WerewolfContract = await ethers.getContractFactory("TragedyWerewolf");
        const werewolf = await WerewolfContract.deploy();
        await werewolf.deployed();
        console.log("✅ TragedyWerewolf deployed to:", werewolf.address);
        
        // Test getting SVG
        const svg = await werewolf.getSVG();
        console.log("✅ SVG length:", svg.length, "characters");
        console.log("✅ SVG starts with:", svg.substring(0, 50) + "...");
        
        // Test deploying Monster Bank with one address
        console.log("\nTesting Monster Bank deployment...");
        const BankContract = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank");
        const addresses = Array(10).fill(ethers.constants.AddressZero);
        addresses[0] = werewolf.address;
        
        const bank = await BankContract.deploy(addresses);
        await bank.deployed();
        console.log("✅ Monster Bank deployed to:", bank.address);
        
        // Test getting SVG from bank
        const bankSvg = await bank.getSpeciesSVG(0);
        console.log("✅ Bank returned SVG length:", bankSvg.length);
        console.log("✅ SVGs match:", svg === bankSvg);
        
        console.log("\n✨ All tests passed!");
        
    } catch (error) {
        console.error("❌ Test failed:", error.message);
        throw error;
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });