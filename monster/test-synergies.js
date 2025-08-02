// Test script for synergy system
const { checkSynergies, calculateRarity } = require('./synergies');

console.log('=== Testing Synergy System ===\n');

// Test cases
const testCases = [
    // Quad Synergy
    { species: 'Dragon', equipment: 'Crown', realm: 'Ragnarok', curse: 'Meteor', expected: 'Cosmic Sovereign' },
    { species: 'Vampire', equipment: 'Wine', realm: 'Bloodmoon', curse: 'Bats', expected: 'Crimson Lord' },
    
    // Trinity Synergy
    { species: 'Dragon', equipment: 'Sword', realm: 'Inferno', curse: 'Burning', expected: 'Primordial Flame Lord' },
    { species: 'Vampire', equipment: 'Wine', realm: 'Shadow', curse: 'Bats', expected: 'Classic Nosferatu' },
    { species: 'Goblin', equipment: 'Sword', realm: 'Frost', curse: 'Blizzard', expected: 'Frozen Fortress' },
    
    // Dual Synergy
    { species: 'Vampire', equipment: 'Wine', realm: 'Abyss', curse: 'Lightning', expected: 'Blood Sommelier' },
    { species: 'Werewolf', equipment: 'Shield', realm: 'Inferno', curse: 'Burning', expected: 'Eternal Flame' },
    
    // No Synergy
    { species: 'Zombie', equipment: 'Crown', realm: 'Frost', curse: 'Lightning', expected: null }
];

// Run tests
testCases.forEach((test, index) => {
    console.log(`Test ${index + 1}:`);
    console.log(`Input: ${test.species}, ${test.equipment}, ${test.realm}, ${test.curse}`);
    
    const synergy = checkSynergies(test.species, test.equipment, test.realm, test.curse);
    
    if (synergy) {
        console.log(`Result: ${synergy.title} (${synergy.type})`);
        console.log(`Story: ${synergy.story}`);
        console.log(`Rarity: ${calculateRarity(50, synergy)}`);
    } else {
        console.log('Result: No synergy found');
        console.log(`Base Rarity: ${calculateRarity(50, null)}`);
    }
    
    const passed = (synergy?.title === test.expected) || (!synergy && !test.expected);
    console.log(`Status: ${passed ? '✓ PASSED' : '✗ FAILED'}`);
    console.log('---\n');
});

// Test specific IDs
console.log('=== Testing Specific Token IDs ===\n');

const testIds = [1, 666, 1337, 7777, 9999];
const { generateMetadataById } = require('./generate');

// Mock loadSVG function for testing
global.loadSVG = async (path) => '<svg></svg>';

testIds.forEach(async (id) => {
    try {
        const metadata = await generateMetadataById(id);
        console.log(`Token #${id}:`);
        console.log(`Name: ${metadata.name}`);
        console.log(`Rarity: ${metadata.attributes.find(a => a.trait_type === 'Rarity').value}`);
        if (metadata.attributes.find(a => a.trait_type === 'Synergy')) {
            console.log(`Synergy: ${metadata.attributes.find(a => a.trait_type === 'Synergy').value}`);
        }
        console.log('---\n');
    } catch (e) {
        console.error(`Error testing token #${id}:`, e.message);
    }
});