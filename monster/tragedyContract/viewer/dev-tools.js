// Tragedy NFT Developer Tools

// Load deployment data
let deploymentData = null;

// Try to load from current directory first, then use hardcoded data as fallback
fetch('./deployment-result.json')
    .then(res => {
        if (!res.ok) throw new Error('File not found');
        return res.json();
    })
    .then(data => {
        deploymentData = data;
        console.log('Deployment data loaded from file:', data);
        console.log('Structure check:', {
            hasContracts: !!data.contracts,
            hasNft: !!data.contracts?.nft,
            hasComposer: !!data.contracts?.composer,
            hasBanks: !!data.contracts?.banks
        });
        try {
            loadContractInfo();
        } catch (error) {
            console.error('Error in loadContractInfo:', error);
        }
    })
    .catch(err => {
        console.warn('Failed to load deployment file, using hardcoded addresses:', err);
        // Use hardcoded deployment data as fallback
        deploymentData = {
            "deployer": "0xCf20a6EcBBedB403DB466D669229d9Ee379C433f",
            "contracts": {
                "nft": "0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0",
                "metadataBank": "0x86bc479C30b9E2b8B572d995eDbeCeed147D67e2",
                "composerV7": "0xD20E944cA0b8f62f66f7bdb24f283408109756F9",
                "composerV6": "0x88b7F93E1DBDF31E190FD6442135A81944366312",
                "banks": {
                    "monsterBank": "0x604BbbE34BA178bb5630f8a1b6CAB5e4eD99f96b",
                    "backgroundBank": "0xE69db878eCaa60Bc1d0b86d1ce11d0e739c7187b",
                    "itemBankV2": "0xDb521CbE76832D55486f1E4900d35d557Cc39C3e",
                    "itemBank": "0x4C75816d7d0E5B08c75b8e17ef338faEbbAD54eF",
                    "effectBankV2": "0xc12688F2Cc73A3f708e44F19dd5D2B38c4f86Dc8",
                    "effectBank": "0x942D2feA13706c2c5b41Af93145Da83D108D9E82"
                },
                "monsters": {
                    "Werewolf": "0xCEa0E7AdD25289983D4BC1203f96C50fe6EbB583",
                    "Goblin": "0xAF54B931D299B69aBE65AfbB3A28BBe17a2998cD",
                    "Frankenstein": "0xBc9930745643aBd6BFeaB954bA2B1b452BFd65B6",
                    "Demon": "0x2Cb700FcDf4808119F2f7A25B846815f916e9e2D",
                    "Dragon": "0x8e1075D091607AC969BEe3d5dd72B0B4e6dABb36",
                    "Zombie": "0xA5D32583dC5E2b42Bf2525B294ada296a7959a39",
                    "Vampire": "0x4f1B372d92869EB6013Ab512fC519F7c51803aa3",
                    "Mummy": "0xeE8e18D656f9D6b7b90468Fd586785D9EdDf2064",
                    "Succubus": "0xe58a5e1153590208b022E10A591292655342576a",
                    "Skeleton": "0xC5453D7178FB772ef60c9D74A97BB7462d9861b6"
                },
                "backgrounds": {
                    "Bloodmoon": "0xC499bcba1eE42ae905d4Ece2C1C4546e75970bF5",
                    "Abyss": "0xae8eADCC1dE100acfb7b9025d714875665530c51",
                    "Decay": "0xf7534CcE3502154A3b81f49754681cE73663f8a3",
                    "Corruption": "0xBe73db2875ff7810486C74fe82584CFe8C6BFF5A",
                    "Venom": "0x4b6f73723D42C9c1Af7A44835FE596Ed11B730F7",
                    "Void": "0x9D8E0929F43dE8773d3E9939Abf1498DaE5aA8eB",
                    "Inferno": "0x5AC76B67F52a7B93BB1B30CCF3650426751e74fc",
                    "Frost": "0x6De8C055109827d80a8a55F9096AcB823d75a000",
                    "Ragnarok": "0xFECB03090c34D8f011709b8880D2f04Bfbb7793C",
                    "Shadow": "0x60b9EF8C3850525b7C4C3d4F7A534Da35C43dAdb"
                },
                "items": {
                    "Crown": "0x013E5974072bbe72EcBdF49fE9a2d3e3bB96D2D6",
                    "Sword": "0x87176615A25B0e14b292A73AAA3313DFF44ef16E",
                    "Shield": "0xe3061e9885820657Fa8DB98f0FC512F996280f8F",
                    "Poison": "0xaA24567Bb7c26BFB7ee5633037A831da1F0aD15e",
                    "Torch": "0x33824C0aBd7B939CD4c053eDC4dD57fc24eeCe61",
                    "Wine": "0xf784067cE3B4B6c2e351217F464B4Bd71c6f8227",
                    "Scythe": "0x4765D14e8b64E33fd6e21F85E633c8543Fe32fCB",
                    "Staff": "0x5988e886D0293bE5fDfAbA4BcC498b7Cb27FaE43",
                    "Shoulder": "0x8FF728088A9805D2bBb7f58f32de9684E10Cc985",
                    "Amulet": "0x365e95F27018803D6B00dc1E7d006e25b9E6f65E"
                },
                "effects": {
                    "Seizure": "0xaeAA83410Da86a0821a99d55226D192bef1BbB11",
                    "Mindblast": "0xC646B0B8874fF3AD87F1d58f0cd0dD091D27ED82",
                    "Confusion": "0x38684375c3Abb337B7Cd71949A9610eB2C329275",
                    "Meteor": "0x8BbDb18C0c6FB1A6399927c34b3DDC16b952fa6D",
                    "Bats": "0xa38E2d6e3e7526143375Fb9c631BD2AA08352a64",
                    "Poisoning": "0xF9A78B61Ad66e14dEeF27E29c180125DA8d7d05D",
                    "Lightning": "0x2b44DB152c812b3719265b2f5820A31996716E93",
                    "Blizzard": "0xeD96D9228bE7B5059a9BaB63b6bF3DBdC2a90dEf",
                    "Burning": "0x98b331b7aDCBe6d6343652e85F6D033AE5a82bf2",
                    "Brainwash": "0x46417Aa37576C4390b3261Af472dA418260a9843"
                }
            }
        };
        loadContractInfo();
    });

// RPC Configuration
const RPC_URL = "https://dev2.bon-soleil.com/rpc";

// Contract ABIs
const COMPOSER_ABI = [
    "function composeSVG(uint8 species, uint8 background, uint8 item, uint8 effect) view returns (string memory)"
];

const BANK_ABI = [
    "function getSpeciesSVG(uint8 id) view returns (string memory)",
    "function getBackgroundSVG(uint8 id) view returns (string memory)",
    "function getItemSVG(uint8 id) view returns (string memory)",
    "function getEffectSVG(uint8 id) view returns (string memory)"
];

const METADATA_ABI = [
    "function getSpeciesNames(uint8 id) view returns (string memory, string memory)",
    "function getBackgroundNames(uint8 id) view returns (string memory, string memory)",
    "function getItemNames(uint8 id) view returns (string memory, string memory)",
    "function getEffectNames(uint8 id) view returns (string memory, string memory)"
];

const NFT_ABI = [
    "function tokenURI(uint256 tokenId) view returns (string)",
    "function tokenAttributes(uint256 tokenId) view returns (uint8 species, uint8 background, uint8 item, uint8 effect)",
    "function getSVG(uint256 tokenId) view returns (string)",
    "function ownerOf(uint256 tokenId) view returns (address)",
    "function totalSupply() view returns (uint256)"
];

// Initialize provider
let provider = null;

async function initProvider() {
    if (!provider) {
        provider = new ethers.providers.JsonRpcProvider(RPC_URL);
        await provider.ready;
    }
    return provider;
}

// Tab switching
function switchTab(tabName) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelectorAll('.tab').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById(`${tabName}-tab`).classList.add('active');
    event.target.classList.add('active');
}

// NFT Viewer Functions
async function loadNFT() {
    const tokenId = document.getElementById('nft-tokenId').value;
    if (!tokenId) return;
    
    const resultDiv = document.getElementById('nft-result');
    resultDiv.innerHTML = '<div class="loading">Loading NFT...</div>';
    
    try {
        await initProvider();
        const nftAddress = deploymentData?.contracts?.nft;
        if (!nftAddress) throw new Error('NFT contract address not found');
        
        const nft = new ethers.Contract(nftAddress, NFT_ABI, provider);
        
        // Get NFT data
        const [owner, attrs, svg] = await Promise.all([
            nft.ownerOf(tokenId).catch(() => 'Not minted'),
            nft.tokenAttributes(tokenId),
            nft.getSVG(tokenId)
        ]);
        
        resultDiv.innerHTML = `
            <div class="contract-info">
                <h3>NFT #${tokenId}</h3>
                <p>Owner: ${owner}</p>
                <p>Species: ${attrs.species} | Background: ${attrs.background} | Item: ${attrs.item} | Effect: ${attrs.effect}</p>
            </div>
            <div class="svg-preview">
                ${svg}
            </div>
            <details>
                <summary style="cursor: pointer; color: #ff6b6b; margin: 10px 0;">View Raw SVG</summary>
                <div class="code-block">${escapeHtml(svg)}</div>
            </details>
        `;
    } catch (error) {
        resultDiv.innerHTML = `<div class="status error">Error: ${error.message}</div>`;
    }
}

// Composer Test Functions
async function testComposer() {
    const species = document.getElementById('composer-species').value;
    const background = document.getElementById('composer-background').value;
    const item = document.getElementById('composer-item').value;
    const effect = document.getElementById('composer-effect').value;
    
    const resultDiv = document.getElementById('composer-result');
    resultDiv.innerHTML = '<div class="loading">Composing SVG...</div>';
    
    try {
        await initProvider();
        const composerAddress = deploymentData?.contracts?.composer;
        if (!composerAddress) throw new Error('Composer contract address not found');
        
        const composer = new ethers.Contract(composerAddress, COMPOSER_ABI, provider);
        
        const svg = await composer.composeSVG(species, background, item, effect);
        
        resultDiv.innerHTML = `
            <div class="contract-info">
                <h3>Composed SVG</h3>
                <p>Composer: ${composerAddress}</p>
                <p>Parameters: species=${species}, background=${background}, item=${item}, effect=${effect}</p>
            </div>
            <div class="svg-preview">
                ${svg}
            </div>
            <details>
                <summary style="cursor: pointer; color: #ff6b6b; margin: 10px 0;">View Raw SVG</summary>
                <div class="code-block">${escapeHtml(svg)}</div>
            </details>
        `;
    } catch (error) {
        resultDiv.innerHTML = `<div class="status error">Error: ${error.message}</div>`;
    }
}

// Bank Functions
function updateBankItems() {
    const bankType = document.getElementById('bank-type').value;
    const itemSelect = document.getElementById('bank-item');
    
    // Update options based on bank type
    itemSelect.innerHTML = '';
    for (let i = 0; i < 10; i++) {
        const option = document.createElement('option');
        option.value = i;
        option.textContent = i;
        itemSelect.appendChild(option);
    }
}

async function loadBankItem() {
    const bankType = document.getElementById('bank-type').value;
    const itemId = document.getElementById('bank-item').value;
    
    const resultDiv = document.getElementById('banks-result');
    resultDiv.innerHTML = '<div class="loading">Loading SVG...</div>';
    
    try {
        await initProvider();
        
        let bankAddress;
        let methodName;
        
        switch (bankType) {
            case 'monster':
                bankAddress = deploymentData?.contracts?.banks?.monsterBank;
                methodName = 'getSpeciesSVG';
                break;
            case 'background':
                bankAddress = deploymentData?.contracts?.banks?.backgroundBank;
                methodName = 'getBackgroundSVG';
                break;
            case 'item':
                bankAddress = deploymentData?.contracts?.banks?.itemBank;
                methodName = 'getItemSVG';
                break;
            case 'effect':
                bankAddress = deploymentData?.contracts?.banks?.effectBank;
                methodName = 'getEffectSVG';
                break;
        }
        
        if (!bankAddress) throw new Error(`${bankType} bank address not found`);
        
        const bank = new ethers.Contract(bankAddress, BANK_ABI, provider);
        const svg = await bank[methodName](itemId);
        
        resultDiv.innerHTML = `
            <div class="contract-info">
                <h3>${bankType.charAt(0).toUpperCase() + bankType.slice(1)} Bank - Item #${itemId}</h3>
                <p>Bank Address: ${bankAddress}</p>
            </div>
            <div class="svg-preview">
                ${svg}
            </div>
            <details>
                <summary style="cursor: pointer; color: #ff6b6b; margin: 10px 0;">View Raw SVG</summary>
                <div class="code-block">${escapeHtml(svg)}</div>
            </details>
        `;
    } catch (error) {
        resultDiv.innerHTML = `<div class="status error">Error: ${error.message}</div>`;
    }
}

async function loadAllBankItems() {
    const bankType = document.getElementById('bank-type').value;
    const resultDiv = document.getElementById('banks-result');
    resultDiv.innerHTML = '<div class="loading">Loading all items...</div>';
    
    try {
        await initProvider();
        
        let bankAddress;
        let methodName;
        let names;
        
        switch (bankType) {
            case 'monster':
                bankAddress = deploymentData?.contracts?.banks?.monsterBank;
                methodName = 'getSpeciesSVG';
                names = ["Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon", "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"];
                break;
            case 'background':
                bankAddress = deploymentData?.contracts?.banks?.backgroundBank;
                methodName = 'getBackgroundSVG';
                names = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
                break;
            case 'item':
                bankAddress = deploymentData?.contracts?.banks?.itemBank;
                methodName = 'getItemSVG';
                names = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Staff", "Shoulder", "Amulet"];
                break;
            case 'effect':
                bankAddress = deploymentData?.contracts?.banks?.effectBank;
                methodName = 'getEffectSVG';
                names = ["Seizure", "Mindblast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brainwash"];
                break;
        }
        
        if (!bankAddress) throw new Error(`${bankType} bank address not found`);
        
        const bank = new ethers.Contract(bankAddress, BANK_ABI, provider);
        
        resultDiv.innerHTML = `
            <div class="contract-info">
                <h3>${bankType.charAt(0).toUpperCase() + bankType.slice(1)} Bank</h3>
                <p>Bank Address: ${bankAddress}</p>
            </div>
            <div class="grid">
        `;
        
        const gridHtml = [];
        for (let i = 0; i < 10; i++) {
            try {
                const svg = await bank[methodName](i);
                gridHtml.push(`
                    <div class="grid-item">
                        <h4>${names[i]}</h4>
                        <div>${svg}</div>
                        <p>ID: ${i}</p>
                    </div>
                `);
            } catch (err) {
                console.error(`Failed to load ${bankType} #${i}:`, err);
            }
        }
        
        resultDiv.innerHTML += gridHtml.join('') + '</div>';
    } catch (error) {
        resultDiv.innerHTML = `<div class="status error">Error: ${error.message}</div>`;
    }
}

// Metadata Functions
async function loadMetadata() {
    const metadataType = document.getElementById('metadata-type').value;
    const resultDiv = document.getElementById('metadata-result');
    resultDiv.innerHTML = '<div class="loading">Loading metadata...</div>';
    
    try {
        await initProvider();
        const metadataAddress = deploymentData?.contracts?.metadataBank;
        if (!metadataAddress) throw new Error('Metadata bank address not found');
        
        const metadata = new ethers.Contract(metadataAddress, METADATA_ABI, provider);
        
        let methodName;
        switch (metadataType) {
            case 'species':
                methodName = 'getSpeciesNames';
                break;
            case 'background':
                methodName = 'getBackgroundNames';
                break;
            case 'item':
                methodName = 'getItemNames';
                break;
            case 'effect':
                methodName = 'getEffectNames';
                break;
        }
        
        let tableHtml = `
            <div class="contract-info">
                <h3>Metadata Bank - ${metadataType.charAt(0).toUpperCase() + metadataType.slice(1)} Names</h3>
                <p>Address: ${metadataAddress}</p>
            </div>
            <table style="width: 100%; margin-top: 20px;">
                <tr style="border-bottom: 1px solid #333;">
                    <th style="text-align: left; padding: 10px;">ID</th>
                    <th style="text-align: left; padding: 10px;">English</th>
                    <th style="text-align: left; padding: 10px;">Japanese</th>
                </tr>
        `;
        
        for (let i = 0; i < 10; i++) {
            try {
                const [english, japanese] = await metadata[methodName](i);
                tableHtml += `
                    <tr style="border-bottom: 1px solid #222;">
                        <td style="padding: 10px;">${i}</td>
                        <td style="padding: 10px;">${english}</td>
                        <td style="padding: 10px;">${japanese}</td>
                    </tr>
                `;
            } catch (err) {
                if (metadataType === 'effect' && i >= 10) break; // Only 10 effects now
                console.error(`Failed to load ${metadataType} #${i}:`, err);
            }
        }
        
        tableHtml += '</table>';
        resultDiv.innerHTML = tableHtml;
    } catch (error) {
        resultDiv.innerHTML = `<div class="status error">Error: ${error.message}</div>`;
    }
}

// Contract Info Functions
async function loadContractInfo() {
    try {
        if (!deploymentData) {
            console.error('No deployment data available');
            return;
        }
        
        const resultDiv = document.getElementById('contracts-result');
        if (!resultDiv) {
            console.error('contracts-result div not found');
            return;
        }
        
        const contracts = deploymentData.contracts;
        if (!contracts) {
            console.error('No contracts in deployment data');
            resultDiv.innerHTML = '<div class="status error">No contracts found in deployment data</div>';
            return;
        }
        
        let html = '<h2>Deployed Contracts</h2>';
        
        // Main contracts
        html += `
        <div class="contract-info">
            <h3>Main Contracts</h3>
            <p>NFT: ${contracts.nft}</p>
            <p>Metadata Bank: ${contracts.metadataBank}</p>
            <p>Active Composer: ${contracts.composer}</p>
        </div>
    `;
    
    // Banks
    if (contracts.banks) {
        html += `
            <div class="contract-info">
                <h3>Material Banks</h3>
                <p>Monster Bank: ${contracts.banks.monsterBank || 'Not deployed'}</p>
                <p>Background Bank: ${contracts.banks.backgroundBank || 'Not deployed'}</p>
                <p>Item Bank: ${contracts.banks.itemBank || 'Not deployed'}</p>
                <p>Effect Bank: ${contracts.banks.effectBank || 'Not deployed'}</p>
            </div>
        `;
    }
    
    // Individual contracts count
    const svgs = contracts.svgs || {};
    const totalContracts = 
        Object.keys(svgs.monsters || {}).length +
        Object.keys(svgs.backgrounds || {}).length +
        Object.keys(svgs.items || {}).length +
        Object.keys(svgs.effects || {}).length;
    
    html += `
        <div class="contract-info">
            <h3>Statistics</h3>
            <p>Total Individual SVG Contracts: ${totalContracts}</p>
            <p>Monsters: ${Object.keys(svgs.monsters || {}).length}</p>
            <p>Backgrounds: ${Object.keys(svgs.backgrounds || {}).length}</p>
            <p>Items: ${Object.keys(svgs.items || {}).length}</p>
            <p>Effects: ${Object.keys(svgs.effects || {}).length}</p>
            <p>Deployed by: ${deploymentData.deployer}</p>
            <p>Deployment time: ${new Date(deploymentData.timestamp).toLocaleString()}</p>
        </div>
    `;
    
    // Network info
    try {
        await initProvider();
        const network = await provider.getNetwork();
        const blockNumber = await provider.getBlockNumber();
        
        html += `
            <div class="contract-info">
                <h3>Network Info</h3>
                <p>Chain ID: ${network.chainId}</p>
                <p>Current Block: ${blockNumber}</p>
                <p>RPC: ${RPC_URL}</p>
            </div>
        `;
    } catch (err) {
        console.error('Failed to get network info:', err);
    }
    
    resultDiv.innerHTML = html;
    } catch (error) {
        console.error('Error in loadContractInfo:', error);
        console.error('Error stack:', error.stack);
        if (resultDiv) {
            resultDiv.innerHTML = `<div class="status error">Error loading contracts: ${error.message}</div>`;
        }
    }
}

// Utility functions
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Initialize on load
window.addEventListener('load', () => {
    updateBankItems();
});