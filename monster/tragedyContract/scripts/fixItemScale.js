// Fix item SVG scale from 48x48 to 24x24

const fs = require('fs');
const path = require('path');

// Get all item contract files
const itemsDir = path.join(__dirname, '../contracts/layer4/generated/items');
const itemFiles = fs.readdirSync(itemsDir).filter(f => f.endsWith('.sol'));

console.log(`Found ${itemFiles.length} item contracts to fix`);

itemFiles.forEach(file => {
    const filePath = path.join(itemsDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Function to scale down coordinates
    function scaleCoordinate(match, p1) {
        const value = parseFloat(p1);
        const scaled = value / 2;
        // Keep integers as integers when possible
        return scaled % 1 === 0 ? scaled.toString() : scaled.toFixed(1);
    }
    
    // Replace all coordinate values
    content = content.replace(/x="([0-9.]+)"/g, (match, p1) => `x="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/y="([0-9.]+)"/g, (match, p1) => `y="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/width="([0-9.]+)"/g, (match, p1) => `width="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/height="([0-9.]+)"/g, (match, p1) => `height="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/cx="([0-9.]+)"/g, (match, p1) => `cx="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/cy="([0-9.]+)"/g, (match, p1) => `cy="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/r="([0-9.]+)"/g, (match, p1) => `r="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/rx="([0-9.]+)"/g, (match, p1) => `rx="${scaleCoordinate(match, p1)}"`);
    content = content.replace(/ry="([0-9.]+)"/g, (match, p1) => `ry="${scaleCoordinate(match, p1)}"`);
    
    // Scale polygon points
    content = content.replace(/points="([^"]+)"/g, (match, points) => {
        const scaledPoints = points.split(' ').map(pair => {
            const [x, y] = pair.split(',');
            const scaledX = scaleCoordinate('', x);
            const scaledY = scaleCoordinate('', y);
            return `${scaledX},${scaledY}`;
        }).join(' ');
        return `points="${scaledPoints}"`;
    });
    
    // Scale path d attributes (simple cases)
    content = content.replace(/\bM\s*([0-9.]+)\s+([0-9.]+)/g, (match, x, y) => {
        return `M${scaleCoordinate('', x)} ${scaleCoordinate('', y)}`;
    });
    content = content.replace(/\bL\s*([0-9.]+)\s+([0-9.]+)/g, (match, x, y) => {
        return `L${scaleCoordinate('', x)} ${scaleCoordinate('', y)}`;
    });
    
    // Write back
    fs.writeFileSync(filePath, content);
    console.log(`Fixed: ${file}`);
});

console.log('All item contracts have been scaled to 24x24');