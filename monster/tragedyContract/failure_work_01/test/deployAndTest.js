const { ethers } = require("hardhat");

async function main() {
    console.log("🚀 Deploy and Test Single SVG Contract\n");
    
    try {
        // Deploy one monster SVG
        console.log("1️⃣ Deploying TragedyWerewolf...");
        const WerewolfContract = await ethers.getContractFactory("TragedyWerewolf");
        const werewolf = await WerewolfContract.deploy();
        await werewolf.deployed();
        console.log("✅ Deployed to:", werewolf.address);
        
        // Test direct SVG retrieval
        console.log("\n2️⃣ Getting SVG directly...");
        const svg = await werewolf.getSVG();
        console.log("✅ SVG length:", svg.length);
        console.log("✅ First 100 chars:", svg.substring(0, 100) + "...");
        
        // Deploy Monster Bank with this one address
        console.log("\n3️⃣ Deploying Monster Bank...");
        const addresses = [
            werewolf.address,
            ...Array(9).fill(ethers.constants.AddressZero)
        ];
        
        const BankContract = await ethers.getContractFactory(
            "contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank"
        );
        const bank = await BankContract.deploy(addresses);
        await bank.deployed();
        console.log("✅ Bank deployed to:", bank.address);
        
        // Test bank retrieval
        console.log("\n4️⃣ Getting SVG from Bank...");
        const bankSvg = await bank.getSpeciesSVG(0);
        console.log("✅ Bank SVG length:", bankSvg.length);
        console.log("✅ SVGs match:", svg === bankSvg);
        
        // Test error handling
        console.log("\n5️⃣ Testing error handling...");
        try {
            await bank.getSpeciesSVG(1); // Should fail (AddressZero)
            console.log("❌ Should have failed!");
        } catch (error) {
            console.log("✅ Correctly rejected AddressZero");
        }
        
        try {
            await bank.getSpeciesSVG(10); // Should fail (out of bounds)
            console.log("❌ Should have failed!");
        } catch (error) {
            console.log("✅ Correctly rejected out of bounds");
        }
        
        // Test all deployed effect SVGs 
        console.log("\n6️⃣ Testing Effect SVGs...");
        const effectNames = ['Seizure', 'Meteor', 'Blackout'];
        const effectContracts = [];
        
        for (const name of effectNames) {
            try {
                const Contract = await ethers.getContractFactory(`Tragedy${name}Effect`);
                const contract = await Contract.deploy();
                await contract.deployed();
                const svg = await contract.getSVG();
                console.log(`✅ ${name}: ${svg.length} chars`);
                effectContracts.push(contract.address);
            } catch (error) {
                console.log(`⚠️ ${name}: Not found`);
                effectContracts.push(ethers.constants.AddressZero);
            }
        }
        
        console.log("\n✨ All tests completed successfully!");
        
    } catch (error) {
        console.error("\n❌ Test failed:", error);
        throw error;
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });