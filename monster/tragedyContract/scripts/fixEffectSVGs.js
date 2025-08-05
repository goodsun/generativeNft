const fs = require('fs');
const path = require('path');

// Fix effect SVGs to use viewBox="0 0 24 24" and remove scale(10)
function fixEffectSVG(svgContent) {
    // Replace width/height with viewBox
    let fixed = svgContent.replace(
        /<svg[^>]*width="240"[^>]*height="240"[^>]*>/,
        '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">'
    );
    
    // Remove scale(10) transform
    fixed = fixed.replace(/transform="scale\(10\)"/g, '');
    
    // Fix coordinates (divide by 10)
    // Fix x coordinates
    fixed = fixed.replace(/x="(\d+)"/g, (match, num) => {
        const newNum = parseInt(num) / 10;
        return `x="${newNum}"`;
    });
    
    // Fix y coordinates
    fixed = fixed.replace(/y="(-?\d+)"/g, (match, num) => {
        const newNum = parseInt(num) / 10;
        return `y="${newNum}"`;
    });
    
    // Fix font-size
    fixed = fixed.replace(/font-size="(\d+)"/g, (match, num) => {
        const newNum = parseInt(num) / 10;
        return `font-size="${newNum}"`;
    });
    
    // Fix translate values in animations
    fixed = fixed.replace(/values="([^"]+)"/g, (match, values) => {
        // Check if this is a translate animation value
        if (values.includes(',') && !values.includes('#')) {
            const newValues = values.split(';').map(pair => {
                const coords = pair.trim().split(',');
                if (coords.length === 2) {
                    const x = parseFloat(coords[0]);
                    const y = parseFloat(coords[1]);
                    // Only divide by 10 if the values seem to be in the 240 scale
                    if (Math.abs(x) > 5 || Math.abs(y) > 5) {
                        return `${x/10},${y/10}`;
                    }
                }
                return pair;
            }).join(';');
            return `values="${newValues}"`;
        }
        return match;
    });
    
    return fixed;
}

// Process all effect SVGs
const effectsDir = path.join(__dirname, '../../assets/effect');
const outputDir = path.join(__dirname, '../../assets/effect-fixed');

// Create output directory
if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

// Process each file
const files = fs.readdirSync(effectsDir).filter(f => f.endsWith('.svg'));

files.forEach(file => {
    const content = fs.readFileSync(path.join(effectsDir, file), 'utf8');
    const fixed = fixEffectSVG(content);
    
    fs.writeFileSync(path.join(outputDir, file), fixed);
    console.log(`Fixed: ${file}`);
});

console.log(`\n✅ Fixed ${files.length} effect SVG files`);
console.log(`Output directory: ${outputDir}`);