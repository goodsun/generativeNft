# Pixel Animals NFT Collection

ピクセルアート風の動物NFTコレクションジェネレーターです。

## 🎨 特徴

- **10種類のピクセルアート動物**
  - Cat（猫）
  - Dog（犬）
  - Rabbit（うさぎ）
  - Bear（クマ）
  - Fox（キツネ）
  - Pig（ブタ）
  - Penguin（ペンギン）
  - Owl（フクロウ）
  - Chicken（ニワトリ）
  - Hamster（ハムスター）

- **10種類のアイテム**
  - Crown（王冠）
  - Sword（剣）
  - Shield（盾）
  - Potion（ポーション）
  - Lantern（ランタン）
  - Scroll（巻物）
  - Wine（ワイングラス）
  - Beer（ビールジョッキ）
  - Ice Cream（ソフトクリーム）
  - Heart（ハート）

- **10種類のカラースキーム**
  - Sunset（夕焼け）
  - Ocean（海）
  - Forest（森）
  - Royal（王室）
  - Candy（キャンディ）
  - Night（夜）
  - Fire（炎）
  - Ice（氷）
  - Gold（金）
  - Shadow（影）

- **10種類のエフェクト**
  - Sparkle（キラキラ）
  - Glow（光輪）
  - Rainbow（虹）
  - Stars（星）
  - Hearts（ハート）
  - Bubbles（泡）
  - Lightning（稲妻）
  - Ripple（波紋）
  - Pulse（パルス）
  - Minimal（ミニマル）

## 🚀 使い方

### Webインターフェース
1. `index.html`をブラウザで開く
2. 以下の機能が利用可能：
   - **Generate Single**: ランダムなNFTを1つ生成
   - **Generate Batch**: 5個または10個のNFTを一括生成
   - **Generate by ID**: 特定のID（1-10000）のNFTを生成
   - **Prev/Next ID**: 前後のIDに移動
   - **Copy Link**: メタデータAPIのリンクをコピー
   - **Download All as JSON**: 生成したメタデータをJSONファイルでダウンロード

### APIエンドポイント
```
api.php?id=123
```
指定したIDのNFTメタデータをJSON形式で返します。

## 🎯 仕組み

- **確定的生成**: 同じIDからは常に同じ組み合わせのNFTが生成されます
- **10,000通りの組み合わせ**: 10×10×10×10 = 10,000種類のユニークなNFT
- **レアリティ**: IDに基づいて自動的にレアリティが決定
  - Common（50%）
  - Uncommon（20%）
  - Rare（15%）
  - Epic（10%）
  - Legendary（5%）

## 📁 ファイル構成

```
animal/
├── index.html          # メインのWebインターフェース
├── generate.js         # NFT生成ロジック
├── api.php            # メタデータAPI
├── assets/
│   ├── animals/       # 動物のSVGファイル
│   └── items/         # アイテムのSVGファイル
└── README.md          # このファイル
```

## 🎨 カスタマイズ

### 新しい動物やアイテムの追加
1. `assets/animals/`または`assets/items/`に新しいSVGファイルを追加
2. `generate.js`と`api.php`の配列に新しいエントリを追加

### カラースキームの変更
`generate.js`の`colorSchemes`配列を編集して、新しい色の組み合わせを追加できます。

## 🌟 特別な機能

- **NFT名**: `[Color Scheme] [Animal] #[ID]`形式（例：Forest Dog #123）
- **動的な色変換**: 各カラースキームで動物の色相が自動的に変換
- **アイテムの位置調整**: 王冠は頭の上、その他は手元に配置
- **アニメーションエフェクト**: 各エフェクトには独自のアニメーションが付属

## 📝 ライセンス

このプロジェクトはサンプルコードとして提供されています。