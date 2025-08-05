const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Verifying Contract on Chain ID 21201\n");
    
    const provider = ethers.provider;
    const network = await provider.getNetwork();
    console.log("Chain ID:", network.chainId);
    
    // Check if contract exists
    const contractAddress = "0xce65e59671c812567d227176514e4082aa4E4893";
    const code = await provider.getCode(contractAddress);
    
    console.log("\nContract Address:", contractAddress);
    console.log("Has code:", code !== "0x");
    console.log("Code length:", code.length);
    
    if (code === "0x") {
        console.log("\n❌ No contract found at this address!");
    } else {
        console.log("\n✅ Contract exists!");
        console.log("First 100 chars of bytecode:", code.substring(0, 100) + "...");
    }
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });