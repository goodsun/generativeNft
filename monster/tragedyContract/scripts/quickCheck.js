const { ethers } = require("hardhat");

async function main() {
    // Quick check
    const bankAddr = "0x604BbbE34BA178bb5630f8a1b6CAB5e4eD99f96b";
    const bank = await ethers.getContractAt("contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank", bankAddr);
    
    // Check first address
    const addr0 = await bank.svgContracts(0);
    console.log("Address at index 0:", addr0);
    
    if (addr0 === "0x0000000000000000000000000000000000000000") {
        console.log("❌ Bank has zero addresses!");
        console.log("\nExpected addresses:");
        console.log("Werewolf: 0xCEa0E7AdD25289983D4BC1203f96C50fe6EbB583");
        console.log("Goblin: 0xAF54B931D299B69aBE65AfbB3A28BBe17a2998cD");
    }
}

main().catch(console.error);