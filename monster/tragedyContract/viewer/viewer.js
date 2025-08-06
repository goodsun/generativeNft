// Tragedy NFT Viewer JavaScript

// Contract configuration
const NFT_ADDRESS = "0xb0C8bCef9bBEd995b18E0fe6cB7029cB7c90E796";
const RPC_URL = "https://dev2.bon-soleil.com/rpc";

// NFT ABI (minimal)
const NFT_ABI = [
    "function totalSupply() view returns (uint256)",
    "function tokenOfOwnerByIndex(address owner, uint256 index) view returns (uint256)",
    "function balanceOf(address owner) view returns (uint256)",
    "function tokenURI(uint256 tokenId) view returns (string)",
    "function tokenAttributes(uint256 tokenId) view returns (uint8 species, uint8 background, uint8 item, uint8 effect)",
    "function getSVG(uint256 tokenId) view returns (string)",
    "function ownerOf(uint256 tokenId) view returns (address)"
];

// Metadata names
const SPECIES_NAMES = ["Werewolf", "Goblin", "Frankenstein", "Demon", "Dragon", "Zombie", "Vampire", "Mummy", "Succubus", "Skeleton"];
const BACKGROUND_NAMES = ["Bloodmoon", "Abyss", "Decay", "Corruption", "Venom", "Void", "Inferno", "Frost", "Ragnarok", "Shadow"];
const ITEM_NAMES = ["Crown", "Sword", "Shield", "Poison", "Torch", "Wine", "Scythe", "Staff", "Shoulder", "Amulet"];
const EFFECT_NAMES = ["Seizure", "Mindblast", "Confusion", "Meteor", "Bats", "Poisoning", "Lightning", "Blizzard", "Burning", "Brainwash"];

let provider;
let nftContract;

// Initialize on page load
window.addEventListener('load', async () => {
    try {
        // Initialize provider
        console.log('Connecting to:', RPC_URL);
        provider = new ethers.providers.JsonRpcProvider(RPC_URL);
        
        // Wait for provider to be ready
        await provider.ready;
        console.log('Provider ready');
        
        // Create contract instance
        nftContract = new ethers.Contract(NFT_ADDRESS, NFT_ABI, provider);
        console.log('Contract created at:', NFT_ADDRESS);
        
        // Update stats
        const totalSupply = await nftContract.totalSupply();
        console.log('Total supply:', totalSupply.toString());
        document.getElementById('totalSupply').textContent = totalSupply.toString();
    } catch (error) {
        console.error('Error during initialization:', error);
        document.getElementById('totalSupply').textContent = 'Error';
        
        // Show detailed error
        const container = document.getElementById('nftContainer');
        container.innerHTML = `<div class="error">
            Connection Error: ${error.message}<br>
            Please check console for details.
        </div>`;
    }
    
    // Check if Web3 wallet is connected
    if (window.ethereum) {
        try {
            const accounts = await window.ethereum.request({ method: 'eth_accounts' });
            if (accounts.length > 0) {
                document.getElementById('connectedAddress').textContent = accounts[0].slice(0, 6) + '...' + accounts[0].slice(-4);
            }
        } catch (error) {
            console.error('Error checking wallet:', error);
        }
    }
});

// Load all minted NFTs
async function loadAllNFTs() {
    const container = document.getElementById('nftContainer');
    container.innerHTML = '<div class="loading">Loading all NFTs...</div>';
    
    try {
        const totalSupply = await nftContract.totalSupply();
        const totalCount = totalSupply.toNumber();
        
        container.innerHTML = '';
        
        // Load NFTs in batches
        const batchSize = 10;
        for (let i = 1; i <= totalCount; i += batchSize) {
            const promises = [];
            for (let j = i; j < Math.min(i + batchSize, totalCount + 1); j++) {
                promises.push(loadNFTData(j));
            }
            
            const nfts = await Promise.all(promises);
            nfts.forEach(nft => {
                if (nft) {
                    container.appendChild(createNFTCard(nft));
                }
            });
        }
        
        if (totalCount === 0) {
            container.innerHTML = '<div class="loading">No NFTs minted yet</div>';
        }
    } catch (error) {
        container.innerHTML = `<div class="error">Error loading NFTs: ${error.message}</div>`;
    }
}

// Load NFTs for a specific wallet
async function loadWalletNFTs() {
    const walletAddress = document.getElementById('walletAddress').value;
    if (!walletAddress || !ethers.utils.isAddress(walletAddress)) {
        alert('Please enter a valid wallet address');
        return;
    }
    
    const container = document.getElementById('nftContainer');
    container.innerHTML = '<div class="loading">Loading wallet NFTs...</div>';
    
    try {
        const balance = await nftContract.balanceOf(walletAddress);
        const count = balance.toNumber();
        
        container.innerHTML = '';
        
        const promises = [];
        for (let i = 0; i < count; i++) {
            promises.push(
                nftContract.tokenOfOwnerByIndex(walletAddress, i)
                    .then(tokenId => loadNFTData(tokenId.toNumber()))
            );
        }
        
        const nfts = await Promise.all(promises);
        nfts.forEach(nft => {
            if (nft) {
                container.appendChild(createNFTCard(nft));
            }
        });
        
        if (count === 0) {
            container.innerHTML = '<div class="loading">No NFTs found in this wallet</div>';
        }
    } catch (error) {
        container.innerHTML = `<div class="error">Error loading wallet NFTs: ${error.message}</div>`;
    }
}

// Load a single NFT by ID
async function loadSingleNFT() {
    const tokenId = document.getElementById('tokenId').value;
    if (!tokenId || tokenId < 1) {
        alert('Please enter a valid token ID');
        return;
    }
    
    const container = document.getElementById('nftContainer');
    container.innerHTML = '<div class="loading">Loading NFT...</div>';
    
    try {
        const nft = await loadNFTData(parseInt(tokenId));
        container.innerHTML = '';
        
        if (nft) {
            container.appendChild(createNFTCard(nft));
        } else {
            container.innerHTML = '<div class="error">NFT not found</div>';
        }
    } catch (error) {
        container.innerHTML = `<div class="error">Error loading NFT: ${error.message}</div>`;
    }
}

// Load data for a single NFT
async function loadNFTData(tokenId) {
    try {
        // Get owner
        const owner = await nftContract.ownerOf(tokenId);
        
        // Get attributes
        const attrs = await nftContract.tokenAttributes(tokenId);
        
        // Get SVG
        const svg = await nftContract.getSVG(tokenId);
        
        return {
            tokenId,
            owner,
            species: attrs.species,
            background: attrs.background,
            item: attrs.item,
            effect: attrs.effect,
            svg
        };
    } catch (error) {
        console.error(`Error loading NFT #${tokenId}:`, error);
        return null;
    }
}

// Create NFT card element
function createNFTCard(nft) {
    const card = document.createElement('div');
    card.className = 'nft-card';
    
    card.innerHTML = `
        <div class="nft-image">
            ${nft.svg}
        </div>
        <div class="nft-info">
            <h3>Tragedy #${nft.tokenId}</h3>
            <p>Owner: ${nft.owner.slice(0, 6)}...${nft.owner.slice(-4)}</p>
            <div style="margin-top: 10px;">
                <span class="trait">🐺 ${SPECIES_NAMES[nft.species]}</span>
                <span class="trait">🌙 ${BACKGROUND_NAMES[nft.background]}</span>
                <span class="trait">⚔️ ${ITEM_NAMES[nft.item]}</span>
                <span class="trait">✨ ${EFFECT_NAMES[nft.effect]}</span>
            </div>
        </div>
    `;
    
    return card;
}

// Add click to copy address functionality
document.addEventListener('click', (e) => {
    if (e.target.classList.contains('nft-info')) {
        const p = e.target.querySelector('p');
        if (p && p.textContent.includes('Owner:')) {
            const fullAddress = p.textContent.replace('Owner: ', '').replace('...', '');
            navigator.clipboard.writeText(fullAddress);
            
            // Show feedback
            const original = p.textContent;
            p.textContent = 'Copied!';
            setTimeout(() => {
                p.textContent = original;
            }, 1000);
        }
    }
});