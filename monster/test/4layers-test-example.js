const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("4層アーキテクチャ単体テスト", function () {
  
  // Layer 4: Material Layer のテスト
  describe("MaterialBank (Layer 4)", function () {
    let materialBank;
    
    beforeEach(async function () {
      const MaterialBank = await ethers.getContractFactory("MonsterMaterialBank");
      materialBank = await MaterialBank.deploy();
    });
    
    it("素材が正しく保存・取得できる", async function () {
      // 素材の追加
      await materialBank.setMaterial(
        0, // SPECIES type
        1, // Dragon ID
        "Dragon",
        '<g id="dragon">...</g>'
      );
      
      // 素材の取得確認
      const dragonSVG = await materialBank.getMaterial(0, 1);
      expect(dragonSVG).to.equal('<g id="dragon">...</g>');
      
      // 名前の確認
      const dragonName = await materialBank.getMaterialName(0, 1);
      expect(dragonName).to.equal("Dragon");
    });
    
    it("存在しない素材は空文字を返す", async function () {
      const notExist = await materialBank.getMaterial(0, 999);
      expect(notExist).to.equal("");
    });
    
    it("素材数が正しくカウントされる", async function () {
      const count = await materialBank.getMaterialCount(0);
      expect(count).to.be.gt(0); // 初期データがある
    });
  });
  
  // Layer 3: Composer Layer のテスト
  describe("SVGComposer (Layer 3)", function () {
    let svgComposer;
    let mockMaterialBank;
    
    beforeEach(async function () {
      // MaterialBankのモックを作成
      const MockMaterialBank = await ethers.getContractFactory("MockMaterialBank");
      mockMaterialBank = await MockMaterialBank.deploy();
      
      const SVGComposer = await ethers.getContractFactory("MonsterSVGComposer");
      svgComposer = await SVGComposer.deploy(mockMaterialBank.address);
    });
    
    it("SVGが正しく合成される", async function () {
      // モックに素材を設定
      await mockMaterialBank.setTestMaterial(
        2, // BACKGROUND
        0, // Bloodmoon
        '<rect fill="#8b0000"/>'
      );
      await mockMaterialBank.setTestMaterial(
        0, // SPECIES
        6, // Vampire
        '<g id="vampire"/>'
      );
      
      // SVG合成
      const svg = await svgComposer.composeSVG(0, 6, 0, 0);
      
      // Base64デコード
      const base64 = svg.replace('data:image/svg+xml;base64,', '');
      const decoded = Buffer.from(base64, 'base64').toString();
      
      // 要素が含まれているか確認
      expect(decoded).to.include('<rect fill="#8b0000"/>');
      expect(decoded).to.include('<g id="vampire"/>');
      expect(decoded).to.include('<svg');
    });
    
    it("アイテムの位置調整が正しく適用される", async function () {
      await mockMaterialBank.setTestMaterial(
        1, // EQUIPMENT
        0, // Crown
        '<g id="crown"/>'
      );
      
      const crownSVG = await svgComposer.composeItem(0);
      
      // Crown は translate(0, -2) で上に配置される
      expect(crownSVG).to.include('transform="translate(0, -2)"');
    });
  });
  
  describe("TextComposer (Layer 3)", function () {
    let textComposer;
    
    beforeEach(async function () {
      const TextComposer = await ethers.getContractFactory("MonsterTextComposer");
      textComposer = await TextComposer.deploy();
    });
    
    it("名前が正しく生成される", async function () {
      // Vampire(6) + Wine(5) = Blood Sommelier
      const name = await textComposer.composeName(123, 6, 5);
      expect(name).to.equal("Blood Sommelier #123");
      
      // Dragon(1) + Crown(0) = Dragon King
      const name2 = await textComposer.composeName(456, 1, 0);
      expect(name2).to.equal("Dragon King #456");
      
      // 通常の組み合わせ
      const name3 = await textComposer.composeName(789, 2, 3);
      expect(name3).to.equal("Frankenstein #789");
    });
    
    it("説明文が正しく生成される", async function () {
      const desc = await textComposer.composeDescription(6, 5, 0, 4);
      expect(desc).to.equal(
        "A Bloodmoon-touched Vampire wielding Wine, cursed with Bats."
      );
    });
    
    it("ストーリーがランダムに生成される", async function () {
      const story1 = await textComposer.composeStory(0, [6, 5, 0, 4]);
      const story2 = await textComposer.composeStory(1, [6, 5, 0, 4]);
      
      // 異なるseedで異なるストーリー
      expect(story1).to.not.equal(story2);
      expect(story1.length).to.be.gt(50); // ちゃんとした長さ
    });
  });
  
  // Layer 2: Metadata Layer のテスト
  describe("MetadataBank (Layer 2)", function () {
    let metadataBank;
    let mockSVGComposer;
    let mockTextComposer;
    
    beforeEach(async function () {
      // モックComposerを作成
      const MockSVGComposer = await ethers.getContractFactory("MockSVGComposer");
      mockSVGComposer = await MockSVGComposer.deploy();
      
      const MockTextComposer = await ethers.getContractFactory("MockTextComposer");
      mockTextComposer = await MockTextComposer.deploy();
      
      const MetadataBank = await ethers.getContractFactory("MonsterMetadataBankV5");
      metadataBank = await MetadataBank.deploy(
        mockSVGComposer.address,
        mockTextComposer.address
      );
    });
    
    it("メタデータJSONが正しく組み立てられる", async function () {
      // モックの返り値を設定
      await mockSVGComposer.setTestImage("data:image/svg+xml;base64,test");
      await mockTextComposer.setTestName("Test Monster #123");
      await mockTextComposer.setTestDescription("A test description");
      
      // メタデータ取得
      const metadata = await metadataBank.getMetadata(123);
      
      // Base64デコード
      const base64 = metadata.replace('data:application/json;base64,', '');
      const json = JSON.parse(Buffer.from(base64, 'base64').toString());
      
      // JSON構造の確認
      expect(json.name).to.equal("Test Monster #123");
      expect(json.description).to.equal("A test description");
      expect(json.image).to.equal("data:image/svg+xml;base64,test");
      expect(json.attributes).to.be.an('array');
      expect(json.attributes.length).to.equal(4);
    });
    
    it("tokenIDから属性が正しくデコードされる", async function () {
      const [s, e, r, c] = await metadataBank.decodeTokenId(123);
      
      // 決定論的なので常に同じ値
      expect(s).to.be.lt(10);
      expect(e).to.be.lt(10);
      expect(r).to.be.lt(10);
      expect(c).to.be.lt(10);
      
      // 同じtokenIDは同じ属性
      const [s2, e2, r2, c2] = await metadataBank.decodeTokenId(123);
      expect(s2).to.equal(s);
      expect(e2).to.equal(e);
      expect(r2).to.equal(r);
      expect(c2).to.equal(c);
    });
  });
  
  // Layer 1: NFT Layer のテスト
  describe("BankedNFT (Layer 1)", function () {
    let bankedNFT;
    let metadataBank;
    
    beforeEach(async function () {
      // フルスタックをデプロイ
      const MaterialBank = await ethers.getContractFactory("MonsterMaterialBank");
      const materialBank = await MaterialBank.deploy();
      
      const SVGComposer = await ethers.getContractFactory("MonsterSVGComposer");
      const svgComposer = await SVGComposer.deploy(materialBank.address);
      
      const TextComposer = await ethers.getContractFactory("MonsterTextComposer");
      const textComposer = await TextComposer.deploy();
      
      const MetadataBank = await ethers.getContractFactory("MonsterMetadataBankV5");
      metadataBank = await MetadataBank.deploy(
        svgComposer.address,
        textComposer.address
      );
      
      const BankedNFT = await ethers.getContractFactory("BankedNFT");
      bankedNFT = await BankedNFT.deploy(
        "Monster NFT",
        "MONSTER",
        10000,
        ethers.utils.parseEther("0.01"),
        250 // 2.5% royalty
      );
      
      await bankedNFT.setMetadataBank(metadataBank.address);
    });
    
    it("NFTがミントできる", async function () {
      const [owner, user] = await ethers.getSigners();
      
      await bankedNFT.connect(user).mint({ 
        value: ethers.utils.parseEther("0.01") 
      });
      
      const balance = await bankedNFT.balanceOf(user.address);
      expect(balance).to.equal(1);
      
      const tokenId = await bankedNFT.tokenOfOwnerByIndex(user.address, 0);
      expect(tokenId).to.equal(1);
    });
    
    it("tokenURIが正しいメタデータを返す", async function () {
      await bankedNFT.mint({ value: ethers.utils.parseEther("0.01") });
      
      const uri = await bankedNFT.tokenURI(1);
      
      // Base64 JSONが返ってくる
      expect(uri).to.include("data:application/json;base64,");
      
      // デコードして確認
      const base64 = uri.replace('data:application/json;base64,', '');
      const json = JSON.parse(Buffer.from(base64, 'base64').toString());
      
      expect(json).to.have.property('name');
      expect(json).to.have.property('description');
      expect(json).to.have.property('image');
      expect(json).to.have.property('attributes');
    });
  });
  
  // 統合テスト
  describe("4層統合テスト", function () {
    it("全層が連携して動作する", async function () {
      // 全層をデプロイ
      const MaterialBank = await ethers.getContractFactory("MonsterMaterialBank");
      const materialBank = await MaterialBank.deploy();
      
      const SVGComposer = await ethers.getContractFactory("MonsterSVGComposer");
      const svgComposer = await SVGComposer.deploy(materialBank.address);
      
      const TextComposer = await ethers.getContractFactory("MonsterTextComposer");
      const textComposer = await TextComposer.deploy();
      
      const MetadataBank = await ethers.getContractFactory("MonsterMetadataBankV5");
      const metadataBank = await MetadataBank.deploy(
        svgComposer.address,
        textComposer.address
      );
      
      const BankedNFT = await ethers.getContractFactory("BankedNFT");
      const bankedNFT = await BankedNFT.deploy(
        "Monster NFT",
        "MONSTER",
        10000,
        ethers.utils.parseEther("0.01"),
        250
      );
      
      await bankedNFT.setMetadataBank(metadataBank.address);
      
      // NFTをミント
      await bankedNFT.mint({ value: ethers.utils.parseEther("0.01") });
      
      // tokenURIを取得
      const uri = await bankedNFT.tokenURI(1);
      
      // メタデータをデコード
      const base64 = uri.replace('data:application/json;base64,', '');
      const json = JSON.parse(Buffer.from(base64, 'base64').toString());
      
      // 全要素が正しく含まれているか
      expect(json.name).to.include("#1");
      expect(json.description).to.include("touched");
      expect(json.image).to.include("data:image/svg+xml;base64,");
      expect(json.attributes.length).to.equal(4);
      
      // 画像もデコードして確認
      const imgBase64 = json.image.replace('data:image/svg+xml;base64,', '');
      const svg = Buffer.from(imgBase64, 'base64').toString();
      expect(svg).to.include('<svg');
      expect(svg).to.include('</svg>');
    });
  });
});

// モックコントラクトの例
contract MockMaterialBank {
    mapping(uint256 => mapping(uint256 => string)) testMaterials;
    
    function setTestMaterial(uint256 materialType, uint256 id, string memory data) external {
        testMaterials[materialType][id] = data;
    }
    
    function getMaterial(uint256 materialType, uint256 id) external view returns (string memory) {
        return testMaterials[materialType][id];
    }
    
    function isMaterialExists(uint256 materialType, uint256 id) external view returns (bool) {
        return bytes(testMaterials[materialType][id]).length > 0;
    }
}

contract MockSVGComposer {
    string testImage = "data:image/svg+xml;base64,default";
    
    function setTestImage(string memory _image) external {
        testImage = _image;
    }
    
    function composeSVG(uint8, uint8, uint8, uint8) external view returns (string memory) {
        return testImage;
    }
}

contract MockTextComposer {
    string testName = "Default Name";
    string testDescription = "Default Description";
    
    function setTestName(string memory _name) external {
        testName = _name;
    }
    
    function setTestDescription(string memory _desc) external {
        testDescription = _desc;
    }
    
    function composeName(uint256, uint8, uint8) external view returns (string memory) {
        return testName;
    }
    
    function composeDescription(uint8, uint8, uint8, uint8) external view returns (string memory) {
        return testDescription;
    }
}