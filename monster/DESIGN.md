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
- **Goblin + Sword** = "Blade Master" (Epic)
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
- Dragon + Sword + Burning = "Primordial Flame Lord"
- Demon + Torch + Inferno = "Hell's Gatekeeper"

**死の三位一体**
- Skeleton + Scythe + Shadow = "Death Incarnate"
- Zombie + Head + Decay = "Undead Overlord"

**精神の三位一体**
- Succubus + Wine + Brain Wash = "Mind Seductress"
- Vampire + Crown + Mind Blast = "Psychic Monarch"
- Vampire + Wine + Bats = "Classic Nosferatu" (特別枠・自動Legendary)

**自然の三位一体**
- Werewolf + Arm + Bloodmoon = "Lunar Beast"
- Mummy + Void + Ragnarok = "Ancient Apocalypse"

**狂気の三位一体**
- Frankenstein + Lightning + Seizure = "Aberrant Creation"
- Goblin + Corruption + Confusion = "Mad Trickster"

**毒の三位一体**
- Poison + Venom + Poisoning = "Toxic Trinity"

**氷の三位一体**
- Shield + Frost + Blizzard = "Frozen Fortress"

**宇宙の三位一体**
- Magic Wand + Abyss + Meteor = "Cosmic Sorcery"

### 3. Quad Synergy (4要素の完璧な調和)

#### Ultimate Combinations (提案)
全4要素が完璧に調和する究極の組み合わせ（0.01%の確率）：

1. **Dragon + Crown + Ragnarok + Meteor** = "Cosmic Sovereign"
   - 宇宙の支配者、終末をもたらす存在

2. **Skeleton + Scythe + Shadow + Mind Blast** = "Soul Harvester"
   - 魂を刈り取る究極の死神

3. **Vampire + Wine + Bloodmoon + Bats** = "Crimson Lord"
   - 血月の下、蝙蝠を従える真紅の支配者

4. **Demon + Torch + Inferno + Lightning** = "Hellstorm Avatar"
   - 地獄の嵐を具現化した存在

5. **Succubus + Magic Wand + Corruption + Brain Wash** = "Mind Empress"
   - 精神を支配する堕落の女帝

6. **Mummy + Sword + Void + Burning** = "Eternal Warrior"
   - 虚無の炎を纏う不滅の古代戦士

7. **Frankenstein + Poison + Venom + Seizure** = "Toxic Abomination"
   - 毒に侵された不死の怪物、その体は常に痙攣している

8. **Werewolf + Head + Abyss + Confusion** = "Lunatic Alpha"
   - 血月の狂気に支配された群れのリーダー

9. **Zombie + Arm + Decay + Poisoning** = "Rotting Collector"
   - 腐敗した腕を収集する毒に満ちた屍者

10. **Goblin + Shield + Frost + Blizzard** = "Frozen Guardian"
    - 永久凍土を守護する氷の小鬼

## Special Token IDs

### Legendary IDs (30個 - 全体の0.3%)
特定のトークンIDには特別な意味とストーリーが付与され、自動的にLegendaryレアリティになります。

#### 1-1000 (17個 - 初期の1.7%)
- **1** - "The Genesis" - 最初の存在、すべての始まり
- **7** - "The Seventh Seal" - 黙示録の第七の封印
- **13** - "The Cursed" - 西洋で最も不吉な数字 (強制: Amulet装備)
- **23** - "The Enigma" - 呪われた偶然の数字
- **42** - "The Answer" - 生命、宇宙、すべての答え
- **86** - "The Vanisher" - 闇に葬る者
- **100** - "The Centurion" - 百人隊長、最初の大台
- **111** - "Trinity Gate" - 三位一体の門
- **187** - "Death's Contract" - カリフォルニア州刑法の殺人コード
- **217** - "The Shining" - 『シャイニング』の呪われた部屋番号
- **333** - "The Half Beast" - 獣の数字の半分
- **404** - "The Lost Soul" - Not Found - 存在しない者
- **555** - "The Pentacle" - 五芒星、変化の数字
- **616** - "The True Beast" - 初期聖書写本での獣の数字
- **666** - "The Beast Awakened" - 黙示録の獣 (強制: Demon + Crown)
- **777** - "Lucky Seven" - 幸運と呪いの境界
- **911** - "The Final Call" - 最後の助けを求める叫び
- **999** - "The Gatekeeper" - 地獄への門番

#### 1001-2000 (8個 - 中期の0.8%)
- **1000** - "The Millennial" - 千年紀の審判者
- **1111** - "The Awakening" - 目覚めの時、願いの時刻
- **1337** - "The Chosen One" - エリート（1337 = LEET）
- **1347** - "The Black Death" - 黒死病がヨーロッパに到達
- **1408** - "The Haunted Room" - スティーブン・キングの呪われた部屋
- **1492** - "The Discovery" - コロンブスの新大陸「発見」
- **1692** - "The Witch Hunter" - セイラム魔女裁判
- **1776** - "The Revolution" - アメリカ独立宣言（血で購われた自由）

#### 2001-10000 (5個 - 後期の超レア0.06%)
- **2187** - "The Exponential Death" - 3の7乗、七つの力
- **3141** - "Pi's Madness" - 円周率π、無限に続く狂気
- **4077** - "The Field Medic" - M*A*S*H野戦病院部隊
- **5150** - "The Insane" - 精神錯乱による強制拘束（カリフォルニア州法）
- **6174** - "Kaprekar's Curse" - 数学的に呪われた数（カプレカ定数）
- **7777** - "Fortune's Avatar" - 四つの七、究極の幸運か破滅か
- **8128** - "Perfect Despair" - 完全数（古代ギリシャの神秘数）
- **9999** - "The Final Guardian" - 最後の守護者、終末の番人

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
