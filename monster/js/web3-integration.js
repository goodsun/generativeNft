// MetaMask integration for The Mythical Cursed-Nightmare NFT minting
// Using ethers.js v6 for Web3 interaction

// Base Chain Configuration
const BASE_CHAIN_CONFIG = {
    chainId: '0x2105', // 8453 in hex
    chainName: 'Base',
    rpcUrls: ['https://mainnet.base.org'],
    nativeCurrency: {
        name: 'Ethereum',
        symbol: 'ETH',
        decimals: 18
    },
    blockExplorerUrls: ['https://basescan.org']
};

// Base Testnet (Sepolia) Configuration for testing
const BASE_TESTNET_CONFIG = {
    chainId: '0x14a34', // 84532 in hex
    chainName: 'Base Sepolia',
    rpcUrls: ['https://sepolia.base.org'],
    nativeCurrency: {
        name: 'Ethereum',
        symbol: 'ETH',
        decimals: 18
    },
    blockExplorerUrls: ['https://sepolia.basescan.org']
};

// Custom Testnet Configuration
const CUSTOM_TESTNET_CONFIG = {
    chainId: '0x52d1', // 21201 in hex
    chainName: 'Bon Soleil Testnet',
    rpcUrls: ['https://dev2.bon-soleil.com/rpc'],
    nativeCurrency: {
        name: 'Ethereum',
        symbol: 'ETH',
        decimals: 18
    },
    blockExplorerUrls: ['https://dev2.bon-soleil.com/explorer'] // エクスプローラーがあれば
};

// Contract configuration (will be updated with actual contract address)
// Different contracts for different networks
const CONTRACT_CONFIG = {
    // Network-specific contract addresses
    addresses: {
        8453: '0x0000000000000000000000000000000000000000',  // Base Mainnet
        84532: '0x0000000000000000000000000000000000000000', // Base Sepolia
        21201: '0xb0C8bCef9bBEd995b18E0fe6cB7029cB7c90E796'  // Bon Soleil Testnet - BankedNFT Contract
    },
    abi: [
        // BankedNFT ABI for minting
        "function mint() public payable returns (uint256)",
        "function mintFee() view returns (uint256)",
        "function totalSupply() view returns (uint256)",
        "function balanceOf(address owner) view returns (uint256)",
        "function ownerOf(uint256 tokenId) view returns (address)",
        "function tokenURI(uint256 tokenId) view returns (string)",
        "function maxSupply() view returns (uint256)",
        "function name() view returns (string)",
        "function symbol() view returns (string)",
        "event NFTMinted(address indexed to, uint256 indexed tokenId, address indexed creator, string metadataURI)",
        "event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)"
    ]
};

class Web3Integration {
    constructor() {
        this.provider = null;
        this.signer = null;
        this.contract = null;
        this.currentAccount = null;
        this.isTestnet = true; // Default to testnet for development
        this.useCustomTestnet = true; // Use Bon Soleil testnet
    }

    // Initialize Web3 connection
    async init() {
        if (typeof window.ethereum === 'undefined') {
            throw new Error('MetaMask is not installed! Please install MetaMask to mint NFTs.');
        }

        try {
            // Request account access
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            
            // Create provider using ethers.js v6
            this.provider = new ethers.BrowserProvider(window.ethereum);
            this.signer = await this.provider.getSigner();
            this.currentAccount = await this.signer.getAddress();
            
            // Setup event listeners
            this.setupEventListeners();
            
            // Get current chain ID and auto-detect network
            await this.detectAndSwitchNetwork();
            
            // Get current chain ID for contract initialization
            const currentChainId = await window.ethereum.request({ method: 'eth_chainId' });
            const currentChainIdDecimal = parseInt(currentChainId, 16);
            
            // Initialize contract with network-specific address
            const contractAddress = CONTRACT_CONFIG.addresses[currentChainIdDecimal];
            console.log(`Attempting to initialize contract for chain ${currentChainIdDecimal}`);
            console.log(`Contract address from config: ${contractAddress}`);
            
            if (contractAddress && contractAddress !== '0x0000000000000000000000000000000000000000') {
                try {
                    this.contract = new ethers.Contract(
                        contractAddress,
                        CONTRACT_CONFIG.abi,
                        this.signer
                    );
                    console.log(`Contract initialized successfully on chain ${currentChainIdDecimal} at ${contractAddress}`);
                    
                    // Test contract connection by calling a view function
                    try {
                        const totalSupply = await this.contract.totalSupply();
                        console.log(`Contract test successful - totalSupply: ${totalSupply}`);
                    } catch (testError) {
                        console.warn('Contract test failed (totalSupply):', testError);
                    }
                } catch (initError) {
                    console.error('Failed to initialize contract:', initError);
                    this.contract = null;
                }
            } else {
                console.warn('No valid contract address found for chain:', currentChainIdDecimal);
            }
            
            return this.currentAccount;
        } catch (error) {
            console.error('Failed to initialize Web3:', error);
            throw error;
        }
    }

    // Setup MetaMask event listeners
    setupEventListeners() {
        window.ethereum.on('accountsChanged', (accounts) => {
            if (accounts.length === 0) {
                console.log('MetaMask locked');
                this.currentAccount = null;
                this.handleDisconnect();
            } else {
                this.currentAccount = accounts[0];
                this.handleAccountChange(accounts[0]);
            }
        });

        window.ethereum.on('chainChanged', (chainId) => {
            // Reload page on chain change as recommended by MetaMask
            window.location.reload();
        });
    }

    // Detect current network and switch if needed
    async detectAndSwitchNetwork() {
        const currentChainId = await window.ethereum.request({ method: 'eth_chainId' });
        const currentChainIdDecimal = parseInt(currentChainId, 16);
        
        console.log('Current Chain ID:', currentChainIdDecimal);
        
        // Check if already on a supported network
        const supportedNetworks = {
            8453: BASE_CHAIN_CONFIG,        // Base Mainnet
            84532: BASE_TESTNET_CONFIG,     // Base Sepolia
            21201: CUSTOM_TESTNET_CONFIG    // Bon Soleil
        };
        
        if (supportedNetworks[currentChainIdDecimal]) {
            console.log('Already on supported network:', supportedNetworks[currentChainIdDecimal].chainName);
            return; // Already on correct network
        }
        
        // Not on supported network, prompt to switch
        // Default to Bon Soleil testnet for development
        await this.switchToNetwork(CUSTOM_TESTNET_CONFIG);
    }
    
    // Switch to specific network
    async switchToNetwork(targetConfig) {
        try {
            await window.ethereum.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId: targetConfig.chainId }],
            });
        } catch (switchError) {
            // This error code indicates that the chain has not been added to MetaMask
            if (switchError.code === 4902) {
                try {
                    await window.ethereum.request({
                        method: 'wallet_addEthereumChain',
                        params: [targetConfig],
                    });
                } catch (addError) {
                    throw new Error(`Failed to add ${targetConfig.chainName} to MetaMask`);
                }
            } else {
                throw switchError;
            }
        }
    }

    // Connect wallet
    async connectWallet() {
        try {
            const account = await this.init();
            return account;
        } catch (error) {
            console.error('Failed to connect wallet:', error);
            throw error;
        }
    }

    // Disconnect wallet
    disconnectWallet() {
        this.currentAccount = null;
        this.provider = null;
        this.signer = null;
        this.contract = null;
        this.handleDisconnect();
    }

    // Get current account
    getCurrentAccount() {
        return this.currentAccount;
    }

    // Check if wallet is connected
    isConnected() {
        return this.currentAccount !== null;
    }
    
    // Get contract address for current network
    getContractAddress() {
        if (this.contract) {
            return this.contract.target || this.contract.address;
        }
        // If no contract initialized, try to get from config
        if (window.ethereum) {
            const chainId = parseInt(window.ethereum.chainId, 16);
            return CONTRACT_CONFIG.addresses[chainId];
        }
        return null;
    }

    // Get account balance
    async getBalance() {
        if (!this.provider || !this.currentAccount) {
            throw new Error('Wallet not connected');
        }
        
        const balance = await this.provider.getBalance(this.currentAccount);
        return ethers.formatEther(balance);
    }

    // Get NFT price from contract
    async getNFTPrice() {
        if (!this.contract) {
            console.warn('getNFTPrice: Contract not initialized');
            throw new Error('Contract not initialized');
        }
        
        try {
            console.log('Calling mintFee() on contract:', this.contract.target || this.contract.address);
            const mintFee = await this.contract.mintFee();
            console.log('mintFee raw value:', mintFee.toString());
            const formattedFee = ethers.formatEther(mintFee);
            console.log('mintFee formatted:', formattedFee);
            return formattedFee;
        } catch (error) {
            console.error('Failed to get NFT price:', error);
            console.error('Error details:', error.message);
            // Default price if contract doesn't have mintFee function
            console.log('Returning default price: 0.005 ETH');
            return '0.005'; // 0.005 ETH default
        }
    }

    // Get total supply
    async getTotalSupply() {
        if (!this.contract) {
            console.warn('getTotalSupply: Contract not initialized');
            throw new Error('Contract not initialized');
        }
        
        try {
            console.log('Calling totalSupply() on contract:', this.contract.target || this.contract.address);
            const supply = await this.contract.totalSupply();
            console.log('totalSupply raw value:', supply);
            const supplyString = supply.toString();
            console.log('totalSupply formatted:', supplyString);
            return supplyString;
        } catch (error) {
            console.error('Failed to get total supply:', error);
            console.error('Error details:', error.message);
            throw error;
        }
    }

    // Get max supply
    async getMaxSupply() {
        if (!this.contract) {
            throw new Error('Contract not initialized');
        }
        
        try {
            const maxSupply = await this.contract.maxSupply();
            return maxSupply.toString();
        } catch (error) {
            // If maxSupply function doesn't exist, return a default
            return '10000';
        }
    }

    // Get contract name
    async getContractName() {
        if (!this.contract) {
            console.warn('getContractName: Contract not initialized');
            throw new Error('Contract not initialized');
        }
        
        try {
            console.log('Calling name() on contract:', this.contract.target || this.contract.address);
            const contractName = await this.contract.name();
            console.log('Contract name:', contractName);
            return contractName;
        } catch (error) {
            console.error('Failed to get contract name:', error);
            console.error('Error details:', error.message);
            return 'Unknown Collection';
        }
    }

    // Get contract symbol
    async getContractSymbol() {
        if (!this.contract) {
            console.warn('getContractSymbol: Contract not initialized');
            throw new Error('Contract not initialized');
        }
        
        try {
            console.log('Calling symbol() on contract:', this.contract.target || this.contract.address);
            const contractSymbol = await this.contract.symbol();
            console.log('Contract symbol:', contractSymbol);
            return contractSymbol;
        } catch (error) {
            console.error('Failed to get contract symbol:', error);
            console.error('Error details:', error.message);
            return 'UNKNOWN';
        }
    }

    // Mint NFT
    async mintNFT() {
        if (!this.contract) {
            throw new Error('Contract not initialized');
        }
        
        if (!this.currentAccount) {
            throw new Error('Wallet not connected');
        }
        
        try {
            
            // Get the mint fee from contract
            const mintFee = await this.contract.mintFee();
            
            // Call mint function with payment
            const tx = await this.contract.mint({ 
                value: mintFee 
            });
            
            // Wait for transaction confirmation
            const receipt = await tx.wait();
            
            // Extract token ID from NFTMinted event
            const mintEvent = receipt.logs.find(log => {
                try {
                    const parsed = this.contract.interface.parseLog(log);
                    return parsed.name === 'NFTMinted';
                } catch {
                    return false;
                }
            });
            
            let tokenId = null;
            if (mintEvent) {
                const parsed = this.contract.interface.parseLog(mintEvent);
                tokenId = parsed.args.tokenId.toString();
            }
            
            return {
                success: true,
                transactionHash: receipt.hash,
                tokenId: tokenId,
                blockNumber: receipt.blockNumber
            };
        } catch (error) {
            console.error('Minting failed:', error);
            throw error;
        }
    }

    // Check if user owns any NFTs
    async checkOwnership() {
        if (!this.contract || !this.currentAccount) {
            return 0;
        }
        
        try {
            const balance = await this.contract.balanceOf(this.currentAccount);
            return balance.toString();
        } catch (error) {
            console.error('Failed to check ownership:', error);
            return 0;
        }
    }

    // Format address for display
    formatAddress(address) {
        if (!address) return '';
        return `${address.slice(0, 6)}...${address.slice(-4)}`;
    }

    // Event handlers (to be implemented by UI)
    handleAccountChange(account) {
        console.log('Account changed:', account);
        // Update UI with new account
        if (window.updateWalletUI) {
            window.updateWalletUI(account);
        }
    }

    handleDisconnect() {
        console.log('Wallet disconnected');
        // Update UI to disconnected state
        if (window.updateWalletUI) {
            window.updateWalletUI(null);
        }
    }
}

// Create global instance
window.web3Integration = new Web3Integration();

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Web3Integration;
}