<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');

$adjectives = ['Mystical', 'Legendary', 'Cosmic', 'Ancient', 'Ethereal', 'Radiant', 'Shadow', 'Crystal', 'Golden', 'Silver'];
$nouns = ['Dragon', 'Phoenix', 'Unicorn', 'Griffin', 'Sphinx', 'Kraken', 'Pegasus', 'Hydra', 'Minotaur', 'Chimera'];
$colors = ['Red', 'Blue', 'Green', 'Purple', 'Gold', 'Silver', 'Black', 'White', 'Rainbow', 'Crystal'];

function seededRandom($seed) {
    $x = sin($seed) * 10000;
    return $x - floor($x);
}

function getSeededElement($array, $seed, $offset = 0) {
    $index = floor(seededRandom($seed + $offset) * count($array));
    return $array[$index];
}

function generateMetadataById($id) {
    global $adjectives, $nouns, $colors;
    
    $seed = intval($id) ?: 0;
    $adjective = getSeededElement($adjectives, $seed, 1);
    $noun = getSeededElement($nouns, $seed, 2);
    $color = getSeededElement($colors, $seed, 3);
    $powerLevel = floor(seededRandom($seed + 4) * 100) + 1;
    
    $name = "$adjective $noun #$id";
    $description = "A rare " . strtolower($color) . " " . strtolower($noun) . " with " . strtolower($adjective) . " powers. This unique NFT is part of the legendary collection.";
    
    // エフェクトの生成
    $effectIndex = floor(($powerLevel - 1) / 10);
    $effects = [
        // 0-10: 回転する光の粒子
        '<g><animateTransform attributeName="transform" type="rotate" from="0 300 300" to="360 300 300" dur="30s" repeatCount="indefinite"/><circle cx="450" cy="150" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="2s" repeatCount="indefinite"/></circle><circle cx="512" cy="300" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="2.2s" repeatCount="indefinite"/></circle><circle cx="450" cy="450" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="2.4s" repeatCount="indefinite"/></circle><circle cx="300" cy="512" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="2.6s" repeatCount="indefinite"/></circle><circle cx="150" cy="450" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="2.8s" repeatCount="indefinite"/></circle><circle cx="88" cy="300" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="3s" repeatCount="indefinite"/></circle><circle cx="150" cy="150" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="3.2s" repeatCount="indefinite"/></circle><circle cx="300" cy="88" r="4" fill="white" opacity="0.6"><animate attributeName="opacity" values="0.6;0.2;0.6" dur="3.4s" repeatCount="indefinite"/></circle></g>',
        // 11-20: 複数の星
        '<g><text x="200" y="100" font-size="30" fill="yellow">★</text><text x="300" y="100" font-size="30" fill="yellow">★</text><text x="400" y="100" font-size="30" fill="yellow">★</text></g>',
        // 21-30: 回転する魔法陣
        '<g opacity="0.7"><circle cx="300" cy="300" r="180" fill="none" stroke="cyan" stroke-width="2"/><circle cx="300" cy="300" r="150" fill="none" stroke="cyan" stroke-width="1"/><animateTransform attributeName="transform" type="rotate" from="0 300 300" to="360 300 300" dur="20s" repeatCount="indefinite"/><line x1="300" y1="120" x2="300" y2="150" stroke="cyan" stroke-width="2"/><circle cx="300" cy="120" r="8" fill="cyan"><animate attributeName="r" values="8;12;8" dur="2s" repeatCount="indefinite"/></circle><line x1="460" y1="210" x2="439" y2="225" stroke="cyan" stroke-width="2"/><circle cx="460" cy="210" r="8" fill="cyan"><animate attributeName="r" values="8;12;8" dur="2s" begin="0.3s" repeatCount="indefinite"/></circle><line x1="460" y1="390" x2="439" y2="375" stroke="cyan" stroke-width="2"/><circle cx="460" cy="390" r="8" fill="cyan"><animate attributeName="r" values="8;12;8" dur="2s" begin="0.6s" repeatCount="indefinite"/></circle><line x1="300" y1="480" x2="300" y2="450" stroke="cyan" stroke-width="2"/><circle cx="300" cy="480" r="8" fill="cyan"><animate attributeName="r" values="8;12;8" dur="2s" begin="0.9s" repeatCount="indefinite"/></circle><line x1="140" y1="390" x2="161" y2="375" stroke="cyan" stroke-width="2"/><circle cx="140" cy="390" r="8" fill="cyan"><animate attributeName="r" values="8;12;8" dur="2s" begin="1.2s" repeatCount="indefinite"/></circle><line x1="140" y1="210" x2="161" y2="225" stroke="cyan" stroke-width="2"/><circle cx="140" cy="210" r="8" fill="cyan"><animate attributeName="r" values="8;12;8" dur="2s" begin="1.5s" repeatCount="indefinite"/></circle></g>',
        // 31-40: パルスする輪
        '<circle cx="300" cy="300" r="200" fill="none" stroke="white" stroke-width="2" opacity="0.3"><animate attributeName="r" values="200;250;200" dur="3s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.3;0.1;0.3" dur="3s" repeatCount="indefinite"/></circle>',
        // 41-50: 回転する光線
        '<g><g opacity="0.5"><animateTransform attributeName="transform" type="rotate" from="0 300 300" to="360 300 300" dur="15s" repeatCount="indefinite"/><line x1="300" y1="300" x2="300" y2="50" stroke="gold" stroke-width="3"/><line x1="300" y1="300" x2="300" y2="550" stroke="gold" stroke-width="3"/><circle cx="300" cy="50" r="5" fill="gold"><animate attributeName="r" values="5;8;5" dur="2s" repeatCount="indefinite"/></circle><circle cx="300" cy="550" r="5" fill="gold"><animate attributeName="r" values="5;8;5" dur="2s" begin="1s" repeatCount="indefinite"/></circle></g><g opacity="0.5"><animateTransform attributeName="transform" type="rotate" from="0 300 300" to="-360 300 300" dur="15s" repeatCount="indefinite"/><line x1="300" y1="300" x2="50" y2="300" stroke="gold" stroke-width="3"/><line x1="300" y1="300" x2="550" y2="300" stroke="gold" stroke-width="3"/><circle cx="50" cy="300" r="5" fill="gold"><animate attributeName="r" values="5;8;5" dur="2s" begin="0.5s" repeatCount="indefinite"/></circle><circle cx="550" cy="300" r="5" fill="gold"><animate attributeName="r" values="5;8;5" dur="2s" begin="1.5s" repeatCount="indefinite"/></circle></g></g>',
        // 51-60: ダイヤモンド
        '<path d="M300,150 L450,300 L300,450 L150,300 Z" fill="none" stroke="magenta" stroke-width="3" opacity="0.5"><animateTransform attributeName="transform" type="rotate" from="0 300 300" to="360 300 300" dur="8s" repeatCount="indefinite"/></path>',
        // 61-70: オーラ
        '<ellipse cx="300" cy="300" rx="200" ry="250" fill="none" stroke="url(#aura)" stroke-width="3" opacity="0.6"><animate attributeName="rx" values="200;220;200" dur="2s" repeatCount="indefinite"/></ellipse><defs><linearGradient id="aura"><stop offset="0%" style="stop-color:cyan;stop-opacity:1"/><stop offset="100%" style="stop-color:magenta;stop-opacity:1"/></linearGradient></defs>',
        // 71-80: ダビデの星（六芒星）
        '<g><g opacity="0.8" transform="rotate(90 300 300)"><animateTransform attributeName="transform" type="rotate" from="90 300 300" to="450 300 300" dur="12s" repeatCount="indefinite"/><path d="M300,150 L430,375 L170,375 Z" fill="none" stroke="cyan" stroke-width="3"><animate attributeName="stroke" values="cyan;white;cyan" dur="4s" repeatCount="indefinite"/></path><circle cx="300" cy="150" r="5" fill="cyan"><animate attributeName="r" values="5;8;5" dur="2s" repeatCount="indefinite"/><animate attributeName="fill" values="cyan;white;cyan" dur="4s" repeatCount="indefinite"/></circle><circle cx="430" cy="375" r="5" fill="cyan"><animate attributeName="r" values="5;8;5" dur="2s" begin="0.67s" repeatCount="indefinite"/><animate attributeName="fill" values="cyan;white;cyan" dur="4s" repeatCount="indefinite"/></circle><circle cx="170" cy="375" r="5" fill="cyan"><animate attributeName="r" values="5;8;5" dur="2s" begin="1.33s" repeatCount="indefinite"/><animate attributeName="fill" values="cyan;white;cyan" dur="4s" repeatCount="indefinite"/></circle></g><g opacity="0.8" transform="rotate(90 300 300)"><animateTransform attributeName="transform" type="rotate" from="90 300 300" to="-270 300 300" dur="12s" repeatCount="indefinite"/><path d="M300,450 L430,225 L170,225 Z" fill="none" stroke="cyan" stroke-width="3"><animate attributeName="stroke" values="cyan;white;cyan" dur="4s" begin="2s" repeatCount="indefinite"/></path><circle cx="300" cy="450" r="5" fill="cyan"><animate attributeName="r" values="5;8;5" dur="2s" begin="1s" repeatCount="indefinite"/><animate attributeName="fill" values="cyan;white;cyan" dur="4s" begin="2s" repeatCount="indefinite"/></circle><circle cx="430" cy="225" r="5" fill="cyan"><animate attributeName="r" values="5;8;5" dur="2s" begin="1.67s" repeatCount="indefinite"/><animate attributeName="fill" values="cyan;white;cyan" dur="4s" begin="2s" repeatCount="indefinite"/></circle><circle cx="170" cy="225" r="5" fill="cyan"><animate attributeName="r" values="5;8;5" dur="2s" begin="0.33s" repeatCount="indefinite"/><animate attributeName="fill" values="cyan;white;cyan" dur="4s" begin="2s" repeatCount="indefinite"/></circle></g></g>',
        // 81-90: 螺旋
        '<path d="M300,300 m-150,0 a150,150 0 0,1 300,0 a150,150 0 0,1 -300,0" fill="none" stroke="lime" stroke-width="3" opacity="0.6" stroke-dasharray="20,10"><animate attributeName="stroke-dashoffset" values="0;30" dur="1s" repeatCount="indefinite"/></path>',
        // 91-100: 究極のエフェクト
        '<g><circle cx="300" cy="300" r="250" fill="none" stroke="url(#ultimate)" stroke-width="5" opacity="0.8"><animate attributeName="r" values="250;280;250" dur="2s" repeatCount="indefinite"/></circle><path d="M300,50 L350,200 L500,200 L380,290 L430,440 L300,340 L170,440 L220,290 L100,200 L250,200 Z" fill="gold" opacity="0.6"><animateTransform attributeName="transform" type="rotate" from="0 300 300" to="360 300 300" dur="10s" repeatCount="indefinite"/></path><defs><linearGradient id="ultimate" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="0%" style="stop-color:gold;stop-opacity:1"/><stop offset="50%" style="stop-color:cyan;stop-opacity:1"/><stop offset="100%" style="stop-color:magenta;stop-opacity:1"/></linearGradient></defs></g>'
    ];
    $effect = isset($effects[$effectIndex]) ? $effects[$effectIndex] : $effects[0];
    
    // SVG画像の生成
    $r = floor(seededRandom($seed + 100) * 256);
    $g = floor(seededRandom($seed + 200) * 256);
    $b = floor(seededRandom($seed + 300) * 256);
    
    // Power Levelに基づいてスケールを決定（0.7〜1.3の範囲）
    $scale = 0.7 + ($powerLevel / 100) * 0.6;
    $translate = 300 * (1/$scale - 1);
    
    $svg = '<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="0%" style="stop-color:rgb('.$r.','.$g.','.$b.');stop-opacity:1" /><stop offset="100%" style="stop-color:#1a1a1a;stop-opacity:1" /></linearGradient></defs><rect width="600" height="600" fill="url(#grad1)"/><g transform="scale('.$scale.') translate('.$translate.', '.$translate.')">' . $effect . '</g><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="Arial, sans-serif" font-size="40" fill="white" font-weight="bold"><animate attributeName="opacity" values="0.6;1;0.6" dur="3s" repeatCount="indefinite"/><animate attributeName="fill" values="white;#f0f0f0;white" dur="2s" repeatCount="indefinite"/>' . htmlspecialchars($name) . '</text></svg>';
    $image = 'data:image/svg+xml;base64,' . base64_encode($svg);
    
    return [
        'name' => $name,
        'description' => $description,
        'image' => $image,
        'attributes' => [
            ['trait_type' => 'Bloodline', 'value' => $noun],
            ['trait_type' => 'Ancient Force', 'value' => $adjective],
            ['trait_type' => 'Elemental Affinity', 'value' => $color],
            ['trait_type' => 'Arcane Potency', 'value' => $powerLevel]
        ]
    ];
}

$id = isset($_GET['id']) ? $_GET['id'] : null;

if ($id !== null) {
    echo json_encode(generateMetadataById($id), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
} else {
    http_response_code(400);
    echo json_encode(['error' => 'ID parameter is required'], JSON_PRETTY_PRINT);
}
?>