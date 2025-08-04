# The Mythical Cursed-Nightmare NFT Contract Specification

## 概要
The Mythical Cursed-Nightmare は、10,000体の呪われたデジタルクリーチャーのNFTコレクションです。

## コントラクト基本情報

### 基本仕様
- **コントラクト名**: MythicalCursedNightmare
- **シンボル**: NIGHTMARE
- **規格**: ERC721（OpenZeppelin実装）
- **総供給量**: 10,000体（固定）
- **基本価格**: 0.005 ETH
- **ネットワーク**: Base Chain / Bon Soleil Testnet

### 技術仕様
- **Solidity バージョン**: ^0.8.20
- **OpenZeppelin Contracts**: v5.0.0
- **セキュリティ**: ReentrancyGuard実装

## Mint機能

### 1. 通常Mint (`mint`)
- **価格**: 0.005 ETH per NFT
- **最大購入数/トランザクション**: 10体
- **最大保有数/ウォレット**: 20体
- **条件**: mintEnabled または publicMintEnabled が true
- **超過支払い**: 自動返金

### 2. Watchword Mint (`watchwordMint`)
- **価格**: 0.003 ETH per NFT（40%割引）
- **対象**: watchwordListに登録されたアドレス
- **最大購入数**: 通常Mintと同じ
- **特典**: 特別なseed生成（"SOULBOUND"タグ付き）

### 3. Owner Mint (`ownerMint`)
- **価格**: 無料
- **権限**: オーナーのみ
- **用途**: Giveaway、チーム配布、マーケティング

## 制限事項

| 項目 | 値 | 変更可能 |
|------|-----|----------|
| MAX_SUPPLY | 10,000 | ❌ |
| price | 0.005 ETH | ✅ (owner) |
| maxPerWallet | 20 | ✅ (owner) |
| maxPerTransaction | 10 | ✅ (owner) |

## フェーズ管理

### Mint Phase
- **mintEnabled**: Watchword保有者向けMint開始
- **publicMintEnabled**: パブリックMint開始
- **両方false**: Mint停止状態

設定方法:
```solidity
setMintPhase(bool _mintEnabled, bool _publicMintEnabled)
```

## ランダム性とメタデータ

### Seed生成
各NFTに一意のseedを生成し、属性の決定に使用:
```solidity
tokenIdToSeed[tokenId] = keccak256(
    block.timestamp,
    block.prevrandao,
    msg.sender,
    tokenId
);
```

### クリーチャータイプ
- 10種類のクリーチャータイプ（seed % 10）
- tokenURIで動的に生成

### メタデータURI
形式: `ipfs://[CID]/[creatureType]/[tokenId].json`

## 管理者機能

| 関数名 | 機能 | 権限 |
|--------|------|------|
| setMintPhase | Mintフェーズ設定 | Owner |
| setPrice | 価格変更 | Owner |
| setMaxPerWallet | ウォレット制限変更 | Owner |
| setMaxPerTransaction | トランザクション制限変更 | Owner |
| addToWatchwordList | Watchwordリスト追加 | Owner |
| removeFromWatchwordList | Watchwordリスト削除 | Owner |
| setBaseURI | ベースURI変更 | Owner |
| setContractURI | コントラクトURI変更 | Owner |
| withdraw | 収益引き出し | Owner |

## 収益管理

### Withdraw
- **関数**: `withdraw()`
- **権限**: オーナーのみ
- **動作**: コントラクト残高全額をオーナーアドレスに送金
- **制限**: 残高が0の場合はエラー

## View関数

| 関数名 | 戻り値 | 説明 |
|--------|--------|------|
| totalSupply | uint256 | 現在のMint数 |
| maxSupply | uint256 | 最大供給量（10,000） |
| price | uint256 | 現在の価格 |
| mintedPerWallet | uint256 | ウォレットごとのMint数 |
| tokenIdToSeed | uint256 | トークンIDごとのseed値 |
| watchwordList | bool | Watchwordリスト登録状況 |
| tokenURI | string | NFTメタデータURI |
| contractURI | string | コレクションメタデータURI |

## イベント

```solidity
event NightmareSummoned(address indexed summoner, uint256 indexed tokenId);
event PhaseChanged(bool mintEnabled, bool publicMintEnabled);
event PriceUpdated(uint256 newPrice);
```

## セキュリティ機能

1. **ReentrancyGuard**: 再入攻撃防止
2. **Ownable**: 管理者機能の制限
3. **支払い検証**: 不足/超過の適切な処理
4. **供給量制限**: MAX_SUPPLY超過防止
5. **ウォレット制限**: 大量買い占め防止

## デプロイ手順

1. REMIXでコントラクトをコンパイル（Solidity 0.8.20+）
2. Bon Soleil Testnet（Chain ID: 21201）に接続
3. デプロイ実行
4. 初期設定:
   - `setBaseURI()` でIPFS URIを設定
   - `setMintPhase()` でMint開始
   - `addToWatchwordList()` で早期アクセス者を追加

## フロントエンド連携

### 必要なABI関数
- mint(uint256 quantity) payable
- watchwordMint(uint256 quantity) payable
- totalSupply() view
- maxSupply() view
- price() view
- tokenURI(uint256) view

### Web3 Integration
```javascript
// web3-integration.js の CONTRACT_CONFIG.addresses を更新
21201: '0xDEPLOYED_CONTRACT_ADDRESS'
```

## ガス最適化

- ERC721Aではなく標準ERC721を使用（Base Chainのガス代が安いため）
- バッチMintは10体まで制限
- 不要な処理を削減

## 今後の拡張可能性

- [ ] Reveal機能（メタデータの段階公開）
- [ ] Royalty設定（ERC2981）
- [ ] Staking機能
- [ ] 特別なホルダー特典
- [ ] クロスチェーンブリッジ

## 連絡先

- Twitter: [@mythOfTragedy](https://x.com/mythOfTragedy)
- Discord: [Join Server](https://discord.gg/sQ2nxm7w)
- Website: [The Mythical Cursed-Nightmare](https://yourdomain.com)

---

*Last Updated: 2024*
*Contract Version: 1.0.0*