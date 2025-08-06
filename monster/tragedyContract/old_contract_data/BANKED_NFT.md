# BankedNFT システム仕様書

## 概要

BankedNFT は、メタデータ管理を外部コントラクト（MetadataBank）に委譲することで、柔軟で拡張性の高い NFT システムを実現するスマートコントラクトです。

## アーキテクチャ

```
┌─────────────┐         ┌─────────────────┐
│  BankedNFT  │────────▶│  MetadataBank   │
│             │         │  (Interface)     │
└─────────────┘         └─────────────────┘
                               ▲
                               │ implements
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
┌───────────────┐    ┌─────────────────┐    ┌───────────────┐
│SimpleMetadata │    │OnchainMetadata │    │HardcodedMeta  │
│    Bank       │    │     Bank        │    │   dataBank    │
└───────────────┘    └─────────────────┘    └───────────────┘
```

## 主要コンポーネント

### 1. BankedNFT.sol

メインの NFT コントラクト。ERC721 の全機能に加え、MetadataBank との連携機能を提供。

### 2. MetadataBank インターフェース

```solidity
interface IMetadataBank {
    function getMetadata(uint256 index) external view returns (string memory);
    function getMetadataCount() external view returns (uint256);
    function getRandomMetadata(uint256 seed) external view returns (string memory);
}
```

## 機能詳細

### ミント機能

#### 1. `mint()` - 自分にミント

```solidity
function mint() public payable returns (uint256)
```

- 送信者に NFT をミント
- mintFee の支払いが必要
- 余剰分は自動返金

#### 2. `airdrop(address to)` - エアドロップ

```solidity
function airdrop(address to) external onlyOwner returns (uint256)
```

- 指定アドレスに無料でミント
- オーナーのみ実行可能

#### 3. `mintSoulBound()` - SoulBound NFT をミント

```solidity
function mintSoulBound() external payable returns (uint256)
```

- 転送不可能な NFT をミント
- 送信者にミント

#### 4. `airdropSoulBound(address to)` - SoulBound NFT をエアドロップ

```solidity
function airdropSoulBound(address to) external onlyOwner returns (uint256)
```

- 転送不可能な NFT を指定アドレスにエアドロップ
- オーナーのみ実行可能

### メタデータ管理

#### tokenURI 生成の仕組み

1. BankedNFT の`tokenURI()`が呼ばれる
2. 設定された MetadataBank の`getMetadata()`を呼び出し
3. tokenId をインデックスとして使用（tokenId-1 でゼロベース）
4. MetadataBank が返すメタデータ URI をそのまま返す

```solidity
// tokenURI実装
uint256 index = (tokenId - 1) % metadataCount;
return metadataBank.getMetadata(index);
```

### 設定機能

#### `setMetadataBank(address bankAddress)`

- MetadataBank コントラクトのアドレスを設定
- オーナーのみ実行可能
- ゼロアドレスは設定不可

#### `config()`

- コレクション名、シンボル、mintFee、royaltyRate を変更
- オーナーのみ実行可能

## MetadataBank 実装例

### 1. SimpleMetadataBank

```solidity
// デプロイ時に固定のメタデータURIを設定
constructor(string[] memory _metadataURIs)
```

- コンストラクタで全メタデータを設定
- デプロイ後は変更不可

### 2. HardcodedMetadataBank

```solidity
// コード内にメタデータを直接記述
string[] private metadataList = [
    "ipfs://QmXxx1/metadata.json",
    "ipfs://QmXxx2/metadata.json",
    // ...
];
```

- コンパイル時にメタデータが確定
- 最もシンプルな実装

### 3. OnchainMetadataBank

```solidity
// JSONメタデータを動的に生成
return string(abi.encodePacked(
    "data:application/json;base64,",
    Base64.encode(bytes(json))
));
```

- 完全オンチェーンでメタデータ生成
- SVG 画像も含めることが可能

## 使用例

### 基本的な使用方法

```solidity
// 1. MetadataBankをデプロイ
HardcodedMetadataBank bank = new HardcodedMetadataBank();

// 2. BankedNFTをデプロイ
BankedNFT nft = new BankedNFT(
    "My NFT Collection",  // name
    "MNFT",              // symbol
    10000,               // maxSupply
    0.01 ether,          // mintFee
    250                  // royaltyRate (2.5%)
);

// 3. MetadataBankを設定
nft.setMetadataBank(address(bank));

// 4. ミント
nft.mint{value: 0.01 ether}();
```

### 進化システムの実装例

```solidity
// Phase 1: 子供キャラ
ChildMetadataBank childBank = new ChildMetadataBank();
nft.setMetadataBank(address(childBank));

// Phase 2: 大人キャラに進化
AdultMetadataBank adultBank = new AdultMetadataBank();
nft.setMetadataBank(address(adultBank));
// 全NFTの見た目が大人バージョンに変化
```

## セキュリティ考慮事項

### アクセス制御

- `onlyOwner`修飾子による管理機能の保護
- MetadataBank の設定はオーナーのみ
- エアドロップ機能はオーナーのみ

### 資金管理

- mintFee の余剰分は自動返金
- `withdraw()`でコントラクト残高を引き出し可能（オーナーのみ）
- ロイヤリティはコントラクトアドレスに設定

### SoulBound トークン

- 転送前に SoulBound フラグをチェック
- ミントとバーンは可能、転送のみ制限

## ガスコスト目安

| 操作              | 推定ガス         | 備考                    |
| ----------------- | ---------------- | ----------------------- |
| mint()            | 150,000-200,000  | MetadataBank 次第       |
| airdrop()         | 130,000-180,000  | mintFee 不要            |
| tokenURI()        | 50,000-1,000,000 | MetadataBank 実装による |
| setMetadataBank() | 50,000           | 一度だけ実行            |

## 拡張可能性

### 1. 動的メタデータ

- 時間経過で変化するメタデータ
- ユーザーアクションによる変化
- 外部データ（オラクル）との連携

### 2. ゲーム要素

- レベルシステム
- ステータス管理
- アイテム装備

### 3. コミュニティ機能

- 投票によるメタデータ変更
- コラボレーション機能
- ソーシャル要素

## まとめ

BankedNFT システムは、NFT コントラクトとメタデータ管理を分離することで：

- ✅ **柔軟性**: 様々なメタデータ実装に対応
- ✅ **拡張性**: 新機能を後から追加可能
- ✅ **効率性**: ガスコストの最適化
- ✅ **永続性**: 完全オンチェーン対応可能

これにより、革新的で動的な NFT プロジェクトの実現が可能になります。
