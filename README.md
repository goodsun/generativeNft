# NFT Metadata Generator

10,000通りの組み合わせを持つNFTメタデータ生成システムです。各NFTは固有のビジュアルエフェクトとアニメーションを持ち、ID指定で常に同じ結果を再現できます。

## 概要

- **10 × 10 × 10 × 10 = 10,000通り**の組み合わせ
- ID指定で決定的生成（同じIDは常に同じNFT）
- Power Levelに応じた10種類のアニメーションエフェクト
- 動的SVG画像生成とアニメーション

## 構成要素

### 4つの属性（各10種類）

1. **Bloodline（血統）**: Dragon, Phoenix, Unicorn, Griffin, Sphinx, Kraken, Pegasus, Hydra, Minotaur, Chimera
2. **Ancient Force（古の力）**: Mystical, Legendary, Cosmic, Ancient, Ethereal, Radiant, Shadow, Crystal, Golden, Silver
3. **Elemental Affinity（元素親和性）**: Red, Blue, Green, Purple, Gold, Silver, Black, White, Rainbow, Crystal
4. **Arcane Potency（秘術力）**: 1-100のPower Level

### 10種類のビジュアルエフェクト

1. **1-10**: 回転する光の粒子
2. **11-20**: 3つの星
3. **21-30**: 回転する魔法陣
4. **31-40**: パルスする輪
5. **41-50**: 反対方向に回転する光線
6. **51-60**: 回転するダイヤモンド
7. **61-70**: グラデーションオーラ
8. **71-80**: ダビデの星（六芒星）
9. **81-90**: 螺旋パターン
10. **91-100**: 究極エフェクト（星と虹色の輪）

## 使い方

### Web UI（index.html）

- **Generate Single**: ランダムなNFTを1つ生成
- **Generate Batch**: 5個または10個を一括生成
- **Generate by ID**: 特定のID（1-10000推奨）でNFTを生成
- **Download All as JSON**: 生成したメタデータをダウンロード
- **Mint NFT**: ミントページへ移動

### ミントページ（summon.html）

- MetaMask連携でPolygonネットワークに接続
- 3 POLでNFTをミント（先着順で連番発行）
- 次にミントされるNFTのプレビュー表示
- 現在の供給量とウォレット接続状態を表示

### API（api.php）

```
GET api.php?id=1     # ID 1のNFTメタデータを取得
GET api.php?id=5000  # ID 5000のNFTメタデータを取得
```

### レスポンス例

```json
{
  "name": "Mystical Dragon #1",
  "description": "A rare gold dragon with mystical powers. This unique NFT is part of the legendary collection.",
  "image": "data:image/svg+xml;base64,...",
  "attributes": [
    {
      "trait_type": "Bloodline",
      "value": "Dragon"
    },
    {
      "trait_type": "Ancient Force",
      "value": "Mystical"
    },
    {
      "trait_type": "Elemental Affinity",
      "value": "Gold"
    },
    {
      "trait_type": "Arcane Potency",
      "value": 42
    }
  ]
}
```

## 技術仕様

- **画像**: SVGベースの動的生成（アニメーション付き）
- **エフェクトサイズ**: Power Levelに応じて0.7倍〜1.3倍に変化
- **決定的生成**: シード付き疑似乱数で同じIDは常に同じ結果
- **軽量実装**: 静的HTML + PHP（Node.js不要）

## ファイル構成

```
metasample/
├── index.html              # メインUI（ブラウザで直接開ける）
├── summon.html             # NFTミントページ（Web3対応）
├── api.php                 # JSON API（PHPサーバー必要）
├── NFTMetadataOnChain.sol  # Solidityスマートコントラクト
└── README.md               # このファイル
```

## Solidityスマートコントラクト

`NFTMetadataOnChain.sol`は、このNFTメタデータ生成システムを完全にオンチェーンで実装したERC721準拠のスマートコントラクトです。

### 主な機能

- **完全オンチェーン**: メタデータとSVG画像をすべてコントラクト内で生成
- **決定的生成**: tokenIdベースで常に同じ結果を生成
- **ガス最適化**: エフェクトを簡略化してガスコストを削減
- **Base64エンコード**: データURIとして直接使用可能

### コントラクトメソッド

```solidity
// NFTをミント（3 POL必要）
mint() payable

// 属性を個別に取得
getBloodline(uint256 tokenId) returns (string)
getAncientForce(uint256 tokenId) returns (string)
getElementalAffinity(uint256 tokenId) returns (string)
getArcanePotency(uint256 tokenId) returns (uint256)

// SVG画像を生成
generateSVG(uint256 tokenId) returns (string)

// 完全なメタデータを取得（ERC721準拠）
tokenURI(uint256 tokenId) returns (string)

// 現在の総供給量を取得
totalSupply() returns (uint256)

// コントラクトの残高を引き出す（オーナーのみ）
withdraw()
```

### コントラクト仕様

- **最大供給量**: 10,000個
- **ミント価格**: 3 POL（Polygon）
- **ミント方式**: 先着順で連番発行（ID: 1〜10,000）
- **引き出し**: オーナーのみ可能

### デプロイ時の注意

- OpenZeppelinの依存関係が必要
- Solidity 0.8.19以上を推奨
- Polygonネットワークでのデプロイを想定
- ガスコストを考慮してエフェクトは簡略版を使用

## デモ

https://dev2.bon-soleil.com/develop/metasample/

## ライセンス

自由に使用・改変可能です。