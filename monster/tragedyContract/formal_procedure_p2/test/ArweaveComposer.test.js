const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Arweave Tragedy NFT System", function () {
  let monsterBank;
  let itemBank;
  let backgroundBank;
  let effectBank;
  let composer;
  let owner;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();

    // Deploy Base64 library
    const Base64 = await ethers.getContractFactory("contracts/libraries/Base64.sol:Base64");
    const base64 = await Base64.deploy();
    await base64.deployed();

    // Deploy Monster Bank
    const ArweaveMonsterBank = await ethers.getContractFactory("ArweaveMonsterBank");
    monsterBank = await ArweaveMonsterBank.deploy();
    await monsterBank.deployed();

    // Deploy Item Bank
    const ArweaveItemBank = await ethers.getContractFactory("ArweaveItemBank");
    itemBank = await ArweaveItemBank.deploy();
    await itemBank.deployed();

    // Deploy Background Bank
    const ArweaveBackgroundBank = await ethers.getContractFactory("ArweaveBackgroundBank");
    backgroundBank = await ArweaveBackgroundBank.deploy();
    await backgroundBank.deployed();

    // Deploy Effect Bank
    const ArweaveEffectBank = await ethers.getContractFactory("ArweaveEffectBank");
    effectBank = await ArweaveEffectBank.deploy();
    await effectBank.deployed();

    // Deploy Composer
    const ArweaveTragedyComposerV2 = await ethers.getContractFactory("ArweaveTragedyComposerV2");
    composer = await ArweaveTragedyComposerV2.deploy(
      monsterBank.address,
      itemBank.address,
      backgroundBank.address,
      effectBank.address
    );
    await composer.deployed();
  });

  describe("Bank Deployment", function () {
    it("Should deploy all banks correctly", async function () {
      expect(await monsterBank.owner()).to.equal(owner.address);
      expect(await itemBank.owner()).to.equal(owner.address);
      expect(await backgroundBank.owner()).to.equal(owner.address);
      expect(await effectBank.owner()).to.equal(owner.address);
    });

    it("Should have correct names", async function () {
      expect(await monsterBank.getMonsterName(0)).to.equal("Werewolf");
      expect(await itemBank.getItemName(0)).to.equal("Crown");
      expect(await backgroundBank.getBackgroundName(0)).to.equal("Bloodmoon");
      expect(await effectBank.getEffectName(0)).to.equal("Seizure");
    });
  });

  describe("Composer", function () {
    it("Should have correct bank addresses", async function () {
      expect(await composer.monsterBank()).to.equal(monsterBank.address);
      expect(await composer.itemBank()).to.equal(itemBank.address);
      expect(await composer.backgroundBank()).to.equal(backgroundBank.address);
      expect(await composer.effectBank()).to.equal(effectBank.address);
    });

    it("Should have correct default filter parameters", async function () {
      const bloodmoonFilter = await composer.filterParams(0);
      expect(bloodmoonFilter.hueRotate).to.equal(0);
      expect(bloodmoonFilter.saturate).to.equal(150);
      expect(bloodmoonFilter.brightness).to.equal(120);

      const venomFilter = await composer.filterParams(4);
      expect(venomFilter.hueRotate).to.equal(120);
      expect(venomFilter.saturate).to.equal(180);
      expect(venomFilter.brightness).to.equal(110);
    });

    it("Should compose SVG correctly", async function () {
      const svg = await composer.composeSVG(0, 0, 0, 0);
      
      // Check structure
      expect(svg).to.include('<svg width="240" height="240"');
      expect(svg).to.include('</svg>');
      
      // Check filter
      expect(svg).to.include('<defs><filter id="f0">');
      expect(svg).to.include('type="hueRotate"');
      expect(svg).to.include('type="saturate"');
      
      // Check layers
      expect(svg).to.include('data:image/svg+xml;base64,');
    });

    it("Should generate different SVGs for different inputs", async function () {
      const svg1 = await composer.composeSVG(0, 0, 0, 0);
      const svg2 = await composer.composeSVG(1, 1, 1, 1);
      
      expect(svg1).to.not.equal(svg2);
      expect(svg1).to.include('id="f0"');
      expect(svg2).to.include('id="f1"');
    });
  });

  describe("URL Management", function () {
    it("Should update background URLs", async function () {
      const newUrl = "https://arweave.net/new-bloodmoon-tx-id";
      await backgroundBank.setBackgroundUrl(0, newUrl);
      expect(await backgroundBank.getBackgroundUrl(0)).to.equal(newUrl);
    });

    it("Should update effect URLs", async function () {
      const newUrl = "https://arweave.net/new-seizure-tx-id";
      await effectBank.setEffectUrl(0, newUrl);
      expect(await effectBank.getEffectUrl(0)).to.equal(newUrl);
    });

    it("Should batch update URLs", async function () {
      const ids = [0, 1, 2];
      const urls = [
        "https://arweave.net/url1",
        "https://arweave.net/url2",
        "https://arweave.net/url3"
      ];
      
      await backgroundBank.setMultipleUrls(ids, urls);
      
      expect(await backgroundBank.getBackgroundUrl(0)).to.equal(urls[0]);
      expect(await backgroundBank.getBackgroundUrl(1)).to.equal(urls[1]);
      expect(await backgroundBank.getBackgroundUrl(2)).to.equal(urls[2]);
    });
  });

  describe("Access Control", function () {
    it("Should only allow owner to update URLs", async function () {
      const [, notOwner] = await ethers.getSigners();
      
      await expect(
        backgroundBank.connect(notOwner).setBackgroundUrl(0, "test")
      ).to.be.revertedWith("Not owner");
      
      await expect(
        effectBank.connect(notOwner).setEffectUrl(0, "test")
      ).to.be.revertedWith("Not owner");
    });

    it("Should only allow owner to update filter params", async function () {
      const [, notOwner] = await ethers.getSigners();
      
      await expect(
        composer.connect(notOwner).setFilterParams(0, 45, 200, 150)
      ).to.be.revertedWith("Not owner");
    });
  });

  describe("Base64 Encoding", function () {
    it("Should properly encode SVGs", async function () {
      const svg = await composer.composeSVG(0, 0, 0, 0);
      
      // Extract base64 data
      const base64Match = svg.match(/data:image\/svg\+xml;base64,([A-Za-z0-9+/=]+)/);
      expect(base64Match).to.not.be.null;
      
      // Verify it's valid base64
      const base64Data = base64Match[1];
      const decoded = Buffer.from(base64Data, 'base64').toString('utf8');
      
      // Should be valid SVG
      expect(decoded).to.include('<svg');
      expect(decoded).to.include('</svg>');
    });
  });
});