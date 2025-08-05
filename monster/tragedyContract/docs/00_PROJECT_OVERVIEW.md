# 🎭 Tragedy NFT: JavaScript → Solidity 移植プロジェクト

## プロジェクト概要

このドキュメントシリーズは、JavaScript ベースの generative NFT システムを Solidity の 4層アーキテクチャに移植する完全なガイドです。実際の開発過程をステップバイステップで記録し、再現可能な開発手順書として機能します。

---

## 📚 ドキュメント構成

1. **00_PROJECT_OVERVIEW.md** (本書)
   - プロジェクトの全体像
   - ゴールと成果物

2. **01_JS_ANALYSIS.md**
   - 既存JavaScriptコードの分析
   - 移植対象の特定

3. **02_LAYER4_MATERIAL.md**
   - MaterialBank層の実装
   - SVGとテキスト素材の移植

4. **03_LAYER3_COMPOSER.md**
   - Composer層の実装
   - 合成ロジックの移植

5. **04_LAYER2_METADATA.md**
   - MetadataBank層の実装
   - JSON生成ロジック

6. **05_LAYER1_NFT.md**
   - NFT層の実装
   - コントラクトの統合

7. **06_TESTING_DEPLOYMENT.md**
   - テスト戦略
   - デプロイメント手順

8. **07_LESSONS_LEARNED.md**
   - 学んだこと
   - ベストプラクティス

---

## 🎯 プロジェクトゴール

### 主要目標
1. **完全な機能移植**: JS版の全機能をSolidityで再現
2. **ガス効率の最適化**: 80%以上のガス削減
3. **拡張性の確保**: 将来の機能追加を容易に
4. **開発手順書の作成**: 他プロジェクトでも使える汎用ガイド

### 成果物
- ✅ 4層アーキテクチャのスマートコントラクト群
- ✅ 包括的なテストスイート
- ✅ デプロイメントスクリプト
- ✅ 完全な開発ドキュメント

---

## 🏗️ アーキテクチャ概要

```
┌─────────────────────────────────────┐
│         TragedyNFT Contract         │ ← Layer 1
├─────────────────────────────────────┤
│        TragedyMetadataBank          │ ← Layer 2
├─────────────────────────────────────┤
│   SVGComposer  |  TextComposer     │ ← Layer 3
├─────────────────────────────────────┤
│         TragedyMaterialBank         │ ← Layer 4
└─────────────────────────────────────┘
```

---

## 📅 開発スケジュール

| フェーズ | 期間 | 内容 | ドキュメント |
|---------|------|------|-------------|
| 分析 | Day 1-2 | JS コード分析 | 01_JS_ANALYSIS.md |
| Layer 4 | Day 3-5 | MaterialBank実装 | 02_LAYER4_MATERIAL.md |
| Layer 3 | Day 6-8 | Composer実装 | 03_LAYER3_COMPOSER.md |
| Layer 2 | Day 9-10 | MetadataBank実装 | 04_LAYER2_METADATA.md |
| Layer 1 | Day 11-12 | NFT実装 | 05_LAYER1_NFT.md |
| テスト | Day 13-14 | 統合テスト | 06_TESTING_DEPLOYMENT.md |
| 完成 | Day 15 | ドキュメント完成 | 07_LESSONS_LEARNED.md |

---

## 🛠️ 開発環境

### 必要なツール
- Node.js v16+
- Hardhat
- OpenZeppelin Contracts
- Chai (テスト用)

### ディレクトリ構造
```
tragedyContract/
├── docs/           # このドキュメント群
├── contracts/      # Solidityコントラクト
│   ├── layer4/    # MaterialBank
│   ├── layer3/    # Composers
│   ├── layer2/    # MetadataBank
│   └── layer1/    # NFT
├── test/          # テストファイル
└── scripts/       # デプロイスクリプト
```

---

## 📈 成功指標

1. **機能の完全性**
   - [ ] 10,000通りの組み合わせ生成
   - [ ] シナジーシステムの実装
   - [ ] レジェンダリーIDの対応

2. **パフォーマンス**
   - [ ] tokenURI: < 150,000 gas
   - [ ] mint: < 200,000 gas
   - [ ] メタデータ生成: < 100,000 gas

3. **保守性**
   - [ ] 95%以上のテストカバレッジ
   - [ ] 完全なドキュメント
   - [ ] モジュラーな設計

---

## 💡 重要な学び

### 技術的課題と対策
- **ガス効率**: SVG簡略化とテンプレート使用
- **コード組織**: 4層アーキテクチャで責任分離  
- **保守性**: 各層の独立性確保
- **コントラクトサイズ制限**: **初期設計時のライブラリ分割が重要**

### 推奨アーキテクチャパターン
```
contracts/libraries/
├── BGSVGLib.sol        // 背景SVG専用
├── CharacterSVGLib.sol // キャラクターSVG専用
├── ItemSVGLib.sol      // アイテムSVG専用
└── EffectSVGLib.sol    // エフェクトSVG専用
```

**なぜライブラリ分割が重要？**
- Solidityの24KB制限は思った以上に厳しい
- 後からの分割は手間が倍増する
- 初期設計で考慮すれば開発がスムーズ

---

## 🚀 始めましょう！

次のドキュメント: [01_JS_ANALYSIS.md](./01_JS_ANALYSIS.md) で、既存のJavaScriptコードを分析していきます。

---

*"From JavaScript chaos to Solidity elegance"* 🎭