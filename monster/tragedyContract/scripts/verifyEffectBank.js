// Verify which effect contracts are being used

const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {
    const deploymentData = JSON.parse(fs.readFileSync('./scripts/deployment-result.json', 'utf8'));
    
    const effectBankV2Address = deploymentData.contracts.banks.effectBankV2;
    console.log("Effect Bank V2:", effectBankV2Address);
    
    // Get the bank contract
    const EffectBank = await ethers.getContractFactory("TragedyModularEffectBank");
    const effectBank = EffectBank.attach(effectBankV2Address);
    
    // Check each effect
    const effectNames = ['Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats', 
                        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'];
    
    for (let i = 0; i < 10; i++) {
        try {
            console.log(`\n--- Effect ${i}: ${effectNames[i]} ---`);
            
            // Get the contract address
            const contractAddr = await effectBank.svgContracts(i);
            console.log("Contract address:", contractAddr);
            
            // Get the SVG
            const svg = await effectBank.getEffectSVG(i);
            console.log("SVG length:", svg.length);
            console.log("Has <defs>:", svg.includes("<defs>"));
            console.log("Has </defs>:", svg.includes("</defs>"));
            console.log("First 200 chars:", svg.substring(0, 200));
            
            // Save for inspection
            fs.writeFileSync(`./effect-${i}-${effectNames[i].toLowerCase()}.svg`, svg);
            
        } catch (error) {
            console.error(`Error with effect ${i}:`, error.message);
        }
    }
    
    console.log("\n✅ Effect SVGs saved for inspection");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });