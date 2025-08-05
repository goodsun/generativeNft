# 📊 JavaScript Generation System 分析レポート

## 1. システム概要

### 1.1 基本構造
```javascript
// 4スロット × 10オプション = 10,000通り
const attributes = {
    species: 10,    // 種族
    equipment: 10,  // 装備
    realm: 10,      // 領域
    curse: 10       // 呪い
};
```

### 1.2 属性定義

#### Species (種族)
```javascript
const species = [
    "Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon",
    "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"
];
```

#### Equipment (装備)
```javascript
const equipment = [
    "Crown", "Sword", "Shield", "Poison", "Torch",
    "Wine", "Scythe", "Magic Wand", "Shoulder Armor", "Amulet"
];
```

#### Realm (領域)
```javascript
const realms = [
    "Bloodmoon", "Abyss", "Decay", "Corruption", "Venom",
    "Void", "Inferno", "Frost", "Ragnarok", "Shadow"
];
```

#### Curse (呪い)
```javascript
const curses = [
    "Seizure", "Mind Blast", "Confusion", "Meteor", "Bats",
    "Poisoning", "Lightning", "Blizzard", "Burning", "Brain Wash"
];
```

---

## 2. シナジーシステム

### 2.1 Quad Synergies (4属性一致) - Mythic
```javascript
const quadSynergies = [
    {
        species: "Dragon", equipment: "Crown", 
        realm: "Ragnarok", curse: "Meteor",
        title: "Cosmic Sovereign",
        rarity: 5 // Mythic
    },
    // ... 10種類の組み合わせ
];
```

**実装時の注意**: 装備変換も考慮
- `Shoulder Armor` → `Arm`
- `Amulet` → `Head`

### 2.2 Trinity Synergies (3属性一致)
```javascript
// 種族非依存の組み合わせ
{
    equipment: "Wine", realm: "Bloodmoon", curse: "Bats",
    title: "Classic Nosferatu",
    rarity: 4 // Legendary
}
```

### 2.3 Dual Synergies (2属性一致)
```javascript
// Species + Equipment
{ species: "Vampire", equipment: "Wine", title: "Blood Sommelier" }

// Curse + Realm
{ curse: "Mind Blast", realm: "Void", title: "Psychic Rift" }
```

---

## 3. 動的命名システム

### 3.1 パワーレベル計算
```javascript
const equipmentPower = {
    "Crown": 9, "Magic Wand": 8, "Sword": 7, "Scythe": 6,
    "Shield": 5, "Poison": 4, "Torch": 3, "Wine": 2,
    "Amulet": 1, "Shoulder Armor": 1
};

const cursePower = {
    "Mind Blast": 9, "Brain Wash": 8, "Meteor": 7, "Confusion": 6,
    "Lightning": 5, "Burning": 4, "Blizzard": 3, "Poisoning": 2,
    "Seizure": 1, "Bats": 1
};
```

### 3.2 名前生成ロジック
```javascript
function generateName(species, equipment, curse) {
    if (シナジーあり) return synergy.title;
    
    const ep = equipmentPower[equipment];
    const cp = cursePower[curse];
    
    if (ep > cp) {
        return `${equipment.replace(/ /g, '-')} ${species}`;
    } else {
        return `${curse.replace(/ /g, '-')} ${species}`;
    }
}
```

---

## 4. レジェンダリーID

### 4.1 特別なID (36個)
```javascript
const legendaryIds = {
    0: { title: "The Void", story: "..." },
    1: { title: "The Genesis", story: "..." },
    666: { 
        title: "The Beast Awakened",
        forced: { species: "Demon", equipment: "Crown" }
    },
    777: { title: "Lucky Seven" },
    1234: { title: "Sequential Master" },
    // ... 全36個
};
```

---

## 5. SVG生成プロセス

### 5.1 レイヤー構造
```javascript
1. Background (240x240)
2. Monster Layer (scaled)
3. Item Layer (positioned)
4. Effect Layer (animated)
```

### 5.2 色変換
```javascript
// Realm基準の色相回転
const hueRotation = {
    "Bloodmoon": 0,
    "Abyss": 250,
    "Decay": 130,
    // ...
};
```

### 5.3 アイテム配置
```javascript
const itemPositions = {
    "Crown": { y: -5 },
    "Shield": { x: -3 },
    "Sword": { x: 3 },
    // ...
};
```

---

## 6. Solidity実装への変換指針

### 6.1 データ構造の最適化
```solidity
// JSの配列 → Solidityの固定配列
string[10] private species = [
    "Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon",
    "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"
];

// シナジーはmappingで実装
mapping(bytes32 => Synergy) private synergies;
```

### 6.2 ガス最適化のポイント
1. **文字列結合の削減**: テンプレート使用
2. **SVG事前保存**: MaterialBankに格納
3. **計算の簡略化**: 複雑なロジックを事前計算

### 6.3 主要関数の設計
```solidity
// トークンIDから属性を決定
function decodeTokenId(uint256 tokenId) returns (uint8 s, uint8 e, uint8 r, uint8 c);

// シナジーチェック
function checkSynergies(uint8 s, uint8 e, uint8 r, uint8 c) returns (Synergy memory);

// 名前生成
function generateName(uint8 s, uint8 e, uint8 c) returns (string memory);
```

---

## 7. テストケース

移植完了後に確認すべき項目：

- [ ] 全10,000通りの組み合わせが生成可能
- [ ] Quad Synergy 10種類が正しく判定
- [ ] Trinity Synergy 17種類が正しく判定
- [ ] Dual Synergy 20種類が正しく判定
- [ ] 装備変換（Shoulder Armor→Arm）が機能
- [ ] レジェンダリーID 36個が正しく処理
- [ ] パワーレベルに基づく命名が正確
- [ ] レアリティ計算が一致

---

## 8. 次のステップ

このJS分析を基に、以下の順序で実装を進めます：

1. **Layer 4**: 全SVG素材をMaterialBankに格納
2. **Layer 3**: シナジー判定とテキスト生成をComposerに実装
3. **Layer 2**: メタデータ組み立てをMetadataBankに実装
4. **Layer 1**: NFTコントラクトで統合

次のドキュメント: [02_LAYER4_MATERIAL.md](./02_LAYER4_MATERIAL.md)

---

*"Understanding the past to build the future"* 📊