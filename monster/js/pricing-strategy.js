// Dynamic Pricing Strategy for The Mythical Cursed-Nightmare
// Different prices based on access method and wallet holdings

class PricingStrategy {
    constructor() {
        // Base price in ETH
        this.basePrice = 0.005;
        
        // Discount configurations
        this.discounts = {
            watchword: 0.4,        // 40% off for secret watchword users
            specialWallet: 0.5,    // 50% off for special wallet holders
            earlyBird: 0.3,        // 30% off for first 1000 mints
            multiMint: 0.1,        // 10% off for 5+ mints
            community: 0.2         // 20% off for Discord/community members
        };
        
        // Special wallet collections that get discounts
        this.specialCollections = [
            '0x...', // Add specific NFT contract addresses here
            // Examples:
            // '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D', // BAYC
            // '0x60E4d786628Fea6478F785A6d7e704777c86a7c6', // MAYC
        ];
    }
    
    // Check if wallet holds special NFTs
    async checkSpecialWallet(walletAddress) {
        try {
            // Check each special collection
            for (const contractAddress of this.specialCollections) {
                const contract = new ethers.Contract(
                    contractAddress,
                    ['function balanceOf(address owner) view returns (uint256)'],
                    window.web3Integration.provider
                );
                
                const balance = await contract.balanceOf(walletAddress);
                if (balance > 0) {
                    return {
                        hasSpecial: true,
                        collection: contractAddress
                    };
                }
            }
        } catch (error) {
            console.error('Error checking special wallet:', error);
        }
        
        return { hasSpecial: false };
    }
    
    // Check if using watchword access
    checkWatchwordAccess() {
        const urlParams = new URLSearchParams(window.location.search);
        const watchword = urlParams.get('watchword');
        
        // Check for the secret watchword
        function customDecrypt(code) {
            return code.split('-').map(n => String.fromCharCode(n - 1)).join('');
        }
        const secretWord = customDecrypt('116-112-118-109-99-112-118-111-101');
        
        return watchword === secretWord;
    }
    
    // Check early bird eligibility
    async checkEarlyBird() {
        try {
            const totalSupply = await window.web3Integration.getTotalSupply();
            return parseInt(totalSupply) < 1000; // First 1000 get discount
        } catch (error) {
            console.error('Error checking early bird:', error);
            return false;
        }
    }
    
    // Calculate final price based on all discounts
    async calculatePrice(walletAddress, quantity = 1) {
        let finalPrice = this.basePrice;
        let appliedDiscounts = [];
        
        // Check watchword discount
        if (this.checkWatchwordAccess()) {
            finalPrice *= (1 - this.discounts.watchword);
            appliedDiscounts.push({
                type: 'Soulbound Access',
                discount: this.discounts.watchword * 100 + '%'
            });
        }
        
        // Check special wallet discount
        if (walletAddress) {
            const specialWallet = await this.checkSpecialWallet(walletAddress);
            if (specialWallet.hasSpecial) {
                finalPrice *= (1 - this.discounts.specialWallet);
                appliedDiscounts.push({
                    type: 'Special Holder',
                    discount: this.discounts.specialWallet * 100 + '%'
                });
            }
        }
        
        // Check early bird discount
        const isEarlyBird = await this.checkEarlyBird();
        if (isEarlyBird && appliedDiscounts.length === 0) { // Only if no other discounts
            finalPrice *= (1 - this.discounts.earlyBird);
            appliedDiscounts.push({
                type: 'Early Bird',
                discount: this.discounts.earlyBird * 100 + '%'
            });
        }
        
        // Multi-mint discount
        if (quantity >= 5) {
            finalPrice *= (1 - this.discounts.multiMint);
            appliedDiscounts.push({
                type: 'Bulk Purchase',
                discount: this.discounts.multiMint * 100 + '%'
            });
        }
        
        return {
            basePrice: this.basePrice,
            finalPrice: finalPrice,
            totalPrice: finalPrice * quantity,
            quantity: quantity,
            discounts: appliedDiscounts
        };
    }
    
    // Format price display with discount info
    formatPriceDisplay(priceInfo) {
        let display = `<div style="text-align: left;">`;
        
        if (priceInfo.discounts.length > 0) {
            display += `<div style="text-decoration: line-through; color: #888; font-size: 0.9em;">
                Regular: ${priceInfo.basePrice} ETH
            </div>`;
            
            priceInfo.discounts.forEach(discount => {
                display += `<div style="color: #4dff4d; font-size: 0.8em;">
                    ✓ ${discount.type}: -${discount.discount}
                </div>`;
            });
            
            display += `<div style="color: #ffd700; font-size: 1.2em; margin-top: 5px;">
                <strong>Your Price: ${priceInfo.finalPrice.toFixed(4)} ETH</strong>
            </div>`;
        } else {
            display += `<div style="font-size: 1.2em;">
                Price: ${priceInfo.finalPrice.toFixed(4)} ETH
            </div>`;
        }
        
        if (priceInfo.quantity > 1) {
            display += `<div style="color: #b792ff; margin-top: 5px;">
                Total (${priceInfo.quantity}x): ${priceInfo.totalPrice.toFixed(4)} ETH
            </div>`;
        }
        
        display += `</div>`;
        
        return display;
    }
    
    // Show special offer banner
    showSpecialOffer(type) {
        const banners = {
            watchword: {
                text: '🔓 SOULBOUND DISCOUNT ACTIVE - 40% OFF!',
                color: '#9b4dff'
            },
            specialWallet: {
                text: '👑 VIP HOLDER DISCOUNT - 50% OFF!',
                color: '#ffd700'
            },
            earlyBird: {
                text: '🐦 EARLY BIRD SPECIAL - 30% OFF!',
                color: '#4dff4d'
            }
        };
        
        const banner = banners[type];
        if (banner) {
            return `<div style="
                background: linear-gradient(45deg, ${banner.color}, transparent);
                padding: 10px;
                border-radius: 10px;
                margin-bottom: 15px;
                text-align: center;
                font-weight: bold;
                animation: pulse 2s infinite;
            ">
                ${banner.text}
            </div>`;
        }
        
        return '';
    }
}

// Create global instance
window.pricingStrategy = new PricingStrategy();

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = PricingStrategy;
}