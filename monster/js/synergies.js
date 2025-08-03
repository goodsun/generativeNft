// Synergy System for The Mythical Cursed-Nightmare

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
    return `A ${realm.toLowerCase()}-touched ${species.toLowerCase()} wielding ${equipment.toLowerCase()}, cursed with ${curse.toLowerCase()}. Essay #${Math.floor(Math.random() * 10000)} from the cursed collection.`;
}

// Export for both Node.js and browser
if (typeof module !== 'undefined' && module.exports) {
    // Node.js
    module.exports = {
        quadSynergies,
        trinitySynergies,
        dualSynergies,
        checkSynergies,
        calculateRarity,
        generateBaseStory
    };
} else if (typeof window !== 'undefined') {
    // Browser
    window.quadSynergies = quadSynergies;
    window.trinitySynergies = trinitySynergies;
    window.dualSynergies = dualSynergies;
    window.checkSynergies = checkSynergies;
    window.calculateRarity = calculateRarity;
    window.generateBaseStory = generateBaseStory;
}