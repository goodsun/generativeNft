const fs = require('fs');
const path = require('path');

console.log("🚀 Tragedy SVG Deployment Summary\n");
console.log("=" .repeat(50));

// Check contract directories
const svgDir = path.join(__dirname, '../contracts/layer4/svgs');
const categories = {
    'Monsters': 'monsters',
    'Backgrounds': 'bg', 
    'Items': 'items',
    'Effects': 'effect'
};

let totalContracts = 0;

for (const [name, dir] of Object.entries(categories)) {
    const fullPath = path.join(svgDir, dir);
    if (fs.existsSync(fullPath)) {
        const files = fs.readdirSync(fullPath).filter(f => f.endsWith('.sol'));
        console.log(`\n${name}: ${files.length} contracts`);
        files.forEach(f => console.log(`  - ${f.replace('.sol', '')}`));
        totalContracts += files.length;
    }
}

// Check banks
console.log(`\nBanks: 4 contracts`);
const banks = fs.readdirSync(svgDir).filter(f => f.startsWith('TragedyModular') && f.endsWith('.sol'));
banks.forEach(f => console.log(`  - ${f.replace('.sol', '')}`));
totalContracts += banks.length;

console.log("\n" + "=" .repeat(50));
console.log(`TOTAL: ${totalContracts} contracts to deploy`);
console.log("=" .repeat(50));

console.log("\n📋 Deployment Steps:");
console.log("1. Deploy all 42 individual SVG contracts");
console.log("2. Deploy 4 Bank contracts with SVG addresses");
console.log("3. Save deployment addresses to JSON file");
console.log("4. Verify deployment with test calls");

console.log("\n💰 Estimated Gas:");
console.log("- Individual SVG: ~300k-500k gas each");
console.log("- Bank contracts: ~500k-700k gas each"); 
console.log("- Total estimate: ~15-20M gas");

console.log("\n🔧 Next Steps:");
console.log("1. Run: npx hardhat run scripts/deployAllSVGs.js --network <network>");
console.log("2. Check deployment-result.json for addresses");
console.log("3. Create detailed SVG composer using the banks");
console.log("4. Implement Layer 1 NFT contract");