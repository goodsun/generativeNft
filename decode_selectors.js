const https = require('https');

// Contract address and RPC endpoint
const CONTRACT_ADDRESS = '0x558c7489B997F0cFE8dA4aD0C492b9c4485ACb43';
const RPC_URL = 'https://dev2.bon-soleil.com/rpc';

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

async function extractSelectors() {
    try {
        // Get contract bytecode
        const response = await makeRpcCall('eth_getCode', [CONTRACT_ADDRESS, 'latest']);
        
        if (!response.result || response.result === '0x') {
            console.log('No contract found');
            return;
        }
        
        const bytecode = response.result;
        console.log('Contract bytecode length:', bytecode.length);
        
        // Look for function selectors in the bytecode
        // Function selectors are 4 bytes (8 hex chars) and often appear in switch statements
        // Let's look for patterns like "63XXXXXXXX" or "7eXXXXXXXX" which are common prefixes
        
        const selectorPattern = /(?:63|7e|80|81|82|83)[0-9a-f]{6}/gi;
        const matches = bytecode.match(selectorPattern);
        
        if (matches) {
            console.log('\nPotential function selectors found:');
            const uniqueSelectors = [...new Set(matches)];
            
            for (const selector of uniqueSelectors) {
                console.log('0x' + selector);
            }
            
            // Try calling each selector to see which ones work
            console.log('\nTesting selectors...\n');
            
            for (const selector of uniqueSelectors) {
                const callData = '0x' + selector;
                const response = await makeRpcCall('eth_call', [{
                    to: CONTRACT_ADDRESS,
                    data: callData
                }, 'latest']);
                
                if (!response.error && response.result && response.result !== '0x') {
                    console.log(`✓ ${callData} works! Result: ${response.result.substring(0, 66)}...`);
                }
            }
        }
        
        // Also look for the specific selectors we see in the bytecode
        console.log('\nLooking for known selector patterns in bytecode...');
        
        // From the bytecode snippet we can see: 7efd9112, a574cea4, aeb1fe51, b93f3f34, cf3e290c
        const knownSelectors = [
            '0x7efd9112',
            '0xa574cea4', 
            '0xaeb1fe51', // This is getMetadata
            '0xb93f3f34',
            '0xcf3e290c'
        ];
        
        console.log('\nTesting known selectors from bytecode:');
        for (const selector of knownSelectors) {
            const response = await makeRpcCall('eth_call', [{
                to: CONTRACT_ADDRESS,
                data: selector
            }, 'latest']);
            
            if (response.error) {
                console.log(`${selector}: ❌ ${response.error.message}`);
            } else if (response.result && response.result !== '0x') {
                console.log(`${selector}: ✓ Result: ${response.result}`);
            } else {
                console.log(`${selector}: Empty result`);
            }
        }
        
    } catch (error) {
        console.error('Error:', error);
    }
}

extractSelectors();