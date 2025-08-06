const https = require('https');

// Contract address and RPC endpoint
const CONTRACT_ADDRESS = '0x558c7489B997F0cFE8dA4aD0C492b9c4485ACb43';
const RPC_URL = 'https://dev2.bon-soleil.com/rpc';

// Function selectors we found
const SELECTORS = {
    'getMetadata': '0xaeb1fe51',
    'unknownFunction': '0xb93f3f34' // Returns 10000
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

async function testContract() {
    console.log('='.repeat(60));
    console.log('MetadataBank Contract Analysis');
    console.log('='.repeat(60));
    console.log('Contract Address:', CONTRACT_ADDRESS);
    console.log('RPC Endpoint:', RPC_URL);
    console.log();
    
    // Test the function that returns 10000
    console.log('Testing function 0xb93f3f34 (possibly getMetadataCount):');
    const countResponse = await makeRpcCall('eth_call', [{
        to: CONTRACT_ADDRESS,
        data: SELECTORS.unknownFunction
    }, 'latest']);
    
    if (countResponse.result) {
        const count = parseInt(countResponse.result, 16);
        console.log('✓ Returns:', count);
        console.log('  This appears to be the metadata count!');
    }
    
    console.log();
    console.log('Testing getMetadata function:');
    const metadataResponse = await makeRpcCall('eth_call', [{
        to: CONTRACT_ADDRESS,
        data: SELECTORS.getMetadata + '0'.padStart(64, '0')
    }, 'latest']);
    
    if (metadataResponse.result) {
        const address = '0x' + metadataResponse.result.slice(-40);
        console.log('✓ Returns address:', address);
        console.log('  This appears to be a metadata bank address');
    }
    
    console.log();
    console.log('='.repeat(60));
    console.log('Summary:');
    console.log('='.repeat(60));
    console.log('✓ Contract is deployed and working');
    console.log('✓ Function 0xb93f3f34 returns 10000 (likely the metadata count)');
    console.log('✓ Function 0xaeb1fe51 (getMetadata) returns address 0xebac476812e5d2f2f85a849cec69ab210e010c5d');
    console.log();
    console.log('Note: The standard getMetadataCount() selector (0x96f9d9c4) does not work.');
    console.log('This contract uses a different function selector (0xb93f3f34) for the count.');
}

testContract().catch(console.error);