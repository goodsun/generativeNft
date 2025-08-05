const { ethers } = require("hardhat");

async function main() {
    console.log("🔍 Checking Bon-Soleil Network Connection...\n");
    
    try {
        // Get provider
        const provider = ethers.provider;
        
        // Check network
        const network = await provider.getNetwork();
        console.log("✅ Connected to network:");
        console.log("   Chain ID:", network.chainId);
        console.log("   Name:", network.name);
        
        // Get current block
        const blockNumber = await provider.getBlockNumber();
        console.log("   Current block:", blockNumber);
        
        // Get signer info
        const [signer] = await ethers.getSigners();
        console.log("\n📱 Wallet info:");
        console.log("   Address:", signer.address);
        
        // Get balance
        const balance = await signer.getBalance();
        console.log("   Balance:", ethers.utils.formatEther(balance), "ETH");
        
        // Estimate gas price
        const gasPrice = await provider.getGasPrice();
        console.log("\n⛽ Gas info:");
        console.log("   Current gas price:", ethers.utils.formatUnits(gasPrice, "gwei"), "gwei");
        
        // Test deployment cost estimation
        console.log("\n💰 Deployment cost estimation:");
        console.log("   Single SVG contract: ~300k-500k gas");
        console.log("   Bank contract: ~500k-700k gas");
        console.log("   Total for 46 contracts: ~15-20M gas");
        
        const estimatedGas = 18000000; // 18M gas
        const estimatedCost = gasPrice.mul(estimatedGas);
        console.log("   Estimated total cost:", ethers.utils.formatEther(estimatedCost), "ETH");
        
        // Check if balance is sufficient
        if (balance.gte(estimatedCost)) {
            console.log("\n✅ Balance is sufficient for deployment!");
        } else {
            console.log("\n⚠️  Balance may not be sufficient for full deployment.");
            console.log("   You need at least:", ethers.utils.formatEther(estimatedCost), "ETH");
        }
        
    } catch (error) {
        console.error("\n❌ Error connecting to network:", error.message);
        console.log("\n🔧 Troubleshooting:");
        console.log("1. Make sure you have created a .env file with your PRIVATE_KEY");
        console.log("2. Ensure the private key is correct (without 0x prefix)");
        console.log("3. Check that the RPC URL is accessible");
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });