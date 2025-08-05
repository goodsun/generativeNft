const { ethers } = require("hardhat");

async function main() {
    console.log("⛽ Testing gas requirements...\n");
    
    const composerAddress = "0x183Fa3B40655abebE5cD5dB329cF97455Df73c89";
    const composer = await ethers.getContractAt("TragedyModularSVGComposerV4", composerAddress);
    
    // Test different combinations
    const tests = [
        { name: "Just Monster", args: [0, 255, 255, 255] },
        { name: "Monster + Background", args: [0, 0, 255, 255] },
        { name: "All layers", args: [0, 0, 0, 3] }
    ];
    
    for (const test of tests) {
        console.log(`\n📝 Testing: ${test.name}`);
        console.log(`Args: ${test.args.join(", ")}`);
        
        try {
            // Test with composeOptionalSVG if available
            const tx = await composer.composeSVG(...test.args);
            console.log(`✅ Success! Length: ${tx.length}`);
            
            // Estimate gas
            const gasEstimate = await composer.estimateGas.composeSVG(...test.args);
            console.log(`⛽ Gas used: ${gasEstimate.toString()}`);
            
        } catch (error) {
            console.error(`❌ Failed: ${error.message}`);
        }
    }
    
    // Test raw bank calls
    console.log("\n🏦 Testing direct bank access...");
    const deployment = require('./deployment-result.json');
    const abi = [{
        "inputs": [{"type": "uint8"}],
        "name": "getSpeciesSVG",
        "outputs": [{"type": "string"}],
        "type": "function",
        "stateMutability": "view"
    }];
    
    const monsterBank = new ethers.Contract(deployment.contracts.banks.monsterBank, abi, ethers.provider);
    const svg = await monsterBank.getSpeciesSVG(0);
    console.log(`✅ Monster Bank works! SVG length: ${svg.length}`);
}