# Tragedy NFT V5 - Contract Addresses

## Deployment Date: 2025-08-06
## Network: Bon-Soleil Testnet (Chain ID: 21201)

### Main Contracts

| Contract | Address |
|----------|---------|
| **BankedNFT** | `0x96a960FA0c267dc9fa64f61C849d6D0e88801d34` |
| **MetadataV5** | `0xd5a61216F7E97798bE5Dbc9Fd8D72C8Fd468b705` |
| **ComposerV5** | `0x078b4d91BA92177c2a01d4A84aE78e24b603d10E` |

### Bank Contracts (V3 - Combined)

| Contract | Address |
|----------|---------|
| **MonsterBankV3** | `0xc5dC1c5F923edA5eBe4765fE5A2E10Ae03D8b123` |
| **ItemBankV3** | `0x7485194fCeB774f1eb5Dc12CF852ED0541FcfF22` |
| **BackgroundBank** | `0xf368EB1eD47121B445F92E0Cc49a3F7Ceb96E64C` |
| **EffectBank** | `0xFc0F05BfC0cd5e7e066b78879c32Efa518468dce` |

### Individual Bank Contracts (Referenced by V3)

| Contract | Address |
|----------|---------|
| **MonsterBank1** | `0xc6E63bC65201BeBEa01a975e02f6c5C2B8f68cc9` |
| **MonsterBank2** | `0xBfd8838C25608c7DF82DaC5B95be004a8a7D3114` |
| **ItemBank1** | `0xC449009B332c68b6Bf688Dd15b39cA4B7521c3e1` |
| **ItemBank2** | `0x76a5F990bCe8946b380DB5E0ae2CCD26d0472B01` |

## Contract Parameters

### BankedNFT
- **Name**: Tragedy NFT
- **Symbol**: TRAGEDY
- **Max Supply**: 10,000
- **Mint Fee**: 0.01 ETH
- **Royalty Rate**: 2.5% (250 basis points)

## How to Use in Remix

1. Open Remix IDE (https://remix.ethereum.org)
2. Copy the interface files from this directory
3. Compile the interfaces
4. In "Deploy & Run Transactions" tab:
   - Set Environment to "Injected Provider" (MetaMask)
   - Make sure you're connected to Bon-Soleil Testnet
   - Load contract at address using the addresses above