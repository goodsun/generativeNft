// ピクセルアートモンスターNFTジェネレーター（ストーリー版）

// Node.js環境の場合のみrequireを使用
if (typeof require !== 'undefined') {
    // Node.js環境
    const synergies = require('./synergies');
    const nameGen = require('./name-generator');
    
    // グローバルに設定（Node.js用）
    global.checkSynergies = synergies.checkSynergies;
    global.calculateRarity = synergies.calculateRarity;
    global.generateBaseStory = synergies.generateBaseStory;
    global.generateDynamicName = nameGen.generateDynamicName;
    global.generateDynamicStory = nameGen.generateDynamicStory;
}
// ブラウザ環境では、各jsファイルが既にwindowに関数を定義済み

// 設定ファイルを保持する変数
let config = null;

// 設定ファイルを読み込む関数
async function loadConfig() {
    try {
        const response = await fetch('assets/config/attributes.json');
        if (response.ok) {
            config = await response.json();
            console.log('Configuration loaded successfully');
            return config;
        }
    } catch (error) {
        console.log('Failed to load config, using default values');
    }
    return null;
}

// デフォルト値（設定ファイルが読み込めない場合のフォールバック）
const monsters = [
    { name: 'Werewolf', file: 'werewolf.svg' },
    { name: 'Goblin', file: 'goblin.svg' },
    { name: 'Frankenstein', file: 'frankenstein.svg' },
    { name: 'Demon', file: 'demon.svg' },
    { name: 'Dragon', file: 'dragon.svg' },
    { name: 'Zombie', file: 'zombie.svg' },
    { name: 'Vampire', file: 'vampire.svg' },
    { name: 'Mummy', file: 'mummy.svg' },
    { name: 'Succubus', file: 'succubus.svg' },
    { name: 'Skeleton', file: 'skeleton.svg' }
];

const items = [
    { name: 'Crown', file: 'crown.svg' },
    { name: 'Sword', file: 'sword.svg' },
    { name: 'Shield', file: 'shield.svg' },
    { name: 'Poison', file: 'poison.svg' },
    { name: 'Torch', file: 'torch.svg' },
    { name: 'Wine', file: 'wine.svg' },
    { name: 'Scythe', file: 'scythe.svg' },
    { name: 'Magic Wand', file: 'staff.svg' },
    { name: 'Shoulder Armor', file: 'shoulder.svg', synergyForm: 'Arm' },
    { name: 'Amulet', file: 'amulet.svg', synergyForm: 'Head' }
];

const colorSchemes = [
    { name: 'Bloodmoon', primary: '#FF6B6B', secondary: '#4ECDC4', background: '#FFE66D', hueRotate: 0 },
    { name: 'Abyss', primary: '#0077BE', secondary: '#00A8E8', background: '#00F5FF', hueRotate: 200 },
    { name: 'Decay', primary: '#2D5016', secondary: '#73A942', background: '#AAD576', hueRotate: 90 },
    { name: 'Corruption', primary: '#6B5B95', secondary: '#B565A7', background: '#D64545', hueRotate: 270 },
    { name: 'Venom', primary: '#FF69B4', secondary: '#FFB6C1', background: '#FFC0CB', hueRotate: 330 },
    { name: 'Void', primary: '#1B1B3A', secondary: '#693668', background: '#51355A', hueRotate: 240 },
    { name: 'Inferno', primary: '#FF4500', secondary: '#FF6347', background: '#FFA500', hueRotate: 15 },
    { name: 'Frost', primary: '#4682B4', secondary: '#87CEEB', background: '#E0FFFF', hueRotate: 180 },
    { name: 'Ragnarok', primary: '#FFD700', secondary: '#FFA500', background: '#FFFFE0', hueRotate: 45 },
    { name: 'Shadow', primary: '#2F4F4F', secondary: '#696969', background: '#A9A9A9', hueRotate: 0, saturate: 0.3 }
];

const effects = [
    { name: 'Seizure' },
    { name: 'Mind Blast' },
    { name: 'Confusion' },
    { name: 'Meteor' },
    { name: 'Bats' },
    { name: 'Poisoning' },
    { name: 'Lightning' },
    { name: 'Blizzard' },
    { name: 'Burning' },
    { name: 'Brain Wash' }
];

// 設定から属性を取得するヘルパー関数
function getAttributeItems(slotNumber) {
    if (config && config.attributes && config.attributes[`slot${slotNumber}`]) {
        return config.attributes[`slot${slotNumber}`].items;
    }
    // フォールバック
    switch(slotNumber) {
        case 1: return monsters;
        case 2: return items;
        case 3: return colorSchemes;
        case 4: return effects;
        default: return [];
    }
}

// 属性名を取得
function getAttributeName(slotNumber) {
    if (config && config.attributes && config.attributes[`slot${slotNumber}`]) {
        return config.attributes[`slot${slotNumber}`].name;
    }
    // フォールバック
    switch(slotNumber) {
        case 1: return 'Species';
        case 2: return 'Equipment';
        case 3: return 'Realm';
        case 4: return 'Curse';
        default: return `Attribute${slotNumber}`;
    }
}

// 特殊なID用のイベントモンスター
const legendaryIds = {
    // 1-1000
    1: {
        title: 'The Genesis',
        story: 'The first of its kind, born from the primordial chaos. It has witnessed the birth of darkness itself.'
    },
    7: {
        title: 'The Seventh Seal',
        story: 'When the seventh seal breaks, the apocalypse begins. This creature guards the final barrier between worlds.'
    },
    13: {
        override: { item: 'Amulet' },
        title: 'The Cursed',
        story: 'Born on the darkest hour of the unluckiest day. Misfortune follows in its wake like a hungry shadow.'
    },
    23: {
        title: 'The Enigma',
        story: 'Everywhere it goes, the number follows. Twenty-three deaths, twenty-three curses, twenty-three seconds until madness.'
    },
    42: {
        title: 'The Answer',
        story: 'It knows the ultimate question that reality dare not ask. Its knowledge is a burden that breaks minds.'
    },
    86: {
        title: 'The Vanisher',
        story: 'Those who cross its path are "eighty-sixed" from existence. No trace, no memory, no soul remains.'
    },
    100: {
        title: 'The Centurion',
        story: 'Leader of the first hundred fallen. It commands legions that exist between life and death.'
    },
    111: {
        title: 'Trinity Gate',
        story: 'Three ones, three dimensions, three seconds to live once you see its true form. The gateway walks.'
    },
    187: {
        title: 'Death\'s Contract',
        story: 'A walking murder statute. Its very presence is a death sentence waiting to be executed.'
    },
    217: {
        title: 'The Shining',
        story: 'From room 217 it emerged, carrying the madness of a thousand winters. REDRUM is its only word.'
    },
    333: {
        title: 'The Half Beast',
        story: 'Half the number, twice the hunger. What it lacks in completion, it takes from others\' souls.'
    },
    404: {
        title: 'The Lost Soul',
        story: 'A glitch in reality\'s code. It exists in the spaces between existence, forever searching for its missing data.'
    },
    555: {
        title: 'The Pentacle',
        story: 'Five points of the star, five ways to die, five seconds of agony stretched into eternity.'
    },
    616: {
        title: 'The True Beast',
        story: 'The original number before the scribes\' error. It claims to be the authentic evil, and perhaps it is.'
    },
    666: {
        override: { monster: 'Demon', item: 'Crown' },
        title: 'The Beast Awakened',
        story: 'The prophesied destroyer has risen. Its coming was foretold in ancient texts now burned to ash.'
    },
    777: {
        title: 'Lucky Seven',
        story: 'Blessed or cursed with infinite fortune. Its luck comes at the cost of everyone else\'s fate.'
    },
    911: {
        title: 'The Final Call',
        story: 'When all hope is lost, it answers. But its help comes with a price that makes death seem merciful.'
    },
    999: {
        title: 'The Gatekeeper',
        story: 'Standing at the threshold of the thousandth hell. Turn it upside down to see its true nature.'
    },
    
    // 1001-2000
    1000: {
        title: 'The Millennial',
        story: 'Appears once every thousand years to judge if civilization deserves to continue. It has never voted yes.'
    },
    1111: {
        title: 'The Awakening',
        story: 'When all four ones align, the sleeper wakes. Pray you\'re not conscious when it opens its eyes.'
    },
    1337: {
        title: 'The Chosen One',
        story: 'Elite among the damned, marked by the ancient digital prophets. It speaks in forgotten codes.'
    },
    1347: {
        title: 'The Black Death',
        story: 'It carries the original plague in its breath. One third of all it touches simply cease.'
    },
    1408: {
        title: 'The Haunted Room',
        story: 'It IS the room. Every nightmare that happened within those walls lives in its form.'
    },
    1492: {
        title: 'The Discovery',
        story: 'It "discovered" lands already inhabited, bringing apocalypse disguised as progress.'
    },
    1692: {
        title: 'The Witch Hunter',
        story: 'Born from the ashes of Salem\'s victims. It hunts those who hunt the innocent.'
    },
    1776: {
        title: 'The Revolution',
        story: 'Freedom written in blood, independence paid with souls. It collects the debt still owed.'
    },
    
    // 2001-10000
    2187: {
        title: 'The Exponential Death',
        story: 'Three to the seventh power. Each death it causes multiplies sevenfold into infinity.'
    },
    3141: {
        title: 'Pi\'s Madness',
        story: 'Irrational and infinite, it speaks in numbers that never end. To hear its full name is to go mad.'
    },
    4077: {
        title: 'The Field Medic',
        story: 'From the M*A*S*H unit that never was. It patches wounds with barbwire and heals pain with suffering.'
    },
    5150: {
        title: 'The Insane',
        story: 'Legally mad, cosmically aware. It sees truths that shatter minds and speaks realities that shouldn\'t exist.'
    },
    6174: {
        title: 'Kaprekar\'s Curse',
        story: 'Trapped in an mathematical loop of horror. All paths lead back to 6174, and there is no escape.'
    },
    7777: {
        title: 'Fortune\'s Avatar',
        story: 'Four sevens in succession, luck beyond measure. But fortune\'s wheel always turns to tragedy.'
    },
    8128: {
        title: 'Perfect Despair',
        story: 'A perfect number hiding perfect horror. Its mathematical beauty masks infinite suffering.'
    },
    9999: {
        title: 'The Final Guardian',
        story: 'The last defender before 10,000 hells are unleashed. When it falls, everything ends.'
    }
};

// シード付き疑似乱数生成器
function seededRandom(seed) {
    const x = Math.sin(seed) * 10000;
    return x - Math.floor(x);
}

// IDベースで配列から要素を選択
function getSeededElement(array, seed, offset = 0) {
    const index = Math.floor(seededRandom(seed + offset) * array.length);
    return array[index];
}

// SVGファイルを読み込む関数（ブラウザ環境用）
async function loadSVG(path) {
    try {
        const response = await fetch(path);
        const text = await response.text();
        return text;
    } catch (error) {
        console.error('Failed to load SVG:', path, error);
        return '';
    }
}

// メタデータを生成する関数
async function generateMetadataById(id) {
    // 設定ファイルが未読み込みの場合は読み込む
    if (!config) {
        await loadConfig();
    }
    
    const seed = parseInt(id) || 0;
    
    // レジェンダリーIDチェック
    const legendaryData = legendaryIds ? legendaryIds[seed] : null;
    
    // 設定から属性を取得
    const slot1Items = getAttributeItems(1);
    const slot2Items = getAttributeItems(2);
    const slot3Items = getAttributeItems(3);
    const slot4Items = getAttributeItems(4);
    
    let monster, item;
    
    // レジェンダリーIDの場合、特定の組み合わせを強制することがある
    if (legendaryData && legendaryData.override) {
        if (legendaryData.override.monster) {
            monster = slot1Items.find(m => m.name === legendaryData.override.monster);
        } else {
            monster = getSeededElement(slot1Items, seed, 1);
        }
        
        if (legendaryData.override.item) {
            item = slot2Items.find(i => i.name === legendaryData.override.item);
        } else {
            item = getSeededElement(slot2Items, seed, 2);
        }
    } else {
        monster = getSeededElement(slot1Items, seed, 1);
        item = getSeededElement(slot2Items, seed, 2);
    }
    
    const colorScheme = getSeededElement(slot3Items, seed, 3);
    const effect = getSeededElement(slot4Items, seed, 4);
    
    // Check for synergies using the new system
    const checkSyn = checkSynergies || window.checkSynergies;
    const calcRarity = calculateRarity || window.calculateRarity;
    const genBaseStory = generateBaseStory || window.generateBaseStory;
    const genDynamicName = generateDynamicName || window.generateDynamicName;
    const genDynamicStory = generateDynamicStory || window.generateDynamicStory;
    
    // Transform equipment for synergy check if needed
    let equipmentName = item.name;
    if (item.synergyForm) {
        // Check if this combination would create a synergy with the transformed form
        const transformedSynergy = checkSyn ? checkSyn(monster.name, item.synergyForm, colorScheme.name, effect.name) : null;
        if (transformedSynergy) {
            equipmentName = item.synergyForm;
        }
    }
    
    const synergy = checkSyn ? checkSyn(monster.name, equipmentName, colorScheme.name, effect.name) : null;
    
    // Calculate rarity based on synergies
    let rarity = calcRarity ? calcRarity(seed, synergy) : 'Common';
    
    // Override for legendary IDs
    if (legendaryData) {
        rarity = 'Legendary';
    }
    
    // Generate name and story
    let name, description;
    const projectName = config?.metadata?.projectName || 'The Mythical Cursed-Nightmare';
    const nameFormat = config?.metadata?.nameFormat || '{projectName} #{id}';
    const descFormat = config?.metadata?.descriptionFormat || 'A {slot1} wielding {slot2} in the {slot3} realm, cursed by {slot4}.';
    
    if (legendaryData && legendaryData.title) {
        name = nameFormat.replace('{projectName}', legendaryData.title).replace('{id}', id);
        description = legendaryData.story;
    } else if (synergy) {
        name = nameFormat.replace('{projectName}', synergy.title).replace('{id}', id);
        description = synergy.story;
    } else {
        // Use dynamic name generation for non-synergy NFTs
        if (genDynamicName && genDynamicStory) {
            const dynamicTitle = genDynamicName(monster.name, equipmentName, colorScheme.name, effect.name, seed);
            name = nameFormat.replace('{projectName}', dynamicTitle).replace('{id}', id);
            description = genDynamicStory(monster.name, equipmentName, colorScheme.name, effect.name, seed);
        } else {
            // Use config format or fallback
            name = nameFormat.replace('{projectName}', projectName).replace('{id}', id);
            description = descFormat
                .replace('{slot1}', monster.name)
                .replace('{slot2}', item.name)
                .replace('{slot3}', colorScheme.name)
                .replace('{slot4}', effect.name);
        }
    }
    
    // SVG画像を生成
    const slot1Dir = config?.attributes?.slot1?.directory || 'monsters';
    const slot2Dir = config?.attributes?.slot2?.directory || 'items';
    const monsterSVG = await loadSVG(`assets/${slot1Dir}/${monster.file}`);
    const itemSVG = await loadSVG(`assets/${slot2Dir}/${item.file}`);
    const image = await generateCompositeImage(monsterSVG, itemSVG, colorScheme, effect, item);
    
    return {
        name,
        description,
        image,
        external_url: `https://cursed-nightmare.example.com/essay/${id}`,
        attributes: [
            {
                trait_type: getAttributeName(1),
                value: monster.name
            },
            {
                trait_type: getAttributeName(2),
                value: item.name
            },
            {
                trait_type: getAttributeName(3),
                value: colorScheme.name
            },
            {
                trait_type: getAttributeName(4),
                value: effect.name
            },
            {
                trait_type: "Rarity",
                value: rarity
            },
            ...(synergy ? [{
                trait_type: "Synergy Type",
                value: synergy.type.charAt(0).toUpperCase() + synergy.type.slice(1)
            }, {
                trait_type: "Synergy",
                value: synergy.title
            }] : []),
            ...(legendaryData ? [{
                trait_type: "Legendary ID",
                value: "True"
            }] : [])
        ]
    };
}

// 複合SVG画像を生成
async function generateCompositeImage(monsterSVG, itemSVG, colorScheme, effect, item) {
    // 背景SVGを読み込み
    let backgroundSVG = '';
    try {
        const bgFileName = colorScheme.name.toLowerCase() + '.svg';
        const response = await fetch(`assets/bg/${bgFileName}`);
        if (response.ok) {
            const bgContent = await response.text();
            // SVGタグを除去して中身だけ取得
            backgroundSVG = bgContent.replace(/<svg[^>]*>|<\/svg>/g, '');
        }
    } catch (error) {
        console.log('Background SVG not found, using default');
    }
    
    // エフェクトSVGを読み込み
    let effectSVG = '';
    try {
        // エフェクト名を正規化（スペースを削除して小文字に）
        const effectFileName = effect.name.toLowerCase().replace(/\s+/g, '') + '.svg';
        const effectResponse = await fetch(`assets/effect/${effectFileName}`);
        if (effectResponse.ok) {
            const effectContent = await effectResponse.text();
            // SVGタグを除去して中身だけ取得
            effectSVG = effectContent.replace(/<svg[^>]*>|<\/svg>/g, '');
            
            // SVG内に既にscale(10)が含まれている場合は除去（二重適用を防ぐ）
            effectSVG = effectSVG.replace(/<g\s+transform="scale\(10\)">/g, '<g>');
        } else {
            // ファイルが見つからない場合は埋め込みSVGを使用
            effectSVG = effect.svg;
        }
    } catch (error) {
        console.log('Effect SVG not found, using embedded');
        effectSVG = effect.svg;
    }
    
    const svg = `
        <svg width="240" height="240" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <filter id="pixelate">
                    <feFlood x="0" y="0" width="1" height="1" flood-color="${colorScheme.background}"/>
                    <feComposite in2="SourceGraphic" operator="over"/>
                </filter>
            </defs>
            
            ${backgroundSVG ? 
                `<!-- 背景SVG -->
                <g transform="scale(10)">
                    ${backgroundSVG}
                </g>` : 
                `<!-- デフォルト背景 -->
                <rect width="240" height="240" fill="${colorScheme.background}"/>
                
                <!-- グリッドパターン -->
                <g opacity="0.1">
                    ${Array.from({length: 10}, (_, i) => `<line x1="${i * 24}" y1="0" x2="${i * 24}" y2="240" stroke="#000" stroke-width="1"/>`).join('')}
                    ${Array.from({length: 10}, (_, i) => `<line x1="0" y1="${i * 24}" x2="240" y2="${i * 24}" stroke="#000" stroke-width="1"/>`).join('')}
                </g>`
            }
            
            <!-- モンスター（カラーフィルター適用） -->
            <g transform="translate(12, 12) scale(9)">
                <g style="filter: hue-rotate(${colorScheme.hueRotate || 0}deg) saturate(${colorScheme.saturate || 1.5})">
                    ${monsterSVG.replace(/<svg[^>]*>|<\/svg>/g, '')}
                </g>
            </g>
            
            <!-- アイテム（モンスターの近くに配置） -->
            <g transform="translate(${
                item.name === 'Crown' ? '46' : 
                item.name === 'Amulet' ? '48' : 
                '119'
            }, ${
                item.name === 'Crown' ? '2' : 
                item.name === 'Amulet' ? '102' : 
                '90'
            }) scale(6)">
                ${itemSVG.replace(/<svg[^>]*>|<\/svg>/g, '')}
            </g>
            
            <!-- エフェクト -->
            <g transform="scale(10)">
                ${effectSVG}
            </g>
        </svg>
    `;
    return 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
}

// エクスポート（モジュール対応）
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { generateMetadataById };
} else if (typeof window !== 'undefined') {
    // ブラウザ環境
    window.generateMetadataById = generateMetadataById;
}