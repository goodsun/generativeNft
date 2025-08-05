// Check SVG tag formats for each layer

const fs = require('fs');
const path = require('path');

async function checkSVGTags() {
    const layers = {
        'backgrounds': '../contracts/layer4/svgs/bg',
        'monsters': '../contracts/layer4/svgs/monsters', 
        'items': '../contracts/layer4/svgs/items',
        'effects': '../contracts/layer4/svgs/effects'
    };
    
    console.log('=== SVG Tag Formats by Layer ===\n');
    
    for (const [layerName, dirPath] of Object.entries(layers)) {
        console.log(`\n${layerName.toUpperCase()}:`);
        console.log('-'.repeat(50));
        
        const fullPath = path.join(__dirname, dirPath);
        if (!fs.existsSync(fullPath)) {
            console.log(`Directory not found: ${fullPath}`);
            continue;
        }
        
        const files = fs.readdirSync(fullPath).filter(f => f.endsWith('.sol'));
        
        // Check first file in each category
        if (files.length > 0) {
            const content = fs.readFileSync(path.join(fullPath, files[0]), 'utf8');
            
            // Extract SVG tag
            const svgTagMatch = content.match(/<svg[^>]*>/);
            if (svgTagMatch) {
                const svgTag = svgTagMatch[0]
                    .replace(/\\"/g, '"')  // Unescape quotes
                    .replace(/\\\\"/g, '\\"'); // Keep escaped quotes
                console.log(`Sample (${files[0]}):`);
                console.log(svgTag);
                
                // Check for defs
                const hasDefsMatch = content.match(/<defs>/);
                if (hasDefsMatch) {
                    console.log('Contains <defs>: YES');
                } else {
                    console.log('Contains <defs>: NO');
                }
            }
            
            // Show all files in this category
            console.log(`\nFiles (${files.length} total):`);
            files.slice(0, 3).forEach(f => console.log(`  - ${f}`));
            if (files.length > 3) console.log(`  ... and ${files.length - 3} more`);
        }
    }
}

checkSVGTags();