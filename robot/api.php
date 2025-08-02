<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');

// ピクセルアートロボットNFTのデータ
$robots = [
    ['name' => 'Recon', 'file' => 'scout.svg'],
    ['name' => 'Sentinel', 'file' => 'guard.svg'],
    ['name' => 'Velocity', 'file' => 'speeder.svg'],
    ['name' => 'Industrial', 'file' => 'heavy-duty.svg'],
    ['name' => 'Humanoid', 'file' => 'android.svg'],
    ['name' => 'Builder', 'file' => 'construction.svg'],
    ['name' => 'Cryo', 'file' => 'arctic.svg'],
    ['name' => 'Observer', 'file' => 'surveillance.svg'],
    ['name' => 'BeeHive', 'file' => 'beehive.svg'],
    ['name' => 'Multi-Purpose', 'file' => 'utility.svg']
];

$items = [
    ['name' => 'Bomb', 'file' => 'bomb.svg'],
    ['name' => 'Lightsaber', 'file' => 'lightsaber.svg'],
    ['name' => 'Shield', 'file' => 'shield.svg'],
    ['name' => 'Exotic Matter', 'file' => 'poison.svg'],
    ['name' => 'Heat Rod', 'file' => 'heat-rod.svg'],
    ['name' => 'Missile Launcher', 'file' => 'missile-launcher.svg'],
    ['name' => 'Heat Hawk', 'file' => 'heat-hawk.svg'],
    ['name' => 'Utility Rod', 'file' => 'staff.svg'],
    ['name' => 'Bomb', 'file' => 'bomb.svg'],
    ['name' => 'Lightsaber', 'file' => 'lightsaber.svg'],
    ['name' => 'Shield', 'file' => 'shield.svg'],
    ['name' => 'Exotic Matter', 'file' => 'poison.svg'],
    ['name' => 'Heat Rod', 'file' => 'heat-rod.svg'],
    ['name' => 'Missile Launcher', 'file' => 'missile-launcher.svg'],
    ['name' => 'Heat Hawk', 'file' => 'heat-hawk.svg'],
    ['name' => 'Utility Rod', 'file' => 'staff.svg'],
    ['name' => 'Bomb', 'file' => 'bomb.svg'],
    ['name' => 'Lightsaber', 'file' => 'lightsaber.svg'],
    ['name' => 'Shield', 'file' => 'shield.svg'],
    ['name' => 'Exotic Matter', 'file' => 'poison.svg'],
    ['name' => 'Heat Rod', 'file' => 'heat-rod.svg'],
    ['name' => 'Missile Launcher', 'file' => 'missile-launcher.svg'],
    ['name' => 'Heat Hawk', 'file' => 'heat-hawk.svg'],
    ['name' => 'Utility Rod', 'file' => 'staff.svg'],
    ['name' => 'Robot Arm', 'file' => 'arm.svg'],
    ['name' => 'Tragedy', 'file' => 'head.svg']
];

$colorSchemes = [
    ['name' => 'Terminus', 'primary' => '#FF6B6B', 'secondary' => '#4ECDC4', 'background' => '#FFE66D'],
    ['name' => 'Abyss', 'primary' => '#0077BE', 'secondary' => '#00A8E8', 'background' => '#00F5FF'],
    ['name' => 'Synthesis', 'primary' => '#2D5016', 'secondary' => '#73A942', 'background' => '#AAD576'],
    ['name' => 'Dominion', 'primary' => '#6B5B95', 'secondary' => '#B565A7', 'background' => '#D64545'],
    ['name' => 'Neon', 'primary' => '#FF69B4', 'secondary' => '#FFB6C1', 'background' => '#FFC0CB'],
    ['name' => 'Ragnarok', 'primary' => '#FFD700', 'secondary' => '#FFA500', 'background' => '#FFFFE0'],
    ['name' => 'Forge', 'primary' => '#FF4500', 'secondary' => '#FF6347', 'background' => '#FFA500'],
    ['name' => 'Void', 'primary' => '#1B1B3A', 'secondary' => '#693668', 'background' => '#51355A'],
    ['name' => 'Cryos', 'primary' => '#4682B4', 'secondary' => '#87CEEB', 'background' => '#E0FFFF'],
    ['name' => 'Eclipse', 'primary' => '#2F4F4F', 'secondary' => '#696969', 'background' => '#A9A9A9']
];

$effects = [
    'Quantum Reactor', 'Shield Module', 'Spectrum Scanner', 'Cloaking Device', 'Drones', 
    'Matrix', 'EMP Generator', 'Sonar Array', 'Beacon Transmitter', 'Active Attitude System'
];

function seededRandom($seed) {
    $x = sin($seed) * 10000;
    return $x - floor($x);
}

function getSeededElement($array, $seed, $offset = 0) {
    $index = floor(seededRandom($seed + $offset) * count($array));
    return $array[$index];
}

function generateSVGImage($robot, $item, $colorScheme, $effect) {
    // SVGファイルを読み込む
    $robotSVG = file_get_contents(__DIR__ . '/assets/robots/' . $robot['file']);
    $itemSVG = file_get_contents(__DIR__ . '/assets/items/' . $item['file']);
    
    // SVGタグを除去
    $robotSVG = preg_replace('/<\/?svg[^>]*>/', '', $robotSVG);
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
    $itemX = 119;
    $itemY = 66;
    
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
                ' . $robotSVG . '
            </g>
        </g>
        <g transform="translate(' . $itemX . ', ' . $itemY . ') scale(6)">
            ' . $itemSVG . '
        </g>
    </svg>';
    
    // Base64エンコード
    return 'data:image/svg+xml;base64,' . base64_encode($svg);
}

function generateMetadataById($id) {
    global $robots, $items, $colorSchemes, $effects;
    
    $seed = intval($id) ?: 0;
    
    $robot = getSeededElement($robots, $seed, 1);
    
    // Tragedyは404の倍数でのみ出現
    if ($seed % 404 === 0 && $seed !== 0) {
        $item = ['name' => 'Tragedy', 'file' => 'head.svg'];
    } else {
        // Tragedyを除外したアイテムリスト
        $regularItems = array_filter($items, function($i) {
            return $i['name'] !== 'Tragedy';
        });
        $regularItems = array_values($regularItems); // インデックスをリセット
        $item = getSeededElement($regularItems, $seed, 2);
    }
    
    $colorScheme = getSeededElement($colorSchemes, $seed, 3);
    $effectIndex = floor(seededRandom($seed + 4) * count($effects));
    $effectIndex = ($effectIndex + 5) % count($effects); // 5つずらす
    $effect = $effects[$effectIndex];
    
    // レアリティ計算
    $rarityScore = ($seed % 100) + 1;
    $rarity = 'Common';
    if ($rarityScore > 95) $rarity = 'Legendary';
    else if ($rarityScore > 85) $rarity = 'Epic';
    else if ($rarityScore > 70) $rarity = 'Rare';
    else if ($rarityScore > 50) $rarity = 'Uncommon';
    
    // Tragedyの場合は特別な名前
    $name = $item['name'] === 'Tragedy' 
        ? $robot['name'] . ' - Tragedy Bearer #' . $id
        : $robot['name'] . ' with ' . $item['name'] . ' #' . $id;
    // アイテムごとの特別な説明
    $itemDescription = '';
    if ($item['name'] === 'Tragedy') {
        $itemDescription = 'carries the last remnant of organic life - a grim reminder of what once was';
    } else if ($item['name'] === 'Exotic Matter') {
        $itemDescription = 'powered by ' . strtolower($item['name']) . ', the mysterious substance that animates mechanical life';
    } else if ($item['name'] === 'Robot Arm') {
        $itemDescription = 'equipped with salvaged parts from fallen mechanical beings';
    } else {
        $itemDescription = 'armed with ' . strtolower($item['name']);
    }
    
    $description = 'In the post-organic world, this ' . strtolower($colorScheme['name']) . '-hued ' . strtolower($robot['name']) . ' ' . $itemDescription . '. ' . $rarity . ' specimen from the Mechanical Animals archive.';
    
    // SVG画像を生成
    $image = generateSVGImage($robot, $item, $colorScheme, $effect);
    
    return [
        'name' => $name,
        'description' => $description,
        'image' => $image,
        'external_url' => 'https://pixelrobots.example.com/nft/' . $id,
        'attributes' => [
            [
                'trait_type' => 'Unit Type',
                'value' => $robot['name']
            ],
            [
                'trait_type' => 'Gear',
                'value' => $item['name']
            ],
            [
                'trait_type' => 'Domain',
                'value' => $colorScheme['name']
            ],
            [
                'trait_type' => 'Equipment',
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