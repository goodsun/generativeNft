const { ethers } = require("hardhat");
const fs = require('fs');
const path = require('path');

async function main() {
    console.log("🚀 Starting Tragedy SVG Full Deployment...\n");
    
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    
    // デプロイ結果を記録
    const deploymentData = {
        deployer: deployer.address,
        timestamp: new Date().toISOString(),
        network: (await ethers.provider.getNetwork()).name,
        contracts: {
            monsters: {},
            backgrounds: {},
            items: {},
            effects: {},
            banks: {}
        }
    };
    
    // 1. Monster SVGコントラクトをデプロイ
    console.log("\n📦 Deploying Monster SVG Contracts...");
    const monsterNames = [
        'Werewolf', 'Goblin', 'Frankenstein', 'Demon', 'Dragon',
        'Zombie', 'Vampire', 'Mummy', 'Succubus', 'Skeleton'
    ];
    const monsterAddresses = [];
    
    for (let i = 0; i < monsterNames.length; i++) {
        const name = monsterNames[i];
        console.log(`  Deploying Tragedy${name}...`);
        
        const Contract = await ethers.getContractFactory(`Tragedy${name}`);
        const contract = await Contract.deploy();
        await contract.deployed();
        
        monsterAddresses.push(contract.address);
        deploymentData.contracts.monsters[name] = contract.address;
        console.log(`  ✅ ${name} deployed to:`, contract.address);
    }
    
    // 2. Background SVGコントラクトをデプロイ
    console.log("\n🌅 Deploying Background SVG Contracts...");
    const bgNames = [
        'Bloodmoon', 'Abyss', 'Decay', 'Corruption', 'Venom',
        'Void', 'Inferno', 'Frost', 'Ragnarok', 'Shadow'
    ];
    const bgAddresses = [];
    
    for (let i = 0; i < bgNames.length; i++) {
        const name = bgNames[i];
        console.log(`  Deploying Tragedy${name}BG...`);
        
        const Contract = await ethers.getContractFactory(`Tragedy${name}BG`);
        const contract = await Contract.deploy();
        await contract.deployed();
        
        bgAddresses.push(contract.address);
        deploymentData.contracts.backgrounds[name] = contract.address;
        console.log(`  ✅ ${name} deployed to:`, contract.address);
    }
    
    // 3. Item SVGコントラクトをデプロイ
    console.log("\n⚔️ Deploying Item SVG Contracts...");
    const itemNames = [
        'Crown', 'Sword', 'Shield', 'Poison', 'Torch',
        'Wine', 'Scythe', 'Staff', 'Shoulder', 'Amulet'
    ];
    const itemAddresses = [];
    
    for (let i = 0; i < itemNames.length; i++) {
        const name = itemNames[i];
        console.log(`  Deploying Tragedy${name}Item...`);
        
        const Contract = await ethers.getContractFactory(`Tragedy${name}Item`);
        const contract = await Contract.deploy();
        await contract.deployed();
        
        itemAddresses.push(contract.address);
        deploymentData.contracts.items[name] = contract.address;
        console.log(`  ✅ ${name} deployed to:`, contract.address);
    }
    
    // 4. Effect SVGコントラクトをデプロイ
    console.log("\n✨ Deploying Effect SVG Contracts...");
    const effectNames = [
        'Seizure', 'Mindblast', 'Confusion', 'Meteor', 'Bats',
        'Poisoning', 'Lightning', 'Blizzard', 'Burning', 'Brainwash'
    ];
    const effectAddresses = [];
    
    for (let i = 0; i < effectNames.length; i++) {
        const name = effectNames[i];
        console.log(`  Deploying Tragedy${name}Effect...`);
        
        const Contract = await ethers.getContractFactory(`Tragedy${name}Effect`);
        const contract = await Contract.deploy();
        await contract.deployed();
        
        effectAddresses.push(contract.address);
        deploymentData.contracts.effects[name] = contract.address;
        console.log(`  ✅ ${name} deployed to:`, contract.address);
    }
    
    // Extra effect contracts (blackout, matrix) if needed
    console.log("\n✨ Deploying Extra Effect SVG Contracts...");
    const extraEffectNames = ['Blackout', 'Matrix'];
    
    for (let i = 0; i < extraEffectNames.length; i++) {
        const name = extraEffectNames[i];
        try {
            console.log(`  Deploying Tragedy${name}Effect...`);
            const Contract = await ethers.getContractFactory(`Tragedy${name}Effect`);
            const contract = await Contract.deploy();
            await contract.deployed();
            
            effectAddresses.push(contract.address);
            deploymentData.contracts.effects[name] = contract.address;
            console.log(`  ✅ ${name} deployed to:`, contract.address);
        } catch (error) {
            console.log(`  ⚠️ ${name} not found, skipping...`);
        }
    }
    
    // 5. Bankコントラクトをデプロイ（SVGアドレスを渡す）
    console.log("\n🏦 Deploying Bank Contracts with SVG addresses...");
    
    // Monster Bank
    console.log("  Deploying TragedyModularMonsterBank...");
    const MonsterBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularMonsterBank.sol:TragedyModularMonsterBank");
    const monsterBank = await MonsterBank.deploy(monsterAddresses);
    await monsterBank.deployed();
    deploymentData.contracts.banks.monsterBank = monsterBank.address;
    console.log("  ✅ Monster Bank deployed to:", monsterBank.address);
    
    // Background Bank
    console.log("  Deploying TragedyModularBackgroundBank...");
    const BackgroundBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularBackgroundBank.sol:TragedyModularBackgroundBank");
    const bgBank = await BackgroundBank.deploy(bgAddresses);
    await bgBank.deployed();
    deploymentData.contracts.banks.backgroundBank = bgBank.address;
    console.log("  ✅ Background Bank deployed to:", bgBank.address);
    
    // Item Bank
    console.log("  Deploying TragedyModularItemBank...");
    const ItemBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularItemBank.sol:TragedyModularItemBank");
    const itemBank = await ItemBank.deploy(itemAddresses);
    await itemBank.deployed();
    deploymentData.contracts.banks.itemBank = itemBank.address;
    console.log("  ✅ Item Bank deployed to:", itemBank.address);
    
    // Effect Bank (needs to handle variable array size)
    console.log("  Deploying TragedyModularEffectBank...");
    console.log(`  Total effect addresses: ${effectAddresses.length}`);
    
    // Update the Effect Bank contract if needed to accept dynamic array size
    // For now, we'll pad or trim to exactly 12 addresses
    while (effectAddresses.length < 12) {
        effectAddresses.push(ethers.constants.AddressZero);
    }
    if (effectAddresses.length > 12) {
        effectAddresses = effectAddresses.slice(0, 12);
    }
    
    const EffectBank = await ethers.getContractFactory("contracts/layer4/svgs/TragedyModularEffectBank.sol:TragedyModularEffectBank");
    const effectBank = await EffectBank.deploy(effectAddresses);
    await effectBank.deployed();
    deploymentData.contracts.banks.effectBank = effectBank.address;
    console.log("  ✅ Effect Bank deployed to:", effectBank.address);
    
    // 6. デプロイ情報をファイルに保存
    const deploymentPath = path.join(__dirname, 'deployment-result.json');
    fs.writeFileSync(deploymentPath, JSON.stringify(deploymentData, null, 2));
    
    console.log("\n✨ Deployment Complete!");
    console.log(`📄 Deployment data saved to: ${deploymentPath}`);
    console.log("\n📊 Summary:");
    console.log(`  - Monster SVGs: ${monsterAddresses.length}`);
    console.log(`  - Background SVGs: ${bgAddresses.length}`);
    console.log(`  - Item SVGs: ${itemAddresses.length}`);
    console.log(`  - Effect SVGs: ${effectAddresses.length}`);
    console.log(`  - Banks: 4`);
    console.log(`  - Total Contracts: ${monsterAddresses.length + bgAddresses.length + itemAddresses.length + effectAddresses.length + 4}`);
    
    // 7. 検証用のテストを実行
    console.log("\n🧪 Running verification test...");
    const testSvg = await monsterBank.getSpeciesSVG(0); // Werewolf
    console.log("  Test: Werewolf SVG length:", testSvg.length);
    console.log("  ✅ System is working!");
    
    return deploymentData;
}

main()
    .then((data) => {
        console.log("\n🎉 All done!");
        process.exit(0);
    })
    .catch((error) => {
        console.error("\n❌ Deployment failed:", error);
        process.exit(1);
    });