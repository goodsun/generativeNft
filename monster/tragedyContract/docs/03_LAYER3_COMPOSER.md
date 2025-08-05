# 🎨 Layer 3: Composer 実装ガイド

## 実装開始: 2025-01-21 13:00

このドキュメントでは、MaterialBankから素材を取得してSVGやテキストを合成するComposer層の実装過程を記録します。

---

## 1. 実装計画

### 1.1 必要なComposer

1. **TragedySVGComposer**: 4つのSVG要素を合成
2. **TragedySynergyChecker**: シナジー判定ロジック
3. **TragedyTextComposer**: 名前と説明文の生成

### 1.2 設計方針

- MaterialBankへの依存を最小限に
- ガス効率を考慮した文字列結合
- シナジー判定の最適化

---

## 2. 実装ログ

### 13:05 - SVGComposerインターフェース設計

```solidity
interface ITragedySVGComposer {
    function composeSVG(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (string memory);
}
```

### 13:10 - SVGComposer実装開始

主な課題：
- 4層のSVGを正しい順序で重ねる
- 座標とスケールの調整
- 色変換（realmによるhue-rotate）の適用

### 13:20 - シナジーチェッカー設計

```solidity
struct Synergy {
    string title;
    string story;
    uint8 rarity; // 0: None, 1: Rare, 2: Epic, 3: Legendary, 4: Mythic
    bool exists;
}
```

### 13:30 - テキストコンポーザー設計

動的な名前生成ロジック：
- シナジーがある場合：シナジータイトルを使用
- シナジーがない場合：装備と呪いのパワーレベルで決定

---

## 3. 実装上の課題と解決

### 課題1: シナジー判定の効率化
- **問題**: 全組み合わせをチェックすると高コスト
- **解決**: ハッシュマップで事前計算
- **実装**: keccak256でキーを生成

### 課題2: SVGの座標系
- **問題**: JSとSolidityで座標計算が異なる
- **解決**: 固定座標をハードコード
- **理由**: 動的計算よりガス効率が良い

---

## 4. 実装完了: 2025-01-21 14:00

所要時間: 1時間

### 実装結果サマリー
- ✅ SVGComposer実装（4層合成）
- ✅ SynergyChecker実装（47種類のシナジー）
- ✅ TextComposer実装（動的名前生成）
- ✅ 包括的なテストケース作成

*"Composition brings life to the materials!"* 🎨