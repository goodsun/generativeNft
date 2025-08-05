// Generate JSON lists of local SVG assets

const fs = require('fs');
const path = require('path');

const assetsDir = path.join(__dirname, '../viewer/assets');
const viewerDir = path.join(__dirname, '../viewer');

// Get all SVG files from a directory
function getSVGFiles(dir, category) {
    const files = fs.readdirSync(dir);
    const svgFiles = {};
    
    files.forEach(file => {
        if (file.endsWith('.svg')) {
            const name = file.replace('.svg', '');
            // Create a relative path that works from the viewer directory
            svgFiles[name] = `./assets/${category}/${file}`;
        }
    });
    
    return svgFiles;
}

// Generate monster list
const monsters = getSVGFiles(path.join(assetsDir, 'monsters'), 'monsters');
fs.writeFileSync(path.join(viewerDir, 'monster.json'), JSON.stringify(monsters, null, 2));
console.log(`Generated monster.json with ${Object.keys(monsters).length} items`);

// Generate item list
const items = getSVGFiles(path.join(assetsDir, 'items'), 'items');
fs.writeFileSync(path.join(viewerDir, 'item.json'), JSON.stringify(items, null, 2));
console.log(`Generated item.json with ${Object.keys(items).length} items`);

console.log('\nAsset lists generated successfully!');