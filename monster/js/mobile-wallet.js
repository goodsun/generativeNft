// Mobile Wallet Connection Support for The Mythical Cursed-Nightmare
// Supports MetaMask Mobile App via deep linking and WalletConnect

class MobileWalletConnector {
    constructor() {
        this.isMobile = this.checkIfMobile();
        this.isMetaMaskBrowser = this.checkMetaMaskBrowser();
        this.provider = null;
    }

    // Check if running on mobile device
    checkIfMobile() {
        return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    }

    // Check if running inside MetaMask mobile browser
    checkMetaMaskBrowser() {
        return typeof window.ethereum !== 'undefined' && window.ethereum.isMetaMask;
    }

    // Initialize connection based on environment
    async initializeConnection() {
        // If desktop or already in MetaMask browser
        if (!this.isMobile || this.isMetaMaskBrowser) {
            return this.connectDirectly();
        }

        // If mobile but not in MetaMask browser
        return this.connectMobile();
    }

    // Direct connection (desktop or MetaMask browser)
    async connectDirectly() {
        if (typeof window.ethereum === 'undefined') {
            throw new Error('MetaMask is not installed');
        }

        try {
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            return window.ethereum;
        } catch (error) {
            throw error;
        }
    }

    // Mobile connection options
    async connectMobile() {
        // Check if we're in MetaMask browser
        if (this.isMetaMaskBrowser) {
            // We're in MetaMask browser, try connecting
            return this.connectDirectly();
        } else {
            // Just copy URL and show instructions
            this.showMobileInstructions();
            throw new Error('Please use MetaMask browser');
        }
    }

    // Show mobile connection modal
    showMobileConnectionModal(resolve, reject) {
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.95);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 99999;
            animation: fadeIn 0.3s;
        `;

        const modalContent = document.createElement('div');
        modalContent.style.cssText = `
            background: linear-gradient(180deg, #1a0a2a 0%, #0a0a0a 100%);
            border: 2px solid #9b4dff;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 0 50px rgba(155, 77, 255, 0.5);
        `;

        modalContent.innerHTML = `
            <h2 style="color: #ff4d4d; font-size: 1.8em; margin-bottom: 20px;">
                📱 Mobile Device Detected
            </h2>
            <p style="color: #e9d5ff; margin-bottom: 30px; line-height: 1.5;">
                To summon nightmares on mobile, you need to open this page in the MetaMask app browser.
            </p>
            
            <button id="metamaskMobileBtn" style="
                width: 100%;
                background: linear-gradient(45deg, #f6851b, #e2761b);
                color: white;
                border: none;
                padding: 25px;
                font-size: 1.3em;
                border-radius: 15px;
                cursor: pointer;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                font-weight: bold;
                box-shadow: 0 5px 20px rgba(246, 133, 27, 0.4);
                transition: all 0.3s;
            " onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 7px 25px rgba(246, 133, 27, 0.5)'"
               onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 5px 20px rgba(246, 133, 27, 0.4)'">
                🦊 Open in MetaMask App
            </button>
            
            <button id="cancelBtn" style="
                background: transparent;
                color: #666;
                border: none;
                padding: 10px;
                cursor: pointer;
                text-decoration: underline;
            ">
                Cancel
            </button>
        `;

        modal.appendChild(modalContent);
        document.body.appendChild(modal);

        // MetaMask Mobile button
        document.getElementById('metamaskMobileBtn').onclick = () => {
            this.openInMetaMaskApp();
            modal.remove();
            reject(new Error('Redirecting to MetaMask app'));
        };



        // Cancel button
        document.getElementById('cancelBtn').onclick = () => {
            modal.remove();
            reject(new Error('User cancelled connection'));
        };
    }

    // Show mobile instructions
    showMobileInstructions() {
        const currentUrl = window.location.href;
        
        // Copy URL to clipboard
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(currentUrl).then(() => {
                console.log('URL copied to clipboard:', currentUrl);
            }).catch(err => {
                console.error('Failed to copy URL:', err);
            });
        }
        
        // Show instructions modal
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.95);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 99999;
            animation: fadeIn 0.3s;
        `;
        
        const modalContent = document.createElement('div');
        modalContent.style.cssText = `
            background: linear-gradient(180deg, #1a0a2a 0%, #0a0a0a 100%);
            border: 2px solid #9b4dff;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            max-width: 350px;
            box-shadow: 0 0 50px rgba(155, 77, 255, 0.5);
        `;
        
        modalContent.innerHTML = `
            <h2 style="color: #ff4d4d; font-size: 1.8em; margin-bottom: 20px;">
                📱 Use MetaMask Browser
            </h2>
            <div style="background: #4dff4d; color: #000; padding: 10px; border-radius: 10px; margin-bottom: 20px; font-weight: bold;">
                ✓ URL Copied to Clipboard!
            </div>
            <p style="color: #e9d5ff; line-height: 1.8; margin-bottom: 20px; text-align: left;">
                1. Open <strong>MetaMask app</strong><br>
                2. Tap <strong>Browser</strong> tab at bottom<br>
                3. Tap the URL bar<br>
                4. <strong>Paste</strong> and press <strong>Go</strong>
            </p>
            <button onclick="window.open('https://metamask.io/download/', '_blank')" style="
                width: 100%;
                background: linear-gradient(45deg, #f6851b, #e2761b);
                color: white;
                border: none;
                padding: 15px;
                font-size: 1.1em;
                border-radius: 50px;
                cursor: pointer;
                margin-bottom: 10px;
                font-weight: bold;
            ">Open MetaMask Download</button>
            <button onclick="this.parentElement.parentElement.remove()" style="
                background: transparent;
                color: #666;
                border: none;
                padding: 10px;
                cursor: pointer;
                text-decoration: underline;
            ">Close</button>
        `;
        
        modal.appendChild(modalContent);
        document.body.appendChild(modal);
    }

    // Initialize WalletConnect
    async initWalletConnect() {
        // This would require WalletConnect SDK
        // For now, show a placeholder message
        throw new Error('WalletConnect integration coming soon');
    }

    // Check if iOS
    isIOS() {
        return /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
    }

    // Check if Android
    isAndroid() {
        return /Android/.test(navigator.userAgent);
    }

    // Generate QR code for desktop wallet connection
    generateQRCode(uri) {
        // This would generate a QR code for WalletConnect
        // Requires QR code library
        console.log('QR Code URI:', uri);
    }
}

// Initialize mobile wallet support
window.mobileWallet = new MobileWalletConnector();

// Don't override on mobile - let user use MetaMask browser directly

// Add styles for animations if not already present
if (!document.querySelector('#mobileWalletStyles')) {
    const style = document.createElement('style');
    style.id = 'mobileWalletStyles';
    style.textContent = `
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; }
        }
    `;
    document.head.appendChild(style);
}