const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Tragedy Composer Layer", function () {
    let materialBank;
    let svgComposer;
    let synergyChecker;
    let textComposer;
    
    beforeEach(async function () {
        // Deploy MaterialBank
        const MaterialBank = await ethers.getContractFactory("TragedyMaterialBank");
        materialBank = await MaterialBank.deploy();
        await materialBank.deployed();
        
        // Deploy SVGComposer
        const SVGComposer = await ethers.getContractFactory("TragedySVGComposer");
        svgComposer = await SVGComposer.deploy(materialBank.address);
        await svgComposer.deployed();
        
        // Deploy SynergyChecker
        const SynergyChecker = await ethers.getContractFactory("TragedySynergyChecker");
        synergyChecker = await SynergyChecker.deploy();
        await synergyChecker.deployed();
        
        // Deploy TextComposer
        const TextComposer = await ethers.getContractFactory("TragedyTextComposer");
        textComposer = await TextComposer.deploy(materialBank.address, synergyChecker.address);
        await textComposer.deployed();
    });
    
    describe("SVGComposer", function () {
        it("Should compose valid SVG with all layers", async function () {
            // Test Vampire + Wine + Bloodmoon + Bats (Mythic synergy)
            const svg = await svgComposer.composeSVG(6, 5, 0, 4);
            
            // Check SVG structure
            expect(svg).to.include('<svg xmlns="http://www.w3.org/2000/svg"');
            expect(svg).to.include('viewBox="0 0 24 24"');
            expect(svg).to.include('</svg>');
            
            // Check for filter (bloodmoon has hue-rotate 0, so no filter)
            expect(svg).to.include('<defs>');
            
            // Check all layers are present
            expect(svg).to.include('fill="#1a0000"'); // Bloodmoon background
            expect(svg).to.include('id="vampire"'); // Vampire species
            expect(svg).to.include('id="wine"'); // Wine equipment
            expect(svg).to.include('fill="#000"'); // Bats effect (now using paths)
        });
        
        it("Should apply color filter for realms with hue rotation", async function () {
            // Test with Abyss realm (hue-rotate 250)
            const svg = await svgComposer.composeSVG(0, 0, 1, 0);
            
            expect(svg).to.include('hueRotate');
            expect(svg).to.include('250');
            expect(svg).to.include('filter="url(#realmFilter)"');
        });
        
        it("Should position equipment correctly", async function () {
            // Test Crown positioning
            const crownSvg = await svgComposer.composeSVG(4, 0, 0, 0); // Dragon + Crown
            expect(crownSvg).to.include('translate(0, -6)');
            
            // Test Shield positioning
            const shieldSvg = await svgComposer.composeSVG(9, 2, 0, 0); // Skeleton + Shield
            expect(shieldSvg).to.include('translate(-4, 0)');
        });
        
        it("Should revert for invalid inputs", async function () {
            await expect(svgComposer.composeSVG(10, 0, 0, 0))
                .to.be.revertedWith("Invalid species");
            await expect(svgComposer.composeSVG(0, 10, 0, 0))
                .to.be.revertedWith("Invalid equipment");
            await expect(svgComposer.composeSVG(0, 0, 10, 0))
                .to.be.revertedWith("Invalid realm");
            await expect(svgComposer.composeSVG(0, 0, 0, 10))
                .to.be.revertedWith("Invalid curse");
        });
    });
    
    describe("SynergyChecker", function () {
        it("Should detect all Quad synergies", async function () {
            // Test Crimson Lord (Vampire + Wine + Bloodmoon + Bats)
            const synergy1 = await synergyChecker.checkSynergy(6, 5, 0, 4);
            expect(synergy1.exists).to.be.true;
            expect(synergy1.title).to.equal("Crimson Lord");
            expect(synergy1.synergyType).to.equal(3); // Quad
            expect(synergy1.rarity).to.equal(5); // Mythic
            
            // Test Cosmic Sovereign (Dragon + Crown + Ragnarok + Meteor)
            const synergy2 = await synergyChecker.checkSynergy(4, 0, 8, 3);
            expect(synergy2.exists).to.be.true;
            expect(synergy2.title).to.equal("Cosmic Sovereign");
            
            // Test Hell's Harvester (Demon + Scythe + Inferno + Burning)
            const synergy3 = await synergyChecker.checkSynergy(3, 6, 6, 8);
            expect(synergy3.exists).to.be.true;
            expect(synergy3.title).to.equal("Hell's Harvester");
        });
        
        it("Should detect Trinity synergies", async function () {
            // Test Trinity of Toxins (any species + Poison + Venom + Poisoning)
            const synergy = await synergyChecker.checkSynergy(2, 3, 4, 5); // with Frankenstein
            expect(synergy.exists).to.be.true;
            expect(synergy.title).to.equal("Trinity of Toxins");
            expect(synergy.synergyType).to.equal(2); // Trinity
            
            // Test Winter Wolf (Werewolf + Sword + Blizzard) - no realm conflict
            const synergy2 = await synergyChecker.checkSynergy(0, 1, 2, 7); // with Decay realm
            expect(synergy2.exists).to.be.true;
            expect(synergy2.title).to.equal("Winter Wolf");
            expect(synergy2.synergyType).to.equal(2); // Trinity
        });
        
        it("Should detect Dual synergies", async function () {
            // Test Blood Sommelier (Vampire + Wine)
            const synergy1 = await synergyChecker.checkSynergy(6, 5, 2, 7); // with random realm/curse
            expect(synergy1.exists).to.be.true;
            expect(synergy1.title).to.equal("Blood Sommelier");
            expect(synergy1.synergyType).to.equal(1); // Dual
            
            // Test Eternal Flame (Inferno + Burning)
            const synergy2 = await synergyChecker.checkSynergy(1, 1, 6, 8); // with random species/equipment
            expect(synergy2.exists).to.be.true;
            expect(synergy2.title).to.equal("Eternal Flame");
        });
        
        it("Should return no synergy for non-matching combinations", async function () {
            const synergy = await synergyChecker.checkSynergy(0, 0, 0, 0);
            expect(synergy.exists).to.be.false;
            expect(synergy.synergyType).to.equal(0); // None
        });
    });
    
    describe("TextComposer", function () {
        it("Should generate synergy names for matching combinations", async function () {
            // Test Crimson Lord
            const name = await textComposer.generateName(1, 6, 5, 0, 4);
            expect(name).to.equal("Crimson Lord #1");
            
            // Test with different token ID
            const name2 = await textComposer.generateName(666, 6, 5, 0, 4);
            expect(name2).to.equal("Crimson Lord #666");
        });
        
        it("Should generate dynamic names based on power levels", async function () {
            // Crown (power 9) vs Seizure (power 1) - Equipment wins
            const name1 = await textComposer.generateName(1, 0, 0, 0, 0);
            expect(name1).to.include("Werewolf on Bloodmoon");
            expect(name1).to.match(/^(King|Lord|Monarch|Sovereign)/);
            
            // Wine (power 2) vs Mind Blast (power 9) - Curse wins
            const name2 = await textComposer.generateName(1, 0, 5, 0, 1);
            expect(name2).to.include("Werewolf on Bloodmoon");
            expect(name2).to.match(/^(Psycho|Mad|Demented|Insane)/);
        });
        
        it("Should generate synergy descriptions", async function () {
            const desc = await textComposer.generateDescription(1, 6, 5, 0, 4);
            expect(desc).to.equal(
                "Under the blood moon, the crimson ruler commands legions of bats from a throne of crystallized blood."
            );
        });
        
        it("Should generate dynamic descriptions for non-synergy", async function () {
            const desc = await textComposer.generateDescription(1, 0, 0, 0, 0);
            expect(desc).to.include("werewolf wielding crown");
            expect(desc).to.include("bloodmoon realm");
            expect(desc).to.include("afflicted by seizure");
            expect(desc).to.include("This cursed being exists in the space between nightmare and reality.");
        });
    });
    
    describe("Integration", function () {
        it("Should work together to create complete NFT metadata", async function () {
            // Test complete flow for a Mythic synergy
            const species = 4;    // Dragon
            const equipment = 0;  // Crown
            const realm = 8;      // Ragnarok
            const curse = 3;      // Meteor
            const tokenId = 1337;
            
            // Get SVG
            const svg = await svgComposer.composeSVG(species, equipment, realm, curse);
            expect(svg).to.include('<svg');
            
            // Get name
            const name = await textComposer.generateName(tokenId, species, equipment, realm, curse);
            expect(name).to.equal("Cosmic Sovereign #1337");
            
            // Get description
            const desc = await textComposer.generateDescription(tokenId, species, equipment, realm, curse);
            expect(desc).to.include("crowned dragon rains celestial fire");
            
            console.log("\n        Generated NFT Metadata:");
            console.log(`        Name: ${name}`);
            console.log(`        Description: ${desc.substring(0, 80)}...`);
            console.log(`        SVG Length: ${svg.length} characters`);
        });
    });
});