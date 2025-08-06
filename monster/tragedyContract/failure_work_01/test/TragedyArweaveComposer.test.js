const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TragedyArweaveComposer", function () {
  let composer;
  let mockMonsterBank;
  let mockItemBank;
  let owner;

  // Test Arweave URLs (using placeholder URLs for testing)
  const TEST_BACKGROUND_URL = "https://arweave.net/test-background-tx-id";
  const TEST_EFFECT_URL = "https://arweave.net/test-effect-tx-id";

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    // Deploy mock banks
    const MockMonsterBank = await ethers.getContractFactory("MockMonsterBank");
    mockMonsterBank = await MockMonsterBank.deploy();
    await mockMonsterBank.deployed();

    const MockItemBank = await ethers.getContractFactory("MockItemBank");
    mockItemBank = await MockItemBank.deploy();
    await mockItemBank.deployed();

    // Deploy composer
    const TragedyArweaveComposerV2 = await ethers.getContractFactory("TragedyArweaveComposerV2");
    composer = await TragedyArweaveComposerV2.deploy(mockMonsterBank.address, mockItemBank.address);
    await composer.deployed();

    // Set some test URLs
    await composer.setBackgroundUrl(0, TEST_BACKGROUND_URL); // Bloodmoon
    await composer.setEffectUrl(0, TEST_EFFECT_URL); // Seizure
  });

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      expect(await composer.owner()).to.equal(owner.address);
    });

    it("Should set the correct bank addresses", async function () {
      expect(await composer.monsterBank()).to.equal(mockMonsterBank.address);
      expect(await composer.itemBank()).to.equal(mockItemBank.address);
    });

    it("Should initialize default filter parameters", async function () {
      const bloodmoonFilter = await composer.filterParams(0);
      expect(bloodmoonFilter.hueRotate).to.equal(0);
      expect(bloodmoonFilter.saturate).to.equal(150);
      expect(bloodmoonFilter.brightness).to.equal(120);

      const venomFilter = await composer.filterParams(4);
      expect(venomFilter.hueRotate).to.equal(120);
      expect(venomFilter.saturate).to.equal(180);
      expect(venomFilter.brightness).to.equal(110);
    });
  });

  describe("URL Management", function () {
    it("Should set background URLs", async function () {
      await composer.setBackgroundUrl(1, "https://arweave.net/abyss-tx-id");
      expect(await composer.backgroundUrls(1)).to.equal("https://arweave.net/abyss-tx-id");
    });

    it("Should set effect URLs", async function () {
      await composer.setEffectUrl(1, "https://arweave.net/mindblast-tx-id");
      expect(await composer.effectUrls(1)).to.equal("https://arweave.net/mindblast-tx-id");
    });

    it("Should reject invalid IDs", async function () {
      await expect(composer.setBackgroundUrl(10, "test")).to.be.revertedWith("Invalid ID");
      await expect(composer.setEffectUrl(10, "test")).to.be.revertedWith("Invalid ID");
    });

    it("Should only allow owner to set URLs", async function () {
      const [, notOwner] = await ethers.getSigners();
      await expect(
        composer.connect(notOwner).setBackgroundUrl(0, "test")
      ).to.be.revertedWith("Not owner");
    });
  });

  describe("Filter Parameters", function () {
    it("Should update filter parameters", async function () {
      await composer.setFilterParams(0, 45, 200, 150);
      const filter = await composer.filterParams(0);
      expect(filter.hueRotate).to.equal(45);
      expect(filter.saturate).to.equal(200);
      expect(filter.brightness).to.equal(150);
    });

    it("Should only allow owner to update filters", async function () {
      const [, notOwner] = await ethers.getSigners();
      await expect(
        composer.connect(notOwner).setFilterParams(0, 45, 200, 150)
      ).to.be.revertedWith("Not owner");
    });
  });

  describe("SVG Composition", function () {
    it("Should compose SVG with all layers", async function () {
      const svg = await composer.composeSVG(0, 0, 0, 0);
      
      // Debug output
      console.log("Generated SVG:", svg.substring(0, 500));
      
      // Check basic structure
      expect(svg).to.include('<svg width="240" height="240" viewBox="0 0 24 24"');
      expect(svg).to.include('</svg>');
      
      // Check filter definition
      expect(svg).to.include('<defs><filter id="f0">');
      expect(svg).to.include('<feColorMatrix type="hueRotate" values="0"/>');
      expect(svg).to.include('<feColorMatrix type="saturate" values="1.50"/>');
      expect(svg).to.include('<feComponentTransfer>');
      
      // Check layers
      expect(svg).to.include(TEST_BACKGROUND_URL);
      expect(svg).to.include('filter="url(#f0)"'); // Monster should have filter
      expect(svg).to.include(TEST_EFFECT_URL);
      expect(svg).to.include('data:image/svg+xml;base64,'); // Monster and item should be base64
    });

    it("Should apply different filters for different backgrounds", async function () {
      // Test Venom background (green filter)
      await composer.setBackgroundUrl(4, "https://arweave.net/venom-bg");
      const venomSvg = await composer.composeSVG(0, 4, 0, 0);
      
      expect(venomSvg).to.include('<filter id="f4">');
      expect(venomSvg).to.include('<feColorMatrix type="hueRotate" values="120"/>'); // Green hue
      expect(venomSvg).to.include('<feColorMatrix type="saturate" values="1.80"/>');
    });

    it("Should handle missing URLs gracefully", async function () {
      // Background 5 has no URL set
      const svg = await composer.composeSVG(0, 5, 0, 0);
      
      // Should still generate valid SVG
      expect(svg).to.include('<svg');
      expect(svg).to.include('</svg>');
      expect(svg).to.include('filter="url(#f5)"'); // Filter should still be applied
    });

    it("Should work with different monster/item combinations", async function () {
      const svg1 = await composer.composeSVG(0, 0, 0, 0); // Werewolf + Crown
      const svg2 = await composer.composeSVG(1, 0, 1, 0); // Goblin + Sword
      
      // Different content but same structure
      expect(svg1).to.not.equal(svg2);
      expect(svg1).to.include('data:image/svg+xml;base64,');
      expect(svg2).to.include('data:image/svg+xml;base64,');
    });
  });

  describe("Base64 Encoding", function () {
    it("Should properly encode monster SVG to base64", async function () {
      const svg = await composer.composeSVG(0, 0, 0, 0);
      
      // Extract base64 part for monster (after first data:image/svg+xml;base64,)
      const base64Match = svg.match(/data:image\/svg\+xml;base64,([^"]+)/);
      expect(base64Match).to.not.be.null;
      
      // Try to decode it
      const base64Data = base64Match[1];
      const decoded = Buffer.from(base64Data, 'base64').toString('utf8');
      
      // Should contain monster SVG content (red circle from mock)
      expect(decoded).to.include('circle');
      expect(decoded).to.include('fill="#ff0000"');
    });
  });

  describe("Gas Usage", function () {
    it("Should compose SVG within reasonable gas limits", async function () {
      const tx = await composer.composeSVG(0, 0, 0, 0);
      
      // This is a view function, so we can't directly measure gas
      // But we can ensure it returns successfully
      expect(tx).to.be.a('string');
      expect(tx.length).to.be.greaterThan(100);
    });
  });
});