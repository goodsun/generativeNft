# Remix Interface Guide

This directory contains interface files for interacting with the deployed Tragedy NFT contracts using Remix IDE.

## Contract Systems

### 1. Legacy System (TragedyMythNFT)
The original implementation with fixed metadata generation.

### 2. BankedNFT System (TragedyBankedNFT)
The new modular implementation with MetadataBank architecture, enabling flexible metadata management and additional features like soul-bound tokens.

## Quick Start

1. **Open Remix IDE**: https://remix.ethereum.org

2. **Connect to Bon-Soleil Testnet**:
   - MetaMask -> Add Network
   - Network Name: Bon-Soleil Testnet
   - RPC URL: https://dev2.bon-soleil.com/rpc
   - Chain ID: 21201
   - Currency Symbol: ETH

3. **Import Interface Files**:
   - Create a new folder in Remix
   - Copy all `.sol` files from this directory
   - Compile with Solidity 0.8.20

4. **Connect to Deployed Contracts**:
   - Go to "Deploy & Run Transactions" tab
   - Select "Injected Provider - MetaMask"
   - Choose the interface you want to use
   - Click "At Address" and paste the contract address from `CONTRACT_ADDRESSES.md`

## Example Usage

### Legacy System - Mint with specific parameters
```solidity
// Using ITragedyMythNFT at 0xCd3272E5016Ac392c7dA55b7AeA2e0714571cA4F
// Parameters: species, background, item, effect (all 0-9)
mint(1, 4, 1, 1) // Goblin + Venom + Sword + Mindblast
```

### BankedNFT System - Mint with MetadataBank
```solidity
// Using ITragedyBankedNFT at 0x930Fc003DD8989E8d64b9Bba7673180C369178C5
// Send 0.01 ETH with the transaction
mint() // Mints regular NFT with metadata from bank
mintSoulBound() // Mints non-transferable NFT
```

### View NFT Metadata
```solidity
// Get tokenURI for token #1
tokenURI(1)
```

### Compose SVG (without minting)
```solidity
// Using IArweaveTragedyComposerV2 at 0x0c687b850B572845EF88903d78a804B3f46E611b
composeSVG(0, 0, 0, 0) // Werewolf + Bloodmoon + Crown + Seizure
```

### Check Filter Parameters
```solidity
// Get filter params for background ID 4 (Venom)
filterParams(4)
// Returns: hueRotate=120, saturate=180, brightness=110
```

## Contract Hierarchy

### Legacy System
```
TragedyMythNFT (ERC721)
    └── TragedyMetadata
            └── ArweaveTragedyComposerV2
                    ├── ArweaveMonsterBank
                    ├── ArweaveItemBank
                    ├── ArweaveBackgroundBank
                    └── ArweaveEffectBank
```

### BankedNFT System
```
TragedyBankedNFT (ERC721 + ERC2981)
    └── TragedyMetadataV2 (IMetadataBank)
            └── ArweaveTragedyComposerV2
                    ├── ArweaveMonsterBank
                    ├── ArweaveItemBank
                    ├── ArweaveBackgroundBank
                    └── ArweaveEffectBank
```

## Parameter Reference

### Species (0-9)
0. Werewolf
1. Goblin
2. Frankenstein
3. Demon
4. Dragon
5. Zombie
6. Vampire
7. Mummy
8. Succubus
9. Skeleton

### Backgrounds (0-9)
0. Bloodmoon
1. Abyss
2. Decay
3. Corruption
4. Venom
5. Void
6. Inferno
7. Frost
8. Ragnarok
9. Shadow

### Items (0-9)
0. Crown
1. Sword
2. Shield
3. Poison
4. Torch
5. Wine
6. Scythe
7. Staff
8. Shoulder
9. Amulet

### Effects (0-9)
0. Seizure
1. Mindblast
2. Confusion
3. Meteor
4. Bats
5. Poisoning
6. Lightning
7. Blizzard
8. Burning
9. Brainwash

## BankedNFT Features

### Owner Functions
```solidity
// Configure collection settings
config("New Name", "NEW", 0.02 ether, 750) // name, symbol, mintFee, royalty(7.5%)

// Set or update MetadataBank
setMetadataBank(0x7537eBe80Ef1D4a57DbB22B6bE6B9C9a4dAff4b2)

// Airdrop to specific address
airdrop(0x...) // Owner can mint without payment

// Withdraw contract balance
withdraw()
```

### View Functions
```solidity
// Check minting status
canMint() // returns true if supply not exhausted
remainingSupply() // returns tokens left to mint
isSoulBound(tokenId) // check if token is non-transferable
```

### Key Differences
- **Legacy System**: Parameters chosen at mint time
- **BankedNFT System**: Metadata assigned from bank pool, supports soul-bound tokens, includes royalties