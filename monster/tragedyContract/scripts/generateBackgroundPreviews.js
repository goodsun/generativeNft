// Generate SVG preview files from Solidity contracts

const fs = require('fs');
const path = require('path');

const backgrounds = [
    'Venom', 'Corruption', 'Void', 'Ragnarok', 'Shadow'
];

const solidityDir = path.join(__dirname, '../contracts/layer4/svgs/bg-pixel');
const previewDir = path.join(solidityDir, 'preview');

// Ensure preview directory exists
if (!fs.existsSync(previewDir)) {
    fs.mkdirSync(previewDir, { recursive: true });
}

backgrounds.forEach(bg => {
    const solidityFile = path.join(solidityDir, `Tragedy${bg}Pixel.sol`);
    const svgFile = path.join(previewDir, `${bg.toLowerCase()}.svg`);
    
    // Read Solidity file
    const content = fs.readFileSync(solidityFile, 'utf8');
    
    // Extract SVG content between the quotes
    const svgMatch = content.match(/<svg[^>]*>[\s\S]*?<\/svg>/);
    if (svgMatch) {
        let svg = svgMatch[0];
        // Unescape quotes
        svg = svg.replace(/\\"/g, '"');
        svg = svg.replace(/\\'/g, "'");
        
        // Format SVG with proper indentation
        svg = svg.replace(/></g, '>\n<');
        
        fs.writeFileSync(svgFile, svg);
        console.log(`Created ${bg.toLowerCase()}.svg`);
    }
});

console.log('\nAll preview SVGs generated!');