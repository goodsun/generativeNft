const https = require('https');

// Contract addresses and RPC endpoint
const CONTRACT_ADDRESS = '0x558c7489B997F0cFE8dA4aD0C492b9c4485ACb43';
const METADATA_BANK_ADDRESS = '0xebac476812e5d2f2f85a849cec69ab210e010c5d';
const RPC_URL = 'https://dev2.bon-soleil.com/rpc';

// Common function selectors
const SELECTORS = {
    'getMetadata(uint256)': '0xaeb1fe51',
    'getMetadataCount()': '0x96f9d9c4',
    'owner()': '0x8da5cb5b',
    'totalSupply()': '0x18160ddd',
    'MAX_SUPPLY()': '0x32cb6b0c'
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

// Decode string from hex
function decodeString(hexData) {
    // Remove 0x prefix if present
    hexData = hexData.startsWith('0x') ? hexData.slice(2) : hexData;
    
    // Skip first 64 chars (offset) and next 64 chars (length)
    if (hexData.length > 128) {
        const lengthHex = hexData.substring(64, 128);
        const length = parseInt(lengthHex, 16) * 2; // Convert to hex chars
        const stringHex = hexData.substring(128, 128 + length);
        
        // Convert hex to string
        let result = '';
        for (let i = 0; i < stringHex.length; i += 2) {
            result += String.fromCharCode(parseInt(stringHex.substr(i, 2), 16));
        }
        return result;
    }
    return null;
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
                    const decoded = '0x' + response.result.slice(-40);
                    console.log(`  Decoded address: ${decoded}`);
                }
                
                if (funcName.includes('Count') || funcName.includes('Supply') || funcName.includes('MAX')) {
                    const value = parseInt(response.result, 16);
                    console.log(`  Decoded value: ${value}`);
                }
            } else {
                console.log('❌ No result or empty result');
            }
        }
        
        // Try getMetadata with different token IDs
        console.log('\n' + '=' .repeat(60));
        console.log('\nTrying getMetadata with different token IDs...');
        
        for (const tokenId of [0, 1, 100, 9999, 10000]) {
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
                
                // Try to decode as string
                const decoded = decodeString(response.result);
                if (decoded) {
                    console.log(`  Decoded string (${decoded.length} chars)`);
                    console.log(`  First 200 chars: ${decoded.substring(0, 200)}...`);
                    
                    // If it's a data URI, try to parse the JSON
                    if (decoded.startsWith('data:application/json;base64,')) {
                        const base64Part = decoded.split(',')[1];
                        const jsonStr = Buffer.from(base64Part, 'base64').toString();
                        const json = JSON.parse(jsonStr);
                        console.log('  Parsed metadata:');
                        console.log(`    Name: ${json.name}`);
                        console.log(`    Description: ${json.description.substring(0, 100)}...`);
                        if (json.attributes) {
                            console.log('    Attributes:', JSON.stringify(json.attributes, null, 2));
                        }
                    }
                } else {
                    console.log(`  Could not decode as string. Raw data: ${response.result.substring(0, 200)}...`);
                }
            }
        }
        
    } catch (error) {
        console.error('Error:', error);
    }
}

async function analyzeMetadataBank() {
    console.log('\n' + '=' .repeat(60));
    console.log('\nAnalyzing MetadataBank at:', METADATA_BANK_ADDRESS);
    console.log('=' .repeat(60));
    
    // Check if contract exists
    const codeResponse = await makeRpcCall('eth_getCode', [METADATA_BANK_ADDRESS, 'latest']);
    if (codeResponse.result && codeResponse.result !== '0x') {
        console.log('✓ Contract exists (bytecode length:', codeResponse.result.length + ')');
    } else {
        console.log('❌ No contract at this address');
        return;
    }
    
    // Try getMetadataCount on the metadata bank
    console.log('\nTrying getMetadataCount() on MetadataBank...');
    const countResponse = await makeRpcCall('eth_call', [{
        to: METADATA_BANK_ADDRESS,
        data: SELECTORS['getMetadataCount()']
    }, 'latest']);
    
    if (countResponse.error) {
        console.log('❌ Error:', countResponse.error.message);
    } else if (countResponse.result) {
        const count = parseInt(countResponse.result, 16);
        console.log('✓ Metadata count:', count);
    }
    
    // Try getMetadata on the metadata bank
    console.log('\nTrying getMetadata(0) on MetadataBank...');
    const metadataResponse = await makeRpcCall('eth_call', [{
        to: METADATA_BANK_ADDRESS,
        data: SELECTORS['getMetadata(uint256)'] + '0'.padStart(64, '0')
    }, 'latest']);
    
    if (metadataResponse.error) {
        console.log('❌ Error:', metadataResponse.error.message);
    } else if (metadataResponse.result) {
        console.log('✓ Got response (length:', metadataResponse.result.length + ')');
        const decoded = decodeString(metadataResponse.result);
        if (decoded && decoded.length > 0) {
            console.log('  Decoded metadata:', decoded.substring(0, 200) + '...');
        }
    }
}

async function main() {
    await analyzeContract();
    await analyzeMetadataBank();
}

main().catch(console.error);