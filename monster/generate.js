// ピクセルアートモンスターNFTジェネレーター

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
    { name: 'Staff', file: 'staff.svg' },
    { name: 'Crown', file: 'crown.svg' },
    { name: 'Sword', file: 'sword.svg' },
    { name: 'Shield', file: 'shield.svg' },
    { name: 'Poison', file: 'poison.svg' },
    { name: 'Torch', file: 'torch.svg' },
    { name: 'Wine', file: 'wine.svg' },
    { name: 'Scythe', file: 'scythe.svg' },
    { name: 'Staff', file: 'staff.svg' },
    { name: 'Crown', file: 'crown.svg' },
    { name: 'Sword', file: 'sword.svg' },
    { name: 'Shield', file: 'shield.svg' },
    { name: 'Poison', file: 'poison.svg' },
    { name: 'Torch', file: 'torch.svg' },
    { name: 'Wine', file: 'wine.svg' },
    { name: 'Scythe', file: 'scythe.svg' },
    { name: 'Staff', file: 'staff.svg' },
    { name: 'Arm', file: 'arm.svg' },
    { name: 'Head', file: 'head.svg' }
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
    { name: 'Seizure', svg: `<g>
        <circle cx="6" cy="6" r="0.8" fill="#FF0080">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="#FF0080;#00FF00;#FF00FF;#FFFF00" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="r" values="0.8;1.0;0.8" dur="2s" repeatCount="indefinite"/>
        </circle>
        <circle cx="18" cy="8" r="0.8" fill="#00FF00">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2.2s" begin="0.3s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="#00FF00;#FF0080;#00FFFF;#FF00FF" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="r" values="0.8;1.0;0.8" dur="2.2s" repeatCount="indefinite"/>
        </circle>
        <circle cx="12" cy="18" r="0.8" fill="#FFFF00">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2.4s" begin="0.6s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="#FFFF00;#FF00FF;#00FF00;#FF0080" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="r" values="0.8;1.0;0.8" dur="2.4s" repeatCount="indefinite"/>
        </circle>
        <circle cx="3" cy="12" r="0.8" fill="#00FFFF">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2.6s" begin="0.9s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="#00FFFF;#FFFF00;#FF0080;#00FF00" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="r" values="0.8;1.0;0.8" dur="2.6s" repeatCount="indefinite"/>
        </circle>
        <circle cx="21" cy="15" r="0.8" fill="#FF00FF">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2.3s" begin="1.2s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="#FF00FF;#00FFFF;#FFFF00;#FF0080" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="r" values="0.8;1.0;0.8" dur="2.3s" repeatCount="indefinite"/>
        </circle>
        <circle cx="9" cy="21" r="0.8" fill="#FF0080">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2.1s" begin="1.5s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="#FF0080;#00FF00;#FF00FF;#00FFFF" dur="3s" repeatCount="indefinite"/>
            <animate attributeName="r" values="0.8;1.0;0.8" dur="2.1s" repeatCount="indefinite"/>
        </circle>
    </g>` },
    { name: 'Mind Blast', svg: `<g>
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
    { name: 'Confusion', svg: `<rect x="0" y="0" width="24" height="24" fill="url(#rainbow)">
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
    { name: 'Meteor', svg: `<g>
        <text x="24" y="-4" font-size="6" fill="yellow">★
            <animateTransform attributeName="transform" type="translate" values="0,0; -28,28" dur="1.5s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;1;1;0" dur="1.5s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="yellow;white;orange;yellow" dur="1.5s" repeatCount="indefinite"/>
        </text>
        <text x="20" y="-2" font-size="4" fill="orange">★
            <animateTransform attributeName="transform" type="translate" values="0,0; -24,26" dur="1.5s" begin="0.3s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.8;0.8;0" dur="1.5s" begin="0.3s" repeatCount="indefinite"/>
        </text>
        <text x="28" y="2" font-size="5" fill="yellow">★
            <animateTransform attributeName="transform" type="translate" values="0,0; -32,30" dur="1.5s" begin="0.6s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.9;0.9;0" dur="1.5s" begin="0.6s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="yellow;white;yellow" dur="1.5s" begin="0.6s" repeatCount="indefinite"/>
        </text>
        <text x="26" y="-6" font-size="3" fill="white">★
            <animateTransform attributeName="transform" type="translate" values="0,0; -30,32" dur="1.5s" begin="0.9s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.6;0.6;0" dur="1.5s" begin="0.9s" repeatCount="indefinite"/>
        </text>
        <text x="22" y="4" font-size="4" fill="orange">★
            <animateTransform attributeName="transform" type="translate" values="0,0; -26,24" dur="1.5s" begin="1.2s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.7;0.7;0" dur="1.5s" begin="1.2s" repeatCount="indefinite"/>
        </text>
    </g>` },
    { name: 'Bats', svg: `<g>
        <!-- バサバサ飛ぶコウモリ1 -->
        <g>
            <animateTransform attributeName="transform" type="translate" 
                values="2,2; 8,4; 15,2; 20,6; 18,12; 10,15; 3,10; 2,2" 
                dur="5s" repeatCount="indefinite"/>
            <g>
                <rect x="2" y="1" width="4" height="1" fill="#000000"/>
                <rect x="0" y="2" width="8" height="1" fill="#000000">
                    <animate attributeName="width" values="8;4;8;4;8" dur="0.3s" repeatCount="indefinite"/>
                    <animate attributeName="x" values="0;2;0;2;0" dur="0.3s" repeatCount="indefinite"/>
                </rect>
                <rect x="3" y="2" width="2" height="1" fill="#8B008B"/>
                <animate attributeName="opacity" values="0.4;0.9;0.4" dur="2s" repeatCount="indefinite"/>
            </g>
        </g>
        <!-- バサバサ飛ぶコウモリ2 -->
        <g>
            <animateTransform attributeName="transform" type="translate" 
                values="18,15; 12,12; 5,14; 2,8; 6,4; 14,6; 20,10; 18,15" 
                dur="4s" begin="1s" repeatCount="indefinite"/>
            <g>
                <rect x="2" y="1" width="4" height="1" fill="#000000"/>
                <rect x="0" y="2" width="8" height="1" fill="#000000">
                    <animate attributeName="width" values="8;4;8;4;8" dur="0.3s" repeatCount="indefinite"/>
                    <animate attributeName="x" values="0;2;0;2;0" dur="0.3s" repeatCount="indefinite"/>
                </rect>
                <rect x="3" y="2" width="2" height="1" fill="#4B0082"/>
                <animate attributeName="opacity" values="0.3;0.8;0.3" dur="2s" begin="1s" repeatCount="indefinite"/>
            </g>
        </g>
        <!-- バサバサ飛ぶコウモリ3 -->
        <g>
            <animateTransform attributeName="transform" type="translate" 
                values="10,8; 16,3; 20,8; 15,12; 8,10; 4,6; 8,2; 10,8" 
                dur="3.5s" begin="2s" repeatCount="indefinite"/>
            <g>
                <rect x="2" y="1" width="4" height="1" fill="#000000"/>
                <rect x="0" y="2" width="8" height="1" fill="#000000">
                    <animate attributeName="width" values="8;4;8;4;8" dur="0.3s" repeatCount="indefinite"/>
                    <animate attributeName="x" values="0;2;0;2;0" dur="0.3s" repeatCount="indefinite"/>
                </rect>
                <rect x="3" y="2" width="2" height="1" fill="#2F4F4F"/>
                <animate attributeName="opacity" values="0.5;1;0.5" dur="2s" begin="2s" repeatCount="indefinite"/>
            </g>
        </g>
    </g>` },
    { name: 'Poisoning', svg: `<g>
        <circle cx="6" cy="20" r="2" fill="none" stroke="#32CD32" stroke-width="1">
            <animate attributeName="cy" values="20;-2" dur="4s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.7;0" dur="4s" repeatCount="indefinite"/>
            <animate attributeName="stroke" values="#32CD32;#7CFC00;#00FF00" dur="4s" repeatCount="indefinite"/>
            <animate attributeName="fill" values="none;#32CD3220;none" dur="4s" repeatCount="indefinite"/>
        </circle>
        <circle cx="18" cy="20" r="1.5" fill="none" stroke="#9400D3" stroke-width="1">
            <animate attributeName="cy" values="20;-2" dur="3s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.7;0" dur="3s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="stroke" values="#9400D3;#FF00FF;#8B008B" dur="3s" begin="1s" repeatCount="indefinite"/>
        </circle>
        <circle cx="12" cy="20" r="1" fill="none" stroke="#00FF00" stroke-width="1">
            <animate attributeName="cy" values="20;-2" dur="3.5s" begin="0.5s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.8;0" dur="3.5s" begin="0.5s" repeatCount="indefinite"/>
            <animate attributeName="stroke" values="#00FF00;#ADFF2F;#7CFC00" dur="3.5s" begin="0.5s" repeatCount="indefinite"/>
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
    { name: 'Blizzard', svg: `<g>
        <!-- ピクセルアート風の斜めに流れる吹雪 -->
        ${Array.from({length: 25}, (_, i) => {
            const startX = Math.floor(Math.random() * 40) - 10; // 左から始まる雪も含む
            const size = Math.random() > 0.7 ? 2 : 1;
            const delay = Math.random() * 2;
            const duration = 0.75 + Math.random() * 0.5; // 半分の時間に
            const speed = Math.random() > 0.5 ? 1.5 : 1; // 速度の変化
            return `
            <rect x="${startX}" y="-${size}" width="${size}" height="${size}" fill="#FFFFFF">
                <animateTransform 
                    attributeName="transform" 
                    type="translate" 
                    values="0,0; ${30 * speed},${28 * speed}" 
                    dur="${duration}s" 
                    begin="${delay}s" 
                    repeatCount="indefinite"/>
                <animate attributeName="opacity" 
                         values="0;0.9;0.9;0.5;0" 
                         dur="${duration}s" 
                         begin="${delay}s" 
                         repeatCount="indefinite"/>
            </rect>`;
        }).join('')}
        <!-- 横風のエフェクト -->
        <rect x="0" y="0" width="24" height="24" fill="#B0E0E6" opacity="0">
            <animate attributeName="opacity" 
                     values="0;0.15;0.25;0.15;0" 
                     dur="1.5s" 
                     repeatCount="indefinite"/>
        </rect>
        <!-- 強い吹雪の筋 -->
        ${Array.from({length: 3}, (_, i) => {
            const delay = i * 0.4;
            return `
            <g opacity="0.4">
                <rect x="-10" y="${i * 8}" width="40" height="1" fill="#E0FFFF" transform="rotate(-30 12 12)">
                    <animateTransform 
                        attributeName="transform" 
                        type="translate" 
                        values="0,0; 35,30" 
                        dur="0.6s" 
                        begin="${delay}s" 
                        repeatCount="indefinite"
                        additive="sum"/>
                    <animate attributeName="opacity" 
                             values="0;0.6;0.6;0" 
                             dur="0.6s" 
                             begin="${delay}s" 
                             repeatCount="indefinite"/>
                </rect>
            </g>`;
        }).join('')}
        <!-- 大きな雪片（斜めに流れる） -->
        ${Array.from({length: 5}, (_, i) => {
            const startX = Math.floor(Math.random() * 30) - 5;
            const delay = Math.random() * 1;
            return `
            <g>
                <rect x="${startX}" y="-2" width="2" height="2" fill="#F0FFFF">
                    <animateTransform 
                        attributeName="transform" 
                        type="translate" 
                        values="0,0; 25,26" 
                        dur="1s" 
                        begin="${delay}s" 
                        repeatCount="indefinite"/>
                    <animate attributeName="opacity" 
                             values="0;1;1;0.3;0" 
                             dur="1s" 
                             begin="${delay}s" 
                             repeatCount="indefinite"/>
                </rect>
            </g>`;
        }).join('')}
    </g>` },
{ name: 'Burning', svg: `<g>
        <!-- ピクセルアート風の松明の炎（複数配置） -->
        <!-- 左の炎 -->
        <g>
            <rect x="3" y="16" width="2" height="2" fill="#FFFF00">
                <animate attributeName="fill" values="#FFFF00;#FFFAF0;#FFFF00" dur="0.6s" repeatCount="indefinite"/>
            </rect>
            <rect x="2" y="17" width="4" height="2" fill="#FFD700">
                <animate attributeName="fill" values="#FFD700;#FFFF00;#FFD700" dur="0.8s" repeatCount="indefinite"/>
            </rect>
            <rect x="1" y="19" width="6" height="2" fill="#FFA500">
                <animate attributeName="opacity" values="0.8;1;0.8" dur="1.1s" repeatCount="indefinite"/>
            </rect>
            <rect x="2" y="21" width="4" height="1" fill="#FF8C00">
                <animate attributeName="width" values="4;5;3;4" dur="1.3s" repeatCount="indefinite"/>
                <animate attributeName="x" values="2;1;2;2" dur="1.3s" repeatCount="indefinite"/>
            </rect>
            <rect x="0" y="22" width="8" height="2" fill="#FF4500">
                <animate attributeName="opacity" values="0.6;0.9;0.6" dur="1.4s" repeatCount="indefinite"/>
            </rect>
        </g>
        <!-- 中央の炎 -->
        <g>
            <rect x="11" y="21" width="2" height="2" fill="#FFFF00">
                <animate attributeName="fill" values="#FFFF00;#FFFAF0;#FFFF00" dur="0.5s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
            <rect x="10" y="22" width="4" height="2" fill="#FFD700">
                <animate attributeName="fill" values="#FFD700;#FFFF00;#FFD700" dur="0.7s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
            <rect x="9" y="24" width="6" height="2" fill="#FFA500">
                <animate attributeName="opacity" values="0.8;1;0.8" dur="1s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
            <rect x="10" y="26" width="4" height="1" fill="#FF8C00">
                <animate attributeName="width" values="4;5;3;4" dur="1.2s" begin="0.2s" repeatCount="indefinite"/>
                <animate attributeName="x" values="10;9;10;10" dur="1.2s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
            <rect x="8" y="27" width="8" height="0" fill="#FF4500">
                <animate attributeName="opacity" values="0.6;0.9;0.6" dur="1.3s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
            <!-- 揺らめく先端 -->
            <rect x="12" y="20" width="1" height="1" fill="#FFFF00">
                <animate attributeName="x" values="12;11;12;13;12" dur="2s" begin="0.2s" repeatCount="indefinite"/>
                <animate attributeName="opacity" values="0;1;0.8;1;0" dur="2s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
        </g>
        <!-- 右の炎 -->
        <g>
            <rect x="19" y="16" width="2" height="2" fill="#FFFF00">
                <animate attributeName="fill" values="#FFFF00;#FFFAF0;#FFFF00" dur="0.7s" begin="0.4s" repeatCount="indefinite"/>
            </rect>
            <rect x="18" y="17" width="4" height="2" fill="#FFD700">
                <animate attributeName="fill" values="#FFD700;#FFFF00;#FFD700" dur="0.9s" begin="0.4s" repeatCount="indefinite"/>
            </rect>
            <rect x="17" y="19" width="6" height="2" fill="#FFA500">
                <animate attributeName="opacity" values="0.8;1;0.8" dur="1.2s" begin="0.4s" repeatCount="indefinite"/>
            </rect>
            <rect x="18" y="21" width="4" height="1" fill="#FF8C00">
                <animate attributeName="width" values="4;5;3;4" dur="1.4s" begin="0.4s" repeatCount="indefinite"/>
                <animate attributeName="x" values="18;17;18;18" dur="1.4s" begin="0.4s" repeatCount="indefinite"/>
            </rect>
            <rect x="16" y="22" width="8" height="2" fill="#FF4500">
                <animate attributeName="opacity" values="0.6;0.9;0.6" dur="1.5s" begin="0.4s" repeatCount="indefinite"/>
            </rect>
        </g>
        <!-- 火の粉 -->
        <rect x="5" y="12" width="1" height="1" fill="#FFA500">
            <animate attributeName="y" values="18;12;8" dur="2s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.8;0" dur="2s" repeatCount="indefinite"/>
        </rect>
        <rect x="12" y="10" width="1" height="1" fill="#FF8C00">
            <animate attributeName="y" values="16;10;6" dur="2.2s" begin="0.5s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.6;0" dur="2.2s" begin="0.5s" repeatCount="indefinite"/>
        </rect>
        <rect x="20" y="11" width="1" height="1" fill="#FFFF00">
            <animate attributeName="y" values="17;11;7" dur="2.4s" begin="1s" repeatCount="indefinite"/>
            <animate attributeName="opacity" values="0;0.7;0" dur="2.4s" begin="1s" repeatCount="indefinite"/>
        </rect>
    </g>` },
    { name: 'Brain Wash', svg: `<g>
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
                trait_type: "Species",
                value: monster.name
            },
            {
                trait_type: "Equipment",
                value: item.name
            },
            {
                trait_type: "Realm",
                value: colorScheme.name
            },
            {
                trait_type: "Curse",
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
            <g transform="translate(${item.name === 'Crown' ? '46' : '119'}, ${item.name === 'Crown' ? '2' : '90'}) scale(6)">
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