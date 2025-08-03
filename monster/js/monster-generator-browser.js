// Pixel Monsters NFT Generator - Browser Version
// This file combines synergies.js and generate.js for easier browser usage

// ===== SYNERGIES SYSTEM =====

// Quad Synergy (Ultimate Combinations) - 0.01% chance
const quadSynergies = [
    {
        combo: ['Dragon', 'Crown', 'Ragnarok', 'Meteor'],
        title: 'Cosmic Sovereign',
        story: 'The cosmic ruler who brings the end times. Its crown channels meteor storms that herald the final days.',
        rarity: 'Mythic'
    },
    {
        combo: ['Skeleton', 'Scythe', 'Shadow', 'Mind Blast'],
        title: 'Soul Harvester',
        story: 'The ultimate reaper of souls. Its psychic scythe cuts through both flesh and consciousness.',
        rarity: 'Mythic'
    },
    {
        combo: ['Vampire', 'Wine', 'Bloodmoon', 'Bats'],
        title: 'Crimson Lord',
        story: 'Under the blood moon, the crimson ruler commands legions of bats. The ancient vampire lord in its truest form.',
        rarity: 'Mythic'
    },
    {
        combo: ['Demon', 'Torch', 'Inferno', 'Lightning'],
        title: 'Hellstorm Avatar',
        story: 'The incarnation of hell\'s tempest. Lightning-wreathed flames announce its apocalyptic arrival.',
        rarity: 'Mythic'
    },
    {
        combo: ['Succubus', 'Magic Wand', 'Corruption', 'Brain Wash'],
        title: 'Mind Empress',
        story: 'The corrupted empress who enslaves minds. Her wand weaves thoughts into chains of eternal servitude.',
        rarity: 'Mythic'
    },
    {
        combo: ['Mummy', 'Sword', 'Void', 'Burning'],
        title: 'Eternal Warrior',
        story: 'An immortal ancient warrior wrapped in void flames. Time means nothing to this burning guardian.',
        rarity: 'Mythic'
    },
    {
        combo: ['Frankenstein', 'Poison', 'Venom', 'Seizure'],
        title: 'Toxic Abomination',
        story: 'An undying monster saturated with poison. Its body convulses eternally from the toxins it cannot expel.',
        rarity: 'Mythic'
    },
    {
        combo: ['Werewolf', 'Head', 'Abyss', 'Confusion'],
        title: 'Lunatic Alpha',
        story: 'The pack leader consumed by abyssal madness. It carries trophies of those who challenged its insanity.',
        rarity: 'Mythic'
    },
    {
        combo: ['Zombie', 'Arm', 'Decay', 'Poisoning'],
        title: 'Rotting Collector',
        story: 'A putrid corpse collector spreading toxic decay. Each arm in its collection tells a story of plague.',
        rarity: 'Mythic'
    },
    {
        combo: ['Goblin', 'Shield', 'Frost', 'Blizzard'],
        title: 'Frozen Guardian',
        story: 'The ice sprite defending eternal permafrost. Its shield channels blizzards that freeze time itself.',
        rarity: 'Mythic'
    }
];

// Trinity Synergies (3-element combinations) - 0.1% chance
const trinitySynergies = [
    // Fire Trinity
    { combo: ['Dragon', 'Sword', 'Burning'], title: 'Primordial Flame Lord', story: 'The original fire drake wielding a blade forged in creation\'s flames.' },
    { combo: ['Demon', 'Torch', 'Inferno'], title: 'Hell\'s Gatekeeper', story: 'Guardian of the infernal gates, its torch lights the path to damnation.' },
    
    // Death Trinity
    { combo: ['Skeleton', 'Scythe', 'Shadow'], title: 'Death Incarnate', story: 'Death given form, harvesting souls in shadow\'s embrace.' },
    { combo: ['Zombie', 'Head', 'Decay'], title: 'Undead Overlord', story: 'The first risen, commanding legions with severed heads as trophies.' },
    
    // Mind Trinity
    { combo: ['Succubus', 'Wine', 'Brain Wash'], title: 'Mind Seductress', story: 'She who intoxicates minds with cursed wine and forbidden desires.' },
    { combo: ['Vampire', 'Crown', 'Mind Blast'], title: 'Psychic Monarch', story: 'The vampire king whose crown amplifies psychic dominion.' },
    { combo: ['Vampire', 'Wine', 'Bats'], title: 'Classic Nosferatu', story: 'The iconic vampire in its most traditional form - wine, blood, and winged servants.', autoLegendary: true },
    
    // Nature Trinity
    { combo: ['Werewolf', 'Arm', 'Bloodmoon'], title: 'Lunar Beast', story: 'Under the blood moon, the beast collects arms of fallen hunters.' },
    { combo: ['Mummy', 'Void', 'Ragnarok'], title: 'Ancient Apocalypse', story: 'The void-touched pharaoh who brings the end of ages.' },
    
    // Madness Trinity
    { combo: ['Frankenstein', 'Lightning', 'Seizure'], title: 'Aberrant Creation', story: 'Lightning-born abomination wracked by eternal spasms.' },
    { combo: ['Goblin', 'Corruption', 'Confusion'], title: 'Mad Trickster', story: 'A corrupted goblin spreading chaos through mind-bending pranks.' },
    
    // Poison Trinity (Species-agnostic)
    { combo: ['Poison', 'Venom', 'Poisoning'], title: 'Toxic Trinity', story: 'The perfect convergence of all toxic forces.', speciesAgnostic: true },
    
    // Ice Trinity (Species-agnostic)
    { combo: ['Shield', 'Frost', 'Blizzard'], title: 'Frozen Fortress', story: 'An impenetrable defense of eternal winter.', speciesAgnostic: true },
    
    // Cosmic Trinity (Species-agnostic)
    { combo: ['Magic Wand', 'Abyss', 'Meteor'], title: 'Cosmic Sorcery', story: 'Deep space magic calling meteors from the abyss.', speciesAgnostic: true }
];

// Dual Synergies - 1% chance
const dualSynergies = {
    speciesEquipment: [
        // Legendary tier
        { combo: ['Vampire', 'Wine'], title: 'Blood Sommelier', story: 'A refined predator who has transcended mere survival. This vampire has cultivated an exquisite palate for the finest vintages - both wine and blood.', tier: 'Legendary' },
        { combo: ['Skeleton', 'Scythe'], title: 'Death\'s Herald', story: 'The original harbinger of doom. This skeletal reaper has collected souls since the dawn of mortality itself.', tier: 'Legendary' },
        { combo: ['Dragon', 'Crown'], title: 'The Fallen Monarch', story: 'Once ruled the skies with absolute authority. Now seeks to reclaim the throne stolen by lesser beings.', tier: 'Legendary' },
        { combo: ['Demon', 'Torch'], title: 'Infernal Lightkeeper', story: 'Guardian of the eternal flames that bridge the mortal realm and the underworld. Its torch never extinguishes.', tier: 'Legendary' },
        { combo: ['Werewolf', 'Head'], title: 'The Alpha\'s Trophy', story: 'This werewolf carries the severed head of its pack\'s former leader, a grim reminder of the brutal law of nature.', tier: 'Legendary' },
        
        // Epic tier
        { combo: ['Frankenstein', 'Arm'], title: 'The Collector', story: 'An abomination that grafts new limbs onto itself, growing stronger with each defeated foe.', tier: 'Epic' },
        { combo: ['Mummy', 'Magic Wand'], title: 'Pharaoh\'s Awakening', story: 'An ancient ruler risen from eternal slumber, wielding the wand of divine authority.', tier: 'Epic' },
        { combo: ['Goblin', 'Sword'], title: 'Blade Master', story: 'A goblin warrior who mastered the way of the blade through centuries of combat.', tier: 'Epic' },
        { combo: ['Succubus', 'Shield'], title: 'Temptress Guardian', story: 'A succubus who protects her victims from other demons, keeping them for herself.', tier: 'Epic' },
        { combo: ['Zombie', 'Poison'], title: 'Patient Zero', story: 'The original infected. Its toxic blood spawned the great plague that consumed civilizations.', tier: 'Epic' }
    ],
    
    curseRealm: [
        { combo: ['Burning', 'Inferno'], title: 'Eternal Flame', story: 'Fire that burns without fuel, consuming reality itself.' },
        { combo: ['Blizzard', 'Frost'], title: 'Absolute Zero', story: 'Where ice meets storm, nothing survives.' },
        { combo: ['Poisoning', 'Venom'], title: 'Toxic Miasma', story: 'A poisonous fog that corrupts all it touches.' },
        { combo: ['Mind Blast', 'Void'], title: 'Mental Collapse', story: 'The void between thoughts where sanity dies.' },
        { combo: ['Lightning', 'Bloodmoon'], title: 'Crimson Thunder', story: 'Blood-red lightning that strikes with divine wrath.' },
        { combo: ['Brain Wash', 'Corruption'], title: 'Mind Corruption', story: 'Thoughts twisted into weapons against their owner.' },
        { combo: ['Meteor', 'Ragnarok'], title: 'Apocalypse Rain', story: 'The sky falls, bringing the end of all things.' },
        { combo: ['Bats', 'Shadow'], title: 'Night Terror', story: 'Living shadows that feast on fear.' },
        { combo: ['Confusion', 'Decay'], title: 'Madness Plague', story: 'A disease that rots both mind and body.' },
        { combo: ['Seizure', 'Abyss'], title: 'Deep Tremor', story: 'Convulsions from staring too long into the infinite dark.' }
    ]
};

// Check for synergies
function checkSynergies(species, equipment, realm, curse) {
    const elements = [species, equipment, realm, curse].filter(e => e);
    
    // Check Quad Synergy first (highest priority)
    const quadMatch = quadSynergies.find(s => 
        s.combo.every(el => elements.includes(el))
    );
    if (quadMatch) {
        return { type: 'quad', ...quadMatch };
    }
    
    // Check Trinity Synergies
    const trinityMatch = trinitySynergies.find(s => {
        if (s.speciesAgnostic) {
            // For species-agnostic synergies, just check if all elements are present
            return s.combo.every(el => elements.includes(el));
        } else {
            // For normal trinity, all combo elements must match
            return s.combo.every(el => elements.includes(el));
        }
    });
    if (trinityMatch) {
        return { type: 'trinity', ...trinityMatch };
    }
    
    // Check Dual Synergies
    const dualMatches = [];
    
    // Check Species + Equipment
    const speciesEquipMatch = dualSynergies.speciesEquipment.find(s =>
        s.combo[0] === species && s.combo[1] === equipment
    );
    if (speciesEquipMatch) {
        dualMatches.push({ type: 'dual', category: 'species-equipment', ...speciesEquipMatch });
    }
    
    // Check Curse + Realm
    const curseRealmMatch = dualSynergies.curseRealm.find(s =>
        (s.combo[0] === curse && s.combo[1] === realm) ||
        (s.combo[0] === realm && s.combo[1] === curse)
    );
    if (curseRealmMatch) {
        dualMatches.push({ type: 'dual', category: 'curse-realm', ...curseRealmMatch });
    }
    
    if (dualMatches.length > 0) {
        // If multiple dual synergies, combine them
        if (dualMatches.length > 1) {
            return {
                type: 'dual-combo',
                matches: dualMatches,
                title: dualMatches.map(m => m.title).join(' & '),
                story: dualMatches.map(m => m.story).join(' ')
            };
        }
        return dualMatches[0];
    }
    
    return null;
}

// Calculate rarity based on synergies
function calculateRarity(baseSeed, synergy) {
    const baseRarity = (baseSeed % 100) + 1;
    
    if (synergy) {
        if (synergy.rarity === 'Mythic') return 'Mythic';
        if (synergy.autoLegendary) return 'Legendary';
        
        switch (synergy.type) {
            case 'quad':
                return 'Mythic';
            case 'trinity':
                if (baseRarity > 50) return 'Legendary';
                return 'Epic';
            case 'dual':
            case 'dual-combo':
                if (synergy.tier === 'Legendary' || baseRarity > 80) return 'Legendary';
                if (synergy.tier === 'Epic' || baseRarity > 60) return 'Epic';
                return 'Rare';
            default:
                break;
        }
    }
    
    // Base rarity calculation
    if (baseRarity > 95) return 'Legendary';
    if (baseRarity > 85) return 'Epic';
    if (baseRarity > 70) return 'Rare';
    if (baseRarity > 50) return 'Uncommon';
    return 'Common';
}

// Generate story for non-synergy combinations
function generateBaseStory(species, equipment, realm, curse) {
    return `A ${realm.toLowerCase()}-touched ${species.toLowerCase()} wielding ${equipment.toLowerCase()}, cursed with ${curse.toLowerCase()}. A unique specimen from the Pixel Monsters collection.`;
}

// ===== GENERATOR SYSTEM =====

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
        ${Array.from({length: 25}, (_, i) => {
            const startX = Math.floor(Math.random() * 40) - 10;
            const size = Math.random() > 0.7 ? 2 : 1;
            const delay = Math.random() * 2;
            const duration = 0.75 + Math.random() * 0.5;
            const speed = Math.random() > 0.5 ? 1.5 : 1;
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
        <rect x="0" y="0" width="24" height="24" fill="#B0E0E6" opacity="0">
            <animate attributeName="opacity" 
                     values="0;0.15;0.25;0.15;0" 
                     dur="1.5s" 
                     repeatCount="indefinite"/>
        </rect>
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
            <rect x="12" y="20" width="1" height="1" fill="#FFFF00">
                <animate attributeName="x" values="12;11;12;13;12" dur="2s" begin="0.2s" repeatCount="indefinite"/>
                <animate attributeName="opacity" values="0;1;0.8;1;0" dur="2s" begin="0.2s" repeatCount="indefinite"/>
            </rect>
        </g>
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

// Special legendary IDs
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

// Seeded random number generator
function seededRandom(seed) {
    const x = Math.sin(seed) * 10000;
    return x - Math.floor(x);
}

// Get element from array based on seed
function getSeededElement(array, seed, offset = 0) {
    const index = Math.floor(seededRandom(seed + offset) * array.length);
    return array[index];
}

// Load SVG file (browser environment)
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

// Generate metadata by ID
async function generateMetadataById(id) {
    const seed = parseInt(id) || 0;
    
    // Check for legendary ID
    const legendaryData = legendaryIds ? legendaryIds[seed] : null;
    
    let monster, item;
    
    // Override for legendary IDs
    if (legendaryData && legendaryData.override) {
        if (legendaryData.override.monster) {
            monster = monsters.find(m => m.name === legendaryData.override.monster);
        } else {
            monster = getSeededElement(monsters, seed, 1);
        }
        
        if (legendaryData.override.item) {
            item = items.find(i => i.name === legendaryData.override.item);
        } else {
            item = getSeededElement(items, seed, 2);
        }
    } else {
        monster = getSeededElement(monsters, seed, 1);
        item = getSeededElement(items, seed, 2);
    }
    
    const colorScheme = getSeededElement(colorSchemes, seed, 3);
    const effect = getSeededElement(effects, seed, 4);
    
    // Transform equipment for synergy check if needed
    let equipmentName = item.name;
    if (item.synergyForm) {
        // Check if this combination would create a synergy with the transformed form
        const transformedSynergy = checkSynergies(monster.name, item.synergyForm, colorScheme.name, effect.name);
        if (transformedSynergy) {
            equipmentName = item.synergyForm;
        }
    }
    
    // Check for synergies
    const synergy = checkSynergies(monster.name, equipmentName, colorScheme.name, effect.name);
    
    // Calculate rarity
    let rarity = calculateRarity(seed, synergy);
    
    // Override for legendary IDs
    if (legendaryData) {
        rarity = 'Legendary';
    }
    
    // Generate name and story
    let name, description;
    
    if (legendaryData && legendaryData.title) {
        name = `${legendaryData.title} #${id}`;
        description = legendaryData.story;
    } else if (synergy) {
        name = `${synergy.title} #${id}`;
        description = synergy.story;
    } else {
        name = `${colorScheme.name} ${monster.name} #${id}`;
        description = generateBaseStory(monster.name, item.name, colorScheme.name, effect.name);
    }
    
    // Generate SVG image
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

// Generate composite SVG image
async function generateCompositeImage(monsterSVG, itemSVG, colorScheme, effect, item) {
    const svg = `
        <svg width="240" height="240" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <filter id="pixelate">
                    <feFlood x="0" y="0" width="1" height="1" flood-color="${colorScheme.background}"/>
                    <feComposite in2="SourceGraphic" operator="over"/>
                </filter>
            </defs>
            <!-- Background -->
            <rect width="240" height="240" fill="${colorScheme.background}"/>
            
            <!-- Grid pattern -->
            <g opacity="0.1">
                ${Array.from({length: 10}, (_, i) => `<line x1="${i * 24}" y1="0" x2="${i * 24}" y2="240" stroke="#000" stroke-width="1"/>`).join('')}
                ${Array.from({length: 10}, (_, i) => `<line x1="0" y1="${i * 24}" x2="240" y2="${i * 24}" stroke="#000" stroke-width="1"/>`).join('')}
            </g>
            
            <!-- Monster with color filter -->
            <g transform="translate(12, 12) scale(9)">
                <g style="filter: hue-rotate(${colorScheme.hueRotate}deg) saturate(${colorScheme.saturate || 1.5})">
                    ${monsterSVG.replace(/<svg[^>]*>|<\/svg>/g, '')}
                </g>
            </g>
            
            <!-- Item positioned near monster -->
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
            
            <!-- Effect -->
            <g transform="scale(10)">
                ${effect.svg}
            </g>
        </svg>
    `;
    return 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
}

// Make functions available globally for browser use
window.generateMetadataById = generateMetadataById;
window.checkSynergies = checkSynergies;
window.calculateRarity = calculateRarity;
window.generateBaseStory = generateBaseStory;