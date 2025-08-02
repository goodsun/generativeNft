<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');

// ピクセルアートモンスターNFTのデータ
$monsters = [
    ['name' => 'Werewolf', 'file' => 'werewolf.svg'],
    ['name' => 'Goblin', 'file' => 'goblin.svg'],
    ['name' => 'Frankenstein', 'file' => 'frankenstein.svg'],
    ['name' => 'Demon', 'file' => 'demon.svg'],
    ['name' => 'Dragon', 'file' => 'dragon.svg'],
    ['name' => 'Zombie', 'file' => 'zombie.svg'],
    ['name' => 'Vampire', 'file' => 'vampire.svg'],
    ['name' => 'Mummy', 'file' => 'mummy.svg'],
    ['name' => 'Orc', 'file' => 'orc.svg'],
    ['name' => 'Skeleton', 'file' => 'skeleton.svg']
];

$items = [
    ['name' => 'Crown', 'file' => 'crown.svg'],
    ['name' => 'Sword', 'file' => 'sword.svg'],
    ['name' => 'Shield', 'file' => 'shield.svg'],
    ['name' => 'Potion', 'file' => 'potion.svg'],
    ['name' => 'Lantern', 'file' => 'lantern.svg'],
    ['name' => 'Scroll', 'file' => 'scroll.svg'],
    ['name' => 'Wine', 'file' => 'wine.svg'],
    ['name' => 'Beer', 'file' => 'beer.svg'],
    ['name' => 'Ice Cream', 'file' => 'icecream.svg'],
    ['name' => 'Heart', 'file' => 'heart.svg']
];

$colorSchemes = [
    ['name' => 'Sunset', 'primary' => '#FF6B6B', 'secondary' => '#4ECDC4', 'background' => '#FFE66D'],
    ['name' => 'Ocean', 'primary' => '#0077BE', 'secondary' => '#00A8E8', 'background' => '#00F5FF'],
    ['name' => 'Forest', 'primary' => '#2D5016', 'secondary' => '#73A942', 'background' => '#AAD576'],
    ['name' => 'Royal', 'primary' => '#6B5B95', 'secondary' => '#B565A7', 'background' => '#D64545'],
    ['name' => 'Candy', 'primary' => '#FF69B4', 'secondary' => '#FFB6C1', 'background' => '#FFC0CB'],
    ['name' => 'Night', 'primary' => '#1B1B3A', 'secondary' => '#693668', 'background' => '#51355A'],
    ['name' => 'Fire', 'primary' => '#FF4500', 'secondary' => '#FF6347', 'background' => '#FFA500'],
    ['name' => 'Ice', 'primary' => '#4682B4', 'secondary' => '#87CEEB', 'background' => '#E0FFFF'],
    ['name' => 'Gold', 'primary' => '#FFD700', 'secondary' => '#FFA500', 'background' => '#FFFFE0'],
    ['name' => 'Shadow', 'primary' => '#2F4F4F', 'secondary' => '#696969', 'background' => '#A9A9A9']
];

$effects = [
    'Sparkle', 'Glow', 'Rainbow', 'Stars', 'Hearts', 
    'Bubbles', 'Lightning', 'Ripple', 'Pulse', 'Minimal'
];

function seededRandom($seed) {
    $x = sin($seed) * 10000;
    return $x - floor($x);
}

function getSeededElement($array, $seed, $offset = 0) {
    $index = floor(seededRandom($seed + $offset) * count($array));
    return $array[$index];
}

function generateSVGImage($monster, $item, $colorScheme, $effect) {
    // SVGファイルを読み込む
    $monsterSVG = file_get_contents(__DIR__ . '/assets/monsters/' . $monster['file']);
    $itemSVG = file_get_contents(__DIR__ . '/assets/items/' . $item['file']);
    
    // SVGタグを除去
    $monsterSVG = preg_replace('/<\/?svg[^>]*>/', '', $monsterSVG);
    $itemSVG = preg_replace('/<\/?svg[^>]*>/', '', $itemSVG);
    
    // 色相回転の値を設定
    $hueRotateMap = [
        'Sunset' => 0,
        'Ocean' => 200,
        'Forest' => 90,
        'Royal' => 270,
        'Candy' => 330,
        'Night' => 240,
        'Fire' => 15,
        'Ice' => 180,
        'Gold' => 45,
        'Shadow' => 0
    ];
    
    $hueRotate = $hueRotateMap[$colorScheme['name']] ?? 0;
    $saturate = ($colorScheme['name'] === 'Shadow') ? 0.3 : 1.5;
    
    // アイテムの位置調整
    $itemX = 120;
    $itemY = 120;
    if ($item['name'] === 'Beer') {
        $itemX = 130;
    } elseif ($item['name'] === 'Crown') {
        $itemX = 88;
        $itemY = 8;
    }
    
    // エフェクトSVGを簡略化（PHPでは複雑なアニメーションは省略）
    $effectSVG = '';
    
    // SVGを組み立て
    $svg = '<svg width="240" height="240" xmlns="http://www.w3.org/2000/svg">
        <rect width="240" height="240" fill="' . $colorScheme['background'] . '"/>
        <g opacity="0.1">';
    
    // グリッドパターン
    for ($i = 0; $i < 10; $i++) {
        $svg .= '<line x1="' . ($i * 24) . '" y1="0" x2="' . ($i * 24) . '" y2="240" stroke="#000" stroke-width="1"/>';
        $svg .= '<line x1="0" y1="' . ($i * 24) . '" x2="240" y2="' . ($i * 24) . '" stroke="#000" stroke-width="1"/>';
    }
    
    $svg .= '</g>
        <g transform="translate(12, 12) scale(9)">
            <g style="filter: hue-rotate(' . $hueRotate . 'deg) saturate(' . $saturate . ')">
                ' . $monsterSVG . '
            </g>
        </g>
        <g transform="translate(' . $itemX . ', ' . $itemY . ') scale(3)">
            ' . $itemSVG . '
        </g>
    </svg>';
    
    // Base64エンコード
    return 'data:image/svg+xml;base64,' . base64_encode($svg);
}

function generateMetadataById($id) {
    global $monsters, $items, $colorSchemes, $effects;
    
    $seed = intval($id) ?: 0;
    
    $monster = getSeededElement($monsters, $seed, 1);
    $item = getSeededElement($items, $seed, 2);
    $colorScheme = getSeededElement($colorSchemes, $seed, 3);
    $effect = getSeededElement($effects, $seed, 4);
    
    // レアリティ計算
    $rarityScore = ($seed % 100) + 1;
    $rarity = 'Common';
    if ($rarityScore > 95) $rarity = 'Legendary';
    else if ($rarityScore > 85) $rarity = 'Epic';
    else if ($rarityScore > 70) $rarity = 'Rare';
    else if ($rarityScore > 50) $rarity = 'Uncommon';
    
    $name = $colorScheme['name'] . ' ' . $monster['name'] . ' #' . $id;
    $description = 'A unique pixel art ' . strtolower($monster['name']) . ' with ' . strtolower($item['name']) . ' in ' . strtolower($colorScheme['name']) . ' color scheme. ' . $rarity . ' collectible from the Pixel Monsters collection.';
    
    // SVG画像を生成
    $image = generateSVGImage($monster, $item, $colorScheme, $effect);
    
    return [
        'name' => $name,
        'description' => $description,
        'image' => $image,
        'external_url' => 'https://pixelmonsters.example.com/nft/' . $id,
        'attributes' => [
            [
                'trait_type' => 'Monster',
                'value' => $monster['name']
            ],
            [
                'trait_type' => 'Item',
                'value' => $item['name']
            ],
            [
                'trait_type' => 'Color Scheme',
                'value' => $colorScheme['name']
            ],
            [
                'trait_type' => 'Effect',
                'value' => $effect
            ],
            [
                'trait_type' => 'Rarity',
                'value' => $rarity
            ]
        ]
    ];
}

// リクエスト処理
$id = isset($_GET['id']) ? $_GET['id'] : '1';
$metadata = generateMetadataById($id);
echo json_encode($metadata, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
?>