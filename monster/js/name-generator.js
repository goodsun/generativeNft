// Name generation system for non-synergy NFTs

// Equipment titles and their power levels
const equipmentData = {
    'Crown': { power: 9, titles: ['King', 'Lord', 'Monarch', 'Sovereign'] },
    'Scythe': { power: 8, titles: ['Reaper', 'Harvester', 'Death', 'Grim'] },
    'Magic Wand': { power: 7, titles: ['Sorcerer', 'Wizard', 'Mage', 'Mystic'] },
    'Sword': { power: 6, titles: ['Blade', 'Warrior', 'Knight', 'Slayer'] },
    'Shield': { power: 5, titles: ['Guardian', 'Defender', 'Protector', 'Sentinel'] },
    'Poison': { power: 4, titles: ['Toxic', 'Venomous', 'Plague', 'Blight'] },
    'Torch': { power: 3, titles: ['Burning', 'Flame', 'Pyre', 'Ember'] },
    'Amulet': { power: 2, titles: ['Cursed', 'Enchanted', 'Blessed', 'Charmed'] },
    'Wine': { power: 2, titles: ['Drunk', 'Intoxicated', 'Wasted', 'Tipsy'] },
    'Shoulder Armor': { power: 1, titles: ['Armored', 'Plated', 'Protected', 'Shielded'] },
    // Handle transformed equipment
    'Arm': { power: 1, titles: ['Armed', 'Grasping', 'Reaching', 'Clawed'] },
    'Head': { power: 2, titles: ['Headed', 'Skulled', 'Minded', 'Brained'] }
};

// Curse adjectives and their power levels
const curseData = {
    'Mind Blast': { power: 9, adjectives: ['Psycho', 'Mad', 'Demented', 'Insane'] },
    'Brain Wash': { power: 8, adjectives: ['Hypnotized', 'Controlled', 'Enslaved', 'Dominated'] },
    'Lightning': { power: 7, adjectives: ['Electric', 'Shocked', 'Thunderous', 'Voltaic'] },
    'Burning': { power: 6, adjectives: ['Ablaze', 'Scorched', 'Ignited', 'Flaming'] },
    'Blizzard': { power: 5, adjectives: ['Frozen', 'Icy', 'Frostbitten', 'Glacial'] },
    'Meteor': { power: 5, adjectives: ['Cosmic', 'Stellar', 'Celestial', 'Astral'] },
    'Poisoning': { power: 4, adjectives: ['Poisoned', 'Infected', 'Diseased', 'Contaminated'] },
    'Confusion': { power: 3, adjectives: ['Confused', 'Lost', 'Bewildered', 'Dazed'] },
    'Seizure': { power: 2, adjectives: ['Twitching', 'Convulsing', 'Spasmic', 'Shaking'] },
    'Bats': { power: 1, adjectives: ['Swarmed', 'Winged', 'Nocturnal', 'Flying'] }
};

// Get random element from array based on seed
function getSeededArrayElement(array, seed) {
    const index = Math.floor((Math.sin(seed) * 10000 - Math.floor(Math.sin(seed) * 10000)) * array.length);
    return array[index];
}

// Generate name for non-synergy NFTs
function generateDynamicName(species, equipment, realm, curse, seed) {
    const equipData = equipmentData[equipment] || { power: 0, titles: ['Unknown'] };
    const curseInfo = curseData[curse] || { power: 0, adjectives: ['Cursed'] };
    
    let prefix;
    
    // Compare power levels to determine which takes precedence
    if (equipData.power >= curseInfo.power) {
        // Equipment is more defining - use equipment title (prioritize equipment on tie)
        prefix = getSeededArrayElement(equipData.titles, seed);
    } else {
        // Curse is more defining - use curse adjective
        prefix = getSeededArrayElement(curseInfo.adjectives, seed);
    }
    
    return `${prefix} ${species} on ${realm}`;
}

// Generate story based on the dominant trait
function generateDynamicStory(species, equipment, realm, curse, seed) {
    const equipData = equipmentData[equipment] || { power: 0 };
    const curseInfo = curseData[curse] || { power: 0 };
    
    let story;
    
    if (equipData.power >= curseInfo.power) {
        // Equipment-focused story (prioritize equipment on tie)
        story = `A ${species.toLowerCase()} that has claimed the ${equipment.toLowerCase()} as its symbol of power. `;
        story += `It roams the ${realm.toLowerCase()} realm, marked by the curse of ${curse.toLowerCase()}.`;
    } else {
        // Curse-focused story
        story = `A ${species.toLowerCase()} consumed by ${curse.toLowerCase()}, wielding ${equipment.toLowerCase()} in madness. `;
        story += `The ${realm.toLowerCase()} realm echoes with its tormented presence.`;
    }
    
    return story;
}

// Export for both Node.js and browser
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        generateDynamicName,
        generateDynamicStory,
        equipmentData,
        curseData
    };
} else if (typeof window !== 'undefined') {
    window.generateDynamicName = generateDynamicName;
    window.generateDynamicStory = generateDynamicStory;
    window.equipmentData = equipmentData;
    window.curseData = curseData;
}