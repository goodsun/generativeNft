const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TragedyMaterialBank", function () {
    let materialBank;
    
    beforeEach(async function () {
        const MaterialBank = await ethers.getContractFactory("TragedyMaterialBank");
        materialBank = await MaterialBank.deploy();
        await materialBank.deployed();
    });
    
    describe("Species", function () {
        it("Should return all 10 species names correctly", async function () {
            const expectedNames = [
                "Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon",
                "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"
            ];
            
            for (let i = 0; i < 10; i++) {
                expect(await materialBank.getSpeciesName(i)).to.equal(expectedNames[i]);
            }
        });
        
        it("Should return valid SVG for each species", async function () {
            for (let i = 0; i < 10; i++) {
                const svg = await materialBank.getSpeciesSVG(i);
                expect(svg).to.include('<g id="');
                expect(svg).to.include('</g>');
            }
        });
        
        it("Should revert for invalid species ID", async function () {
            await expect(materialBank.getSpeciesName(10))
                .to.be.revertedWith("Invalid species ID");
            await expect(materialBank.getSpeciesSVG(10))
                .to.be.revertedWith("Invalid species ID");
        });
    });
    
    describe("Equipment", function () {
        it("Should return all 10 equipment names correctly", async function () {
            const expectedNames = [
                "Crown", "Sword", "Shield", "Poison", "Torch",
                "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"
            ];
            
            for (let i = 0; i < 10; i++) {
                expect(await materialBank.getEquipmentName(i)).to.equal(expectedNames[i]);
            }
        });
        
        it("Should return valid SVG for each equipment", async function () {
            for (let i = 0; i < 10; i++) {
                const svg = await materialBank.getEquipmentSVG(i);
                expect(svg).to.include('<g id="');
                expect(svg).to.include('</g>');
            }
        });
        
        it("Should revert for invalid equipment ID", async function () {
            await expect(materialBank.getEquipmentName(10))
                .to.be.revertedWith("Invalid equipment ID");
            await expect(materialBank.getEquipmentSVG(10))
                .to.be.revertedWith("Invalid equipment ID");
        });
    });
    
    describe("Realms", function () {
        it("Should return all 10 realm names correctly", async function () {
            const expectedNames = [
                "Bloodmoon", "Abyss", "Decay", "Corruption", "Venom",
                "Void", "Inferno", "Frost", "Ragnarok", "Shadow"
            ];
            
            for (let i = 0; i < 10; i++) {
                expect(await materialBank.getRealmName(i)).to.equal(expectedNames[i]);
            }
        });
        
        it("Should return valid SVG for each background", async function () {
            for (let i = 0; i < 10; i++) {
                const svg = await materialBank.getBackgroundSVG(i);
                expect(svg).to.include('<rect');
                expect(svg).to.include('width="24"');
                expect(svg).to.include('height="24"');
            }
        });
        
        it("Should revert for invalid realm ID", async function () {
            await expect(materialBank.getRealmName(10))
                .to.be.revertedWith("Invalid realm ID");
            await expect(materialBank.getBackgroundSVG(10))
                .to.be.revertedWith("Invalid background ID");
        });
    });
    
    describe("Curses", function () {
        it("Should return all 10 curse names correctly", async function () {
            const expectedNames = [
                "Seizure", "Mind Blast", "Confusion", "Meteor", "Bats",
                "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"
            ];
            
            for (let i = 0; i < 10; i++) {
                expect(await materialBank.getCurseName(i)).to.equal(expectedNames[i]);
            }
        });
        
        it("Should return valid SVG for each effect", async function () {
            for (let i = 0; i < 10; i++) {
                const svg = await materialBank.getEffectSVG(i);
                expect(svg).to.include('<g');
                // Most effects have opacity
                if (i !== 3 && i !== 4) { // Not Meteor or Bats
                    expect(svg).to.include('opacity=');
                }
            }
        });
        
        it("Should revert for invalid curse ID", async function () {
            await expect(materialBank.getCurseName(10))
                .to.be.revertedWith("Invalid curse ID");
            await expect(materialBank.getEffectSVG(10))
                .to.be.revertedWith("Invalid effect ID");
        });
    });
    
    describe("SVG Content Verification", function () {
        it("Should have correct demon SVG structure", async function () {
            const svg = await materialBank.getSpeciesSVG(3); // Demon
            expect(svg).to.include('<g id="demon">');
            expect(svg).to.include('#8B0000'); // Dark red
            expect(svg).to.include('#FF0000'); // Red for horns
        });
        
        it("Should have correct crown SVG structure", async function () {
            const svg = await materialBank.getEquipmentSVG(0); // Crown
            expect(svg).to.include('<g id="crown">');
            expect(svg).to.include('#FFD700'); // Gold
        });
        
        it("Should have animated effects", async function () {
            const seizure = await materialBank.getEffectSVG(0);
            expect(seizure).to.include('<animate');
            expect(seizure).to.include('repeatCount="indefinite"');
            
            const lightning = await materialBank.getEffectSVG(6);
            expect(lightning).to.include('<animate');
        });
    });
    
    describe("Gas Usage", function () {
        it("Should have reasonable gas usage for SVG retrieval", async function () {
            // Get gas usage for different SVG types
            const speciesGas = await materialBank.estimateGas.getSpeciesSVG(0);
            const equipmentGas = await materialBank.estimateGas.getEquipmentSVG(0);
            const backgroundGas = await materialBank.estimateGas.getBackgroundSVG(0);
            const effectGas = await materialBank.estimateGas.getEffectSVG(0);
            
            // Log gas usage for documentation
            console.log("        Gas usage:");
            console.log(`        - Species SVG: ${speciesGas.toString()}`);
            console.log(`        - Equipment SVG: ${equipmentGas.toString()}`);
            console.log(`        - Background SVG: ${backgroundGas.toString()}`);
            console.log(`        - Effect SVG: ${effectGas.toString()}`);
            
            // Ensure gas usage is reasonable (under 500k for any single call)
            expect(speciesGas.lt(500000)).to.be.true;
            expect(equipmentGas.lt(500000)).to.be.true;
            expect(backgroundGas.lt(500000)).to.be.true;
            expect(effectGas.lt(500000)).to.be.true;
        });
    });
});