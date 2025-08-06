# Tragedy NFT Contract Addresses

## Bon-Soleil Testnet Deployment

### Deployment Information
- **Network**: Bon-Soleil Testnet
- **Chain ID**: 21201
- **RPC URL**: https://dev2.bon-soleil.com/rpc
- **Initial Deployment**: 2025-01-02
- **BankedNFT Deployment**: 2025-08-06

### Contract Addresses

#### Core Infrastructure
| Contract | Address | Description |
|----------|---------|-------------|
| Base64 Library | `0x552B3F94727AcdAfbD7564682F2EA8F4275D1267` | Base64 encoding library |

#### Bank Contracts (Data Storage)
| Contract | Address | Description |
|----------|---------|-------------|
| ArweaveMonsterBank | `0xa07edc0A9c26B34dc77a7125ad3441d1DdE3483a` | On-chain monster SVG storage |
| ArweaveItemBank | `0x0D72B5DCFc97b7fE8c15cE1c7c68A1c0dDC446bd` | On-chain item SVG storage |
| ArweaveBackgroundBank | `0xC2d0142F4748D3373BcA7BE31B1AD6bB676b66df` | Arweave background URL management |
| ArweaveEffectBank | `0xBD3E0Cc596a35e6cECD4C95e41DFf572Af2eb4db` | Arweave effect URL management |

#### Composition & Metadata Contracts
| Contract | Address | Description |
|----------|---------|-------------|
| ArweaveTragedyComposerV2 | `0x0c687b850B572845EF88903d78a804B3f46E611b` | SVG composition engine |
| TragedyMetadata | `0x18b613006C7921d6a4b9272c3ECCF5057FD395f6` | Legacy metadata generation |
| TragedyMetadataV2 | `0x7537eBe80Ef1D4a57DbB22B6bE6B9C9a4dAff4b2` | MetadataBank implementation |

#### NFT Contracts
| Contract | Address | Description |
|----------|---------|-------------|
| TragedyMythNFT | `0xCd3272E5016Ac392c7dA55b7AeA2e0714571cA4F` | Legacy NFT contract (ERC721) |
| TragedyBankedNFT | `0x930Fc003DD8989E8d64b9Bba7673180C369178C5` | BankedNFT implementation |

### Quick Access for Remix

To interact with these contracts in Remix:

1. Copy the interface files from this directory
2. Go to Remix IDE
3. Deploy -> "At Address" with the addresses above
4. Make sure you're connected to Bon-Soleil testnet

### Current Status
- TragedyMythNFT: 5 NFTs minted
- TragedyBankedNFT: 1 NFT minted (test mint)
- All systems operational
- Arweave URLs configured and working

### BankedNFT System Details
- **Max Supply**: 10,000
- **Mint Fee**: 0.01 ETH
- **Royalty Rate**: 5%
- **Metadata Count**: 10,000 unique combinations