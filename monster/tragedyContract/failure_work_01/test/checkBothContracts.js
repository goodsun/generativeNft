const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Checking Both Deployments on Bon-Soleil\n");
    
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    console.log("Chain ID:", network.chainId);
    console.log("");
    
    const contracts = [
        { name: "1st Deploy (broken SVG)", address: "0x2CF146a4b455b85CA8d24153200D4F3cbf520767" },
        { name: "2nd Deploy (fixed SVG)", address: "0xce65e59671c812567d227176514e4082aa4E4893" }
    ];
    
    for (const contract of contracts) {
        console.log(`📋 ${contract.name}:`);
        console.log(`   Address: ${contract.address}`);
        
        const code = await provider.getCode(contract.address);
        console.log(`   Has code: ${code !== "0x"}`);
        console.log(`   Code length: ${code.length}`);
        
        if (code !== "0x") {
            // Try to get SVG
            try {
                const abi = ["function getSpeciesSVG(uint8 id) external view returns (string memory)"];
                const bankContract = new ethers.Contract(contract.address, abi, provider);
                const svg = await bankContract.getSpeciesSVG(0);
                console.log(`   SVG length: ${svg.length}`);
                console.log(`   SVG preview: ${svg.substring(0, 60)}...`);
            } catch (error) {
                console.log(`   Error getting SVG: ${error.message}`);
            }
        }
        console.log("");
    }
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });