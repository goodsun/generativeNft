# Mechanical Animals NFT Collection

動物の姿をした機械生命体のみが存在する世界を描いたピクセルアートNFTコレクション。

## 🎨 特徴

- **10種類のメカニカルアニマル（ユニットタイプ）**
  - Recon（偵察型 - 猫）
  - Sentinel（警備型 - 犬）
  - Velocity（高速型 - うさぎ）
  - Industrial（重工業型 - クマ）
  - Humanoid（人型 - 猫の姿だが自身を人間と認識）
  - Builder（建設型 - ブタ）
  - Cryo（極地型 - ペンギン）
  - Observer（監視型 - フクロウ）
  - BeeHive（群体型 - ニワトリ）
  - Multi-Purpose（汎用型 - ハムスター）

- **10種類のギア**
  - Bomb（爆弾）
  - Lightsaber（ライトセイバー）
  - Shield（エネルギーシールド）
  - Exotic Matter（エキゾチック物質）
  - Heat Rod（熱棒）
  - Missile Launcher（ミサイルランチャー）
  - Heat Hawk（ヒートホーク）
  - Utility Rod（汎用ロッド）
  - Robot Arm（ロボットアーム - レア）
  - Tragedy（悲劇 - 極レア：404の倍数でのみ出現）

- **10種類のドメイン**
  - Terminus（終着点）
  - Abyss（深淵）
  - Synthesis（統合）
  - Dominion（支配領域）
  - Neon（ネオン）
  - Ragnarok（終末）
  - Forge（鍛冶場）
  - Void（虚無）
  - Cryos（凍土）
  - Eclipse（日食）

- **10種類のイクイップメント**
  - Quantum Reactor（量子リアクター）
  - Shield Module（シールドモジュール）
  - Spectrum Scanner（スペクトラムスキャナー）
  - Cloaking Device（光学迷彩装置）
  - Drones（ドローン群）
  - Matrix（マトリックス）
  - EMP Generator（EMPジェネレーター）
  - Sonar Array（ソナーアレイ）
  - Beacon Transmitter（ビーコン送信機）
  - Active Attitude System（アクティブ姿勢制御システム）

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
robot/
├── index.html          # メインのWebインターフェース
├── generate.js         # NFT生成ロジック
├── api.php            # メタデータAPI
├── assets/
│   ├── robots/        # ロボットのSVGファイル
│   └── items/         # ギアのSVGファイル
└── README.md          # このファイル
```

## 🎨 カスタマイズ

### 新しいユニットやギアの追加
1. `assets/robots/`または`assets/items/`に新しいSVGファイルを追加
2. `generate.js`と`api.php`の配列に新しいエントリを追加

### ドメインの変更
`generate.js`の`colorSchemes`配列を編集して、新しい色の組み合わせを追加できます。

## 🌟 特別な機能

- **NFT名**: `[Unit Type] with [Gear] #[ID]`形式（例：Sentinel with Lightsaber #123）
- **Tragedy（悲劇）**: 404の倍数のIDでのみ出現する唯一の有機物の痕跡
  - 例：ID 404では、情報の海（Matrix）に囚われたHumanoidがTragedyを抱える
- **動的な色変換**: 各ドメインでユニットの色相が自動的に変換
- **ギアの位置調整**: すべてのギアは統一された位置に配置
- **アニメーションエフェクト**: 各イクイップメントには独自のアニメーションが付属

## 🌍 世界観

有機生命体が消滅し、動物の姿をした機械生命体のみが存在する世界。各メカニカルアニマルは異なるドメイン（領域）で活動し、様々なギアとイクイップメントを装備して生き延びている。

唯一の例外が「Tragedy」- 404エラーの時にのみ現れる、最後の有機物の痕跡。それを抱えるHumanoidは、猫の姿をしながらも自らを人間だと信じているユニットである。

## 📝 ライセンス

このプロジェクトはサンプルコードとして提供されています。