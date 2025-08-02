# Pixel Monsters NFT Collection Design Document

## 概要
Pixel Monsters NFTは、ダークファンタジーをテーマにしたピクセルアートNFTコレクションです。
各NFTは4つの要素の組み合わせによって生成され、特定の組み合わせには特別なストーリーと称号が付与されます。

## 構成要素

### 1. Species (モンスター種族) - 10種類
- **Werewolf** - 人狼
- **Goblin** - ゴブリン
- **Frankenstein** - フランケンシュタインの怪物
- **Demon** - 悪魔
- **Dragon** - ドラゴン
- **Zombie** - ゾンビ
- **Vampire** - 吸血鬼
- **Mummy** - ミイラ
- **Succubus** - サキュバス
- **Skeleton** - スケルトン

### 2. Equipment (装備アイテム) - 10種類
- **Crown** - 王冠
- **Sword** - 剣
- **Shield** - 盾
- **Poison** - 毒薬
- **Torch** - 松明
- **Wine** - ワイン
- **Scythe** - 大鎌
- **Magic Wand** - 魔法の杖
- **Arm** - 腕
- **Head** - 頭部

### 3. Realm (領域/色彩) - 10種類
- **Bloodmoon** - 血月（赤系）
- **Abyss** - 深淵（深青系）
- **Decay** - 腐敗（病的な緑系）
- **Corruption** - 堕落（紫系）
- **Venom** - 毒（ピンク・紫系）
- **Void** - 虚無（暗紫系）
- **Inferno** - 地獄の業火（炎色系）
- **Frost** - 凍結（氷色系）
- **Ragnarok** - 終末（金色系）
- **Shadow** - 影（グレー系）

### 4. Curse (呪いの属性) - 10種類
- **Seizure** - 発作（穏やかな点滅）
- **Mind Blast** - 精神波動（同心円状の波紋）
- **Confusion** - 混乱（虹色グラデーション）
- **Meteor** - 流星群（斜めに流れる星）
- **Bats** - コウモリの群れ
- **Poisoning** - 毒素（上昇する泡）
- **Lightning** - 稲妻（瞬間的な閃光）
- **Blizzard** - 吹雪（斜めの雪）
- **Burning** - 燃焼（3つの炎）
- **Brain Wash** - 洗脳（回転する催眠パターン）

## レアリティシステム

### 基本レアリティ（確率ベース）
- **Common** (40%)
- **Uncommon** (30%)
- **Rare** (15%)
- **Epic** (10%)
- **Legendary** (5%)

### レアリティ向上要因
1. **Special Combos** - 特定の組み合わせでレアリティが自動的に上昇
2. **Legendary IDs** - 特定のトークンID（666, 1337, 9999など）
3. **Synergy Bonuses** - 要素間の相性による追加ボーナス

## ストーリーシステム

### 1. Dual Synergy (2要素の相性)

#### Species + Equipment Combos (実装済み)
- **Vampire + Wine** = "Blood Sommelier" (Legendary)
- **Skeleton + Scythe** = "Death's Herald" (Legendary)
- **Dragon + Crown** = "The Fallen Monarch" (Legendary)
- **Demon + Torch** = "Infernal Lightkeeper" (Legendary)
- **Werewolf + Head** = "The Alpha's Trophy" (Legendary)
- **Frankenstein + Arm** = "The Collector" (Epic)
- **Mummy + Magic Wand** = "Pharaoh's Awakening" (Epic)
- **Goblin + Poison** = "Plague Alchemist" (Epic)
- **Succubus + Shield** = "Temptress Guardian" (Epic)
- **Zombie + Poison** = "Patient Zero" (Epic)

#### Curse + Realm Synergies (提案)
完璧な相性を持つ組み合わせ：
- **Burning + Inferno** = "Eternal Flame" (永遠の業火)
- **Blizzard + Frost** = "Absolute Zero" (絶対零度)
- **Poisoning + Venom** = "Toxic Miasma" (毒気瘴気)
- **Mind Blast + Void** = "Mental Collapse" (精神崩壊)
- **Lightning + Bloodmoon** = "Crimson Thunder" (紅雷)
- **Brain Wash + Corruption** = "Mind Corruption" (精神汚染)
- **Meteor + Ragnarok** = "Apocalypse Rain" (終末の雨)
- **Bats + Shadow** = "Night Terror" (夜の恐怖)
- **Confusion + Decay** = "Madness Plague" (狂気の疫病)
- **Seizure + Abyss** = "Deep Tremor" (深淵の震え)

### 2. Triple Synergy (3要素の相性)

#### Perfect Trinity Combos (提案)
特定の3要素が完璧に調和する組み合わせ：

**炎の三位一体**
- Dragon + Torch + Burning = "Primordial Flame Lord"
- Demon + Torch + Inferno = "Hell's Gatekeeper"

**死の三位一体**
- Skeleton + Scythe + Shadow = "Death Incarnate"
- Zombie + Head + Decay = "Undead Overlord"

**精神の三位一体**
- Succubus + Wine + Brain Wash = "Mind Seductress"
- Vampire + Crown + Mind Blast = "Psychic Monarch"

**自然の三位一体**
- Werewolf + Arm + Bloodmoon = "Lunar Beast"
- Mummy + Magic Wand + Ragnarok = "Ancient Apocalypse"

### 3. Quad Synergy (4要素の完璧な調和)

#### Ultimate Combinations (提案)
全4要素が完璧に調和する究極の組み合わせ（0.01%の確率）：

1. **Dragon + Crown + Ragnarok + Meteor** = "Cosmic Sovereign"
   - 宇宙の支配者、終末をもたらす存在

2. **Vampire + Wine + Bloodmoon + Burning** = "Crimson Phoenix"
   - 不死の炎を宿す血の不死鳥

3. **Skeleton + Scythe + Shadow + Mind Blast** = "Soul Harvester"
   - 魂を刈り取る究極の死神

4. **Demon + Torch + Inferno + Lightning** = "Hellstorm Avatar"
   - 地獄の嵐を具現化した存在

5. **Werewolf + Head + Abyss + Confusion** = "Lunatic Alpha"
   - 血月の狂気に支配された群れのリーダー

6. **Succubus + Magic Wand + Corruption + Brain Wash** = "Mind Empress"
   - 精神を支配する堕落の女帝

## Special Token IDs (実装済み)

### Legendary IDs
- **666** - "The Beast Awakened" (強制: Demon + Crown)
- **1337** - "The Chosen One"
- **9999** - "The Final Guardian"
- **404** - "The Lost Soul"
- **7777** - "Fortune's Avatar"
- **13** - "The Cursed" (強制: Head装備)
- **1000** - "The Millennial"
- **42** - "The Answer"

## 実装優先度

### Phase 1 (実装済み)
- [x] 基本的な4要素の組み合わせ生成
- [x] Species + Equipment のSpecial Combos
- [x] Legendary IDs
- [x] 基本レアリティシステム

### Phase 2 (提案)
- [ ] Curse + Realm のSynergy実装
- [ ] Synergy によるレアリティボーナス
- [ ] 追加のストーリーテキスト

### Phase 3 (将来的な拡張)
- [ ] Triple Synergy の実装
- [ ] Quad Synergy の実装
- [ ] 動的なレアリティ計算システム
- [ ] コミュニティ投票による新Combo追加

## 技術仕様

### レアリティ計算ロジック（提案）
```javascript
function calculateRarity(species, equipment, realm, curse, tokenId) {
    let baseRarity = getBaseRarity(tokenId);
    
    // Special Combo ボーナス
    if (hasSpecialCombo(species, equipment)) {
        baseRarity = upgradeRarity(baseRarity, 2);
    }
    
    // Curse + Realm Synergy ボーナス
    if (hasCurseRealmSynergy(curse, realm)) {
        baseRarity = upgradeRarity(baseRarity, 1);
    }
    
    // Triple Synergy ボーナス
    if (hasTripleSynergy(species, equipment, curse)) {
        baseRarity = upgradeRarity(baseRarity, 3);
    }
    
    // Quad Synergy ボーナス（最高レアリティ確定）
    if (hasQuadSynergy(species, equipment, realm, curse)) {
        return 'Mythic'; // 新レアリティ層
    }
    
    return baseRarity;
}
```

## まとめ
このシステムにより、単純なランダム生成を超えた、深いストーリー性と収集価値を持つNFTコレクションを実現します。プレイヤーは特定の組み合わせを狙って収集し、コミュニティ内で取引することで、エコシステムが活性化されます。
