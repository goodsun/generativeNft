const https = require('https');

// Contract address and RPC endpoint
const CONTRACT_ADDRESS = '0x558c7489B997F0cFE8dA4aD0C492b9c4485ACb43';
const RPC_URL = 'https://dev2.bon-soleil.com/rpc';

// Function selectors
const GET_METADATA_COUNT_SELECTOR = '0x96f9d9c4'; // getMetadataCount()
const GET_METADATA_SELECTOR = '0xaeb1fe51'; // getMetadata(uint256)

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

async function checkContract() {
    try {
        // 1. Check if contract exists by getting code
        console.log('Checking if contract exists at:', CONTRACT_ADDRESS);
        const codeResponse = await makeRpcCall('eth_getCode', [CONTRACT_ADDRESS, 'latest']);
        
        if (codeResponse.error) {
            console.error('Error getting contract code:', codeResponse.error);
            return;
        }
        
        const hasCode = codeResponse.result && codeResponse.result !== '0x';
        console.log('Contract exists:', hasCode);
        
        if (!hasCode) {
            console.log('No contract found at this address');
            return;
        }
        
        // 2. Try different function calls to understand the contract
        console.log('\nTrying to call different functions...');
        
        // Try getMetadataCount()
        console.log('\n1. Calling getMetadataCount()...');
        const countResponse = await makeRpcCall('eth_call', [{
            to: CONTRACT_ADDRESS,
            data: GET_METADATA_COUNT_SELECTOR
        }, 'latest']);
        
        if (countResponse.error) {
            console.error('Error calling getMetadataCount:', countResponse.error);
        } else if (countResponse.result && countResponse.result !== '0x') {
            const count = parseInt(countResponse.result, 16);
            console.log('Metadata count:', count);
        }
        
        // Try getMetadata(0)
        console.log('\n2. Calling getMetadata(0)...');
        const metadataResponse = await makeRpcCall('eth_call', [{
            to: CONTRACT_ADDRESS,
            data: GET_METADATA_SELECTOR + '0000000000000000000000000000000000000000000000000000000000000000'
        }, 'latest']);
        
        if (metadataResponse.error) {
            console.error('Error calling getMetadata(0):', metadataResponse.error);
        } else if (metadataResponse.result && metadataResponse.result !== '0x') {
            console.log('Got metadata response (first 100 chars):', metadataResponse.result.substring(0, 100) + '...');
        }
        
        // Try to decode the bytecode to understand what type of contract this is
        console.log('\n3. Analyzing contract bytecode...');
        const bytecode = codeResponse.result;
        console.log('Bytecode length:', bytecode.length);
        console.log('First 100 chars of bytecode:', bytecode.substring(0, 100) + '...');
        
    } catch (error) {
        console.error('Error:', error);
    }
}

checkContract();