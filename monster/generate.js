// ピクセルアートモンスターNFTジェネレーター

const monsters = [
    { name: 'Werewolf', file: 'werewolf.svg' },
    { name: 'Goblin', file: 'goblin.svg' },
    { name: 'Ghost', file: 'ghost.svg' },
    { name: 'Demon', file: 'demon.svg' },
    { name: 'Dragon', file: 'dragon.svg' },
    { name: 'Zombie', file: 'zombie.svg' },
    { name: 'Vampire', file: 'vampire.svg' },
    { name: 'Mummy', file: 'mummy.svg' },
    { name: 'Orc', file: 'orc.svg' },
    { name: 'Skeleton', file: 'skeleton.svg' }
];

const items = [
    { name: 'Crown', file: 'crown.svg' },
    { name: 'Sword', file: 'sword.svg' },
    { name: 'Shield', file: 'shield.svg' },
    { name: 'Potion', file: 'potion.svg' },
    { name: 'Lantern', file: 'lantern.svg' },
    { name: 'Scroll', file: 'scroll.svg' },
    { name: 'Wine', file: 'wine.svg' },
    { name: 'Beer', file: 'beer.svg' },
    { name: 'Ice Cream', file: 'icecream.svg' },
    { name: 'Heart', file: 'heart.svg' }
];

const colorSchemes = [
    { name: 'Sunset', primary: '#FF6B6B', secondary: '#4ECDC4', background: '#FFE66D', hueRotate: 0 },
    { name: 'Ocean', primary: '#0077BE', secondary: '#00A8E8', background: '#00F5FF', hueRotate: 200 },
    { name: 'Forest', primary: '#2D5016', secondary: '#73A942', background: '#AAD576', hueRotate: 90 },
    { name: 'Royal', primary: '#6B5B95', secondary: '#B565A7', background: '#D64545', hueRotate: 270 },
    { name: 'Candy', primary: '#FF69B4', secondary: '#FFB6C1', background: '#FFC0CB', hueRotate: 330 },
    { name: 'Night', primary: '#1B1B3A', secondary: '#693668', background: '#51355A', hueRotate: 240 },
    { name: 'Fire', primary: '#FF4500', secondary: '#FF6347', background: '#FFA500', hueRotate: 15 },
    { name: 'Ice', primary: '#4682B4', secondary: '#87CEEB', background: '#E0FFFF', hueRotate: 180 },
    { name: 'Gold', primary: '#FFD700', secondary: '#FFA500', background: '#FFFFE0', hueRotate: 45 },
    { name: 'Shadow', primary: '#2F4F4F', secondary: '#696969', background: '#A9A9A9', hueRotate: 0, saturate: 0.3 }
];

const effects = [
    { name: 'Sparkle', svg: `<g>
        <circle cx="6" cy="6" r="1" fill="white">
            <animate attributeName="opacity" values="0;1;0" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="white;cyan;white" dur="3s" repeatCount="indefinite"/>
        </circle>
        <circle cx="18" cy="8" r="1" fill="white">
            <animate attributeName="opacity" values="0;1;0" dur="2s" begin="0.5s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="white;yellow;white" dur="3s" repeatCount="indefinite"/>
        </circle>
        <circle cx="12" cy="18" r="1" fill="white">
            <animate attributeName="opacity" values="0;1;0" dur="2s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="white;magenta;white" dur="3s" repeatCount="indefinite"/>
        </circle>
    </g>` },
    { name: 'Glow', svg: `<g>
        <circle cx="12" cy="12" r="10" fill="none" stroke="cyan" stroke-width="0.5">
            <animate attributeName="r" values="8;12;8" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0.8;0.2;0.8" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="stroke" values="cyan;magenta;yellow;cyan" dur="4s" repeatCount="indefinite"/>
        </circle>
        <circle cx="12" cy="12" r="8" fill="none" stroke="magenta" stroke-width="0.3">
            <animate attributeName="r" values="6;10;6" dur="2.5s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0.6;0.1;0.6" dur="2.5s" repeatCount="indefinite"/>
        </circle>
        <circle cx="12" cy="12" r="6" fill="none" stroke="yellow" stroke-width="0.2">
            <animate attributeName="r" values="4;8;4" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0.4;0.1;0.4" dur="2s" repeatCount="indefinite"/>
        </circle>
    </g>` },
    { name: 'Rainbow', svg: `<rect x="0" y="0" width="24" height="24" fill="url(#rainbow)">
        <animate attributeName="opacity" values="0.1;0.3;0.1" dur="4s" repeatCount="indefinite"/>
    </rect>
    <defs>
        <linearGradient id="rainbow">
            <stop offset="0%" stop-color="red">
                <animate attributeName="stop-color" values="red;yellow;green;cyan;blue;magenta;red" dur="6s" repeatCount="indefinite"/>
            </stop>
            <stop offset="50%" stop-color="green">
                <animate attributeName="stop-color" values="green;cyan;blue;magenta;red;yellow;green" dur="6s" repeatCount="indefinite"/>
            </stop>
            <stop offset="100%" stop-color="blue">
                <animate attributeName="stop-color" values="blue;magenta;red;yellow;green;cyan;blue" dur="6s" repeatCount="indefinite"/>
            </stop>
        </linearGradient>
    </defs>` },
    { name: 'Stars', svg: `<g>
        <text x="4" y="4" font-size="8" fill="yellow">★
            <animate attributeName="opacity" values="0.3;1;0.3" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="yellow;white;yellow" dur="3s" repeatCount="indefinite"/>
        </text>
        <text x="16" y="20" font-size="8" fill="yellow">★
            <animate attributeName="opacity" values="0.3;1;0.3" dur="2s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="yellow;gold;yellow" dur="3s" repeatCount="indefinite"/>
        </text>
    </g>` },
    { name: 'Hearts', svg: `<g>
        <text x="2" y="6" font-size="8" fill="pink">♥
            <animate attributeName="opacity" values="0.2;0.8;0.2" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="pink;red;pink" dur="3s" repeatCount="indefinite"/>
            <animateTransform attributeName="transform" type="scale" values="1;1.2;1" dur="2s" repeatCount="indefinite" additive="sum"/>
        </text>
        <text x="16" y="18" font-size="8" fill="pink">♥
            <animate attributeName="opacity" values="0.2;0.8;0.2" dur="2s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="pink;hotpink;pink" dur="3s" repeatCount="indefinite"/>
            <animateTransform attributeName="transform" type="scale" values="1;1.2;1" dur="2s" begin="1s" repeatCount="indefinite" additive="sum"/>
        </text>
    </g>` },
    { name: 'Bubbles', svg: `<g>
        <circle cx="6" cy="20" r="2" fill="none" stroke="lightblue" stroke-width="1">
            <animate attributeName="cy" values="20;-2" dur="4s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.7;0" dur="4s" repeatCount="indefinite"/>
            <animate attributeName="stroke" values="lightblue;white;lightblue" dur="4s" repeatCount="indefinite"/>
        </circle>
        <circle cx="18" cy="20" r="1.5" fill="none" stroke="lightblue" stroke-width="1">
            <animate attributeName="cy" values="20;-2" dur="3s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.7;0" dur="3s" begin="1s" repeatCount="indefinite"/>
        </circle>
    </g>` },
    { name: 'Lightning', svg: `<g>
        <rect x="0" y="0" width="24" height="24" fill="white">
            <animate attributeName="opacity" values="0;0;0;0;0;0.9;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0" dur="3s" repeatCount="indefinite"/>
        </rect>
        <path d="M12,2 L10,10 L14,10 L12,22" fill="yellow" stroke="white" stroke-width="0.5">
            <animate attributeName="opacity" values="0;0;0;0;1;1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="yellow;yellow;yellow;yellow;white;white;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow;yellow" dur="3s" repeatCount="indefinite"/>
        </path>
        <path d="M8,4 L7,8 L10,8 L9,15" fill="yellow" stroke="white" stroke-width="0.3">
            <animate attributeName="opacity" values="0;0;0;0;0.7;0.7;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0" dur="3s" repeatCount="indefinite"/>
        </path>
        <path d="M16,6 L15,11 L17,11 L16,18" fill="yellow" stroke="white" stroke-width="0.3">
            <animate attributeName="opacity" values="0;0;0;0;0.5;0.5;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0" dur="3s" repeatCount="indefinite"/>
        </path>
    </g>` },
    { name: 'Ripple', svg: `<g>
        ${Array.from({length: 4}, (_, i) => `
            <circle cx="12" cy="12" r="1" fill="none" stroke="cyan" stroke-width="0.5">
                <animate attributeName="r" 
                         values="1;10;1" 
                         dur="4s" 
                         begin="${i}s" 
                         repeatCount="indefinite"/>
                <animate attributeName="opacity" 
                         values="0.8;0;0.8" 
                         dur="4s" 
                         begin="${i}s" 
                         repeatCount="indefinite"/>
                <animate attributeName="stroke" 
                         values="cyan;blue;purple;cyan" 
                         dur="4s" 
                         begin="${i}s" 
                         repeatCount="indefinite"/>
                <animate attributeName="stroke-width" 
                         values="0.5;0.1;0.5" 
                         dur="4s" 
                         begin="${i}s" 
                         repeatCount="indefinite"/>
            </circle>
        `).join('')}
    </g>` },
    { name: 'Pulse', svg: `<rect x="0" y="0" width="24" height="24" fill="white">
        <animate attributeName="opacity" values="0;0.3;0" dur="2s" repeatCount="indefinite"/>
        <animate attributeName="fill" values="white;cyan;magenta;white" dur="4s" repeatCount="indefinite"/>
    </rect>` },
    { name: 'Minimal', svg: `<g>
        <animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="15s" repeatCount="indefinite"/>
        ${Array.from({length: 10}, (_, i) => {
            const angle = (i * Math.PI * 2) / 10;
            const radius = 8;
            const x = 12 + Math.cos(angle) * radius;
            const y = 12 + Math.sin(angle) * radius;
            return `<circle cx="${x}" cy="${y}" r="0.8" fill="white">
                <animate attributeName="opacity" values="0.4;0.9;0.4" dur="${2 + i * 0.2}s" repeatCount="indefinite"/>
                <animate attributeName="fill" values="white;cyan;white" dur="3s" begin="${i * 0.3}s" repeatCount="indefinite"/>
                <animate attributeName="r" values="0.8;1;0.8" dur="${2 + i * 0.2}s" repeatCount="indefinite"/>
            </circle>`;
        }).join('')}
    </g>` }
];

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
    const seed = parseInt(id) || 0;
    
    const monster = getSeededElement(monsters, seed, 1);
    const item = getSeededElement(items, seed, 2);
    const colorScheme = getSeededElement(colorSchemes, seed, 3);
    const effect = getSeededElement(effects, seed, 4);
    
    // レアリティ計算
    const rarityScore = (seed % 100) + 1;
    let rarity = 'Common';
    if (rarityScore > 95) rarity = 'Legendary';
    else if (rarityScore > 85) rarity = 'Epic';
    else if (rarityScore > 70) rarity = 'Rare';
    else if (rarityScore > 50) rarity = 'Uncommon';
    
    const name = `${colorScheme.name} ${monster.name} #${id}`;
    const description = `A unique pixel art ${monster.name.toLowerCase()} with ${item.name.toLowerCase()} in ${colorScheme.name.toLowerCase()} color scheme. ${rarity} collectible from the Pixel Monsters collection.`;
    
    // SVG画像を生成
    const monsterSVG = await loadSVG(`assets/monsters/${monster.file}`);
    const itemSVG = await loadSVG(`assets/items/${item.file}`);
    const image = await generateCompositeImage(monsterSVG, itemSVG, colorScheme, effect, item);
    
    return {
        name,
        description,
        image,
        external_url: `https://pixelmonsters.example.com/nft/${id}`,
        attributes: [
            {
                trait_type: "Monster",
                value: monster.name
            },
            {
                trait_type: "Item",
                value: item.name
            },
            {
                trait_type: "Color Scheme",
                value: colorScheme.name
            },
            {
                trait_type: "Effect",
                value: effect.name
            },
            {
                trait_type: "Rarity",
                value: rarity
            }
        ]
    };
}

// 複合SVG画像を生成
async function generateCompositeImage(monsterSVG, itemSVG, colorScheme, effect, item) {
    const svg = `
        <svg width="240" height="240" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <filter id="pixelate">
                    <feFlood x="0" y="0" width="1" height="1" flood-color="${colorScheme.background}"/>
                    <feComposite in2="SourceGraphic" operator="over"/>
                </filter>
            </defs>
            <!-- 背景 -->
            <rect width="240" height="240" fill="${colorScheme.background}"/>
            
            <!-- グリッドパターン -->
            <g opacity="0.1">
                ${Array.from({length: 10}, (_, i) => `<line x1="${i * 24}" y1="0" x2="${i * 24}" y2="240" stroke="#000" stroke-width="1"/>`).join('')}
                ${Array.from({length: 10}, (_, i) => `<line x1="0" y1="${i * 24}" x2="240" y2="${i * 24}" stroke="#000" stroke-width="1"/>`).join('')}
            </g>
            
            <!-- モンスター（カラーフィルター適用） -->
            <g transform="translate(12, 12) scale(9)">
                <g style="filter: hue-rotate(${colorScheme.hueRotate}deg) saturate(${colorScheme.saturate || 1.5})">
                    ${monsterSVG.replace(/<svg[^>]*>|<\/svg>/g, '')}
                </g>
            </g>
            
            <!-- アイテム（モンスターの近くに配置） -->
            <g transform="translate(${item.name === 'Beer' ? '130' : item.name === 'Crown' ? '88' : '120'}, ${item.name === 'Crown' ? '8' : '120'}) scale(3)">
                ${itemSVG.replace(/<svg[^>]*>|<\/svg>/g, '')}
            </g>
            
            <!-- エフェクト -->
            <g transform="scale(10)">
                ${effect.svg}
            </g>
        </svg>
    `;
    return 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
}

// エクスポート（モジュール対応）
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { generateMetadataById };
}