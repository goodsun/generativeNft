const https = require('https');
const { ethers } = require('ethers');

// Contract address and RPC endpoint
const CONTRACT_ADDRESS = '0x558c7489B997F0cFE8dA4aD0C492b9c4485ACb43';
const RPC_URL = 'https://dev2.bon-soleil.com/rpc';

// Common function selectors
const SELECTORS = {
    'getMetadata(uint256)': '0xaeb1fe51',
    'getMetadataCount()': '0x96f9d9c4',
    'owner()': '0x8da5cb5b',
    'totalSupply()': '0x18160ddd',
    'name()': '0x06fdde03',
    'symbol()': '0x95d89b41'
};

// Make RPC call
function makeRpcCall(method, params) {
    return new Promise((resolve, reject) => {
        const data = JSON.stringify({
            jsonrpc: '2.0',
            method: method,
            params: params,
            id: 1
        });

        const url = new URL(RPC_URL);
        const options = {
            hostname: url.hostname,
            port: url.port,
            path: url.pathname,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': data.length
            }
        };

        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                try {
                    const response = JSON.parse(responseData);
                    resolve(response);
                } catch (error) {
                    reject(error);
                }
            });
        });

        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

async function analyzeContract() {
    try {
        console.log('Analyzing contract at:', CONTRACT_ADDRESS);
        console.log('RPC endpoint:', RPC_URL);
        console.log('=' .repeat(60));
        
        // Try different function calls
        for (const [funcName, selector] of Object.entries(SELECTORS)) {
            console.log(`\nTrying ${funcName}...`);
            
            const response = await makeRpcCall('eth_call', [{
                to: CONTRACT_ADDRESS,
                data: selector
            }, 'latest']);
            
            if (response.error) {
                console.log(`❌ Error: ${response.error.message}`);
            } else if (response.result && response.result !== '0x') {
                console.log(`✓ Success! Raw result: ${response.result}`);
                
                // Try to decode the result based on function name
                if (funcName === 'owner()' || funcName.includes('address')) {
                    try {
                        const decoded = '0x' + response.result.slice(-40);
                        console.log(`  Decoded address: ${decoded}`);
                    } catch (e) {}
                }
                
                if (funcName === 'totalSupply()' || funcName === 'getMetadataCount()') {
                    try {
                        const value = parseInt(response.result, 16);
                        console.log(`  Decoded value: ${value}`);
                    } catch (e) {}
                }
                
                if (funcName === 'name()' || funcName === 'symbol()') {
                    try {
                        // Decode string return value
                        const decoded = ethers.utils.defaultAbiCoder.decode(['string'], response.result);
                        console.log(`  Decoded string: "${decoded[0]}"`);
                    } catch (e) {
                        console.log('  Could not decode as string');
                    }
                }
            } else {
                console.log('❌ No result or empty result');
            }
        }
        
        // Try getMetadata with different token IDs
        console.log('\n' + '=' .repeat(60));
        console.log('\nTrying getMetadata with different token IDs...');
        
        for (const tokenId of [0, 1, 100, 9999]) {
            console.log(`\ngetMetadata(${tokenId}):`);
            const data = SELECTORS['getMetadata(uint256)'] + tokenId.toString(16).padStart(64, '0');
            
            const response = await makeRpcCall('eth_call', [{
                to: CONTRACT_ADDRESS,
                data: data
            }, 'latest']);
            
            if (response.error) {
                console.log(`❌ Error: ${response.error.message}`);
            } else if (response.result && response.result !== '0x') {
                console.log(`✓ Got response (length: ${response.result.length})`);
                console.log(`  First 200 chars: ${response.result.substring(0, 200)}...`);
                
                // Try to decode as string
                try {
                    const decoded = ethers.utils.defaultAbiCoder.decode(['string'], response.result);
                    const metadata = decoded[0];
                    console.log(`  Decoded length: ${metadata.length} chars`);
                    
                    // If it's a data URI, try to parse the JSON
                    if (metadata.startsWith('data:application/json')) {
                        const base64Part = metadata.split(',')[1];
                        const jsonStr = Buffer.from(base64Part, 'base64').toString();
                        const json = JSON.parse(jsonStr);
                        console.log('  Parsed metadata:');
                        console.log(`    Name: ${json.name}`);
                        console.log(`    Description: ${json.description}`);
                        if (json.attributes) {
                            console.log('    Attributes:', json.attributes);
                        }
                    } else {
                        console.log(`  First 100 chars of decoded: ${metadata.substring(0, 100)}...`);
                    }
                } catch (e) {
                    console.log('  Could not decode as string:', e.message);
                }
            }
        }
        
    } catch (error) {
        console.error('Error:', error);
    }
}

// Check if ethers is installed
try {
    require('ethers');
    analyzeContract();
} catch (e) {
    console.log('ethers.js not installed. Installing...');
    const { execSync } = require('child_process');
    execSync('npm install ethers@5', { stdio: 'inherit' });
    console.log('Installed ethers.js. Please run the script again.');
}