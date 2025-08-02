// Test equipment transformation system
const { checkSynergies } = require('./synergies');

console.log('=== Equipment Transformation Test ===\n');

// Test cases for equipment transformation
const testCases = [
    // Should transform Amulet -> Head
    {
        name: 'Werewolf + Amulet (should transform to Head)',
        species: 'Werewolf',
        equipment: 'Amulet',
        equipmentTransform: 'Head',
        realm: 'Bloodmoon',
        curse: 'Lightning',
        expectedSynergy: 'The Alpha\'s Trophy'
    },
    {
        name: 'Werewolf + Amulet -> Head (Quad synergy)',
        species: 'Werewolf',
        equipment: 'Amulet',
        equipmentTransform: 'Head',
        realm: 'Abyss',
        curse: 'Confusion',
        expectedSynergy: 'Lunatic Alpha'
    },
    // Should transform Shoulder Armor -> Arm
    {
        name: 'Frankenstein + Shoulder Armor (should transform to Arm)',
        species: 'Frankenstein',
        equipment: 'Shoulder Armor',
        equipmentTransform: 'Arm',
        realm: 'Decay',
        curse: 'Lightning',
        expectedSynergy: 'The Collector'
    },
    {
        name: 'Zombie + Shoulder Armor -> Arm (Quad synergy)',
        species: 'Zombie',
        equipment: 'Shoulder Armor',
        equipmentTransform: 'Arm',
        realm: 'Decay',
        curse: 'Poisoning',
        expectedSynergy: 'Rotting Collector'
    },
    // Should NOT transform (no synergy)
    {
        name: 'Dragon + Amulet (no transformation)',
        species: 'Dragon',
        equipment: 'Amulet',
        equipmentTransform: null,
        realm: 'Inferno',
        curse: 'Meteor',
        expectedSynergy: null
    },
    {
        name: 'Vampire + Shoulder Armor (no transformation)',
        species: 'Vampire',
        equipment: 'Shoulder Armor',
        equipmentTransform: null,
        realm: 'Bloodmoon',
        curse: 'Bats',
        expectedSynergy: null
    }
];

testCases.forEach(test => {
    console.log(`Test: ${test.name}`);
    
    // First check with original equipment
    const originalSynergy = checkSynergies(test.species, test.equipment, test.realm, test.curse);
    console.log(`  Original (${test.equipment}): ${originalSynergy ? originalSynergy.title : 'No synergy'}`);
    
    // Then check with transformed equipment
    if (test.equipmentTransform) {
        const transformedSynergy = checkSynergies(test.species, test.equipmentTransform, test.realm, test.curse);
        console.log(`  Transformed (${test.equipmentTransform}): ${transformedSynergy ? transformedSynergy.title : 'No synergy'}`);
        
        // Verify transformation should happen
        const shouldTransform = transformedSynergy !== null;
        console.log(`  Should transform: ${shouldTransform ? 'YES' : 'NO'}`);
        
        if (test.expectedSynergy) {
            const success = transformedSynergy && transformedSynergy.title === test.expectedSynergy;
            console.log(`  Result: ${success ? '✓ PASSED' : '✗ FAILED'}`);
        }
    } else {
        console.log(`  No transformation expected`);
        console.log(`  Result: ${!originalSynergy ? '✓ PASSED' : '✗ FAILED'}`);
    }
    
    console.log('---\n');
});

console.log('=== Summary ===');
console.log('Equipment transformation system allows:');
console.log('- Amulet → Head (for specific synergies)');
console.log('- Shoulder Armor → Arm (for specific synergies)');
console.log('- Maintains all existing synergy stories');
console.log('- Visual implementation remains simple');