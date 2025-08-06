// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArweaveItemBank
 * @notice Stores item SVG data on-chain for the hybrid Arweave approach
 * @dev All item SVGs are stored as simple strings, will be base64 encoded by composer
 */
contract ArweaveItemBank {
    mapping(uint8 => string) private itemSVGs;
    
    string[10] public itemNames = [
        "Crown",
        "Sword",
        "Shield",
        "Poison",
        "Torch",
        "Wine",
        "Scythe",
        "Staff",
        "Shoulder",
        "Amulet"
    ];
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _initializeItems();
    }
    
    function _initializeItems() private {
        // Crown
        itemSVGs[0] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#FFD700"><path d="M7 8h10v2H7zm-1 2h12v1H6zm1 1h10v1H7zm3 1h4v1h-4z"/></g><g fill="#FF0000"><path d="M9 8h1v1H9zm5 0h1v1h-1z"/></g><g fill="#0000FF"><path d="M12 8h1v1h-1z"/></g></svg>';
        
        // Sword
        itemSVGs[1] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#C0C0C0"><path d="M11 4h2v12h-2z"/></g><g fill="#8B4513"><path d="M10 16h4v2h-4z"/></g><g fill="#FFD700"><path d="M9 15h6v1H9z"/></g><g fill="#E0E0E0"><path d="M11 4h1v12h-1z"/></g></svg>';
        
        // Shield
        itemSVGs[2] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#4682B4"><path d="M8 6h8v1H8zm-1 1h10v1H7zm-1 1h12v2H6zm0 2h12v2H6zm0 2h12v2H6zm1 2h10v2H7zm1 2h8v1H8zm1 1h6v1H9z"/></g><g fill="#FFD700"><path d="M11 9h2v4h-2z"/></g><g fill="#1E90FF"><path d="M7 8h1v1H7zm9 0h1v1h-1z"/></g></svg>';
        
        // Poison
        itemSVGs[3] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#4B0082"><path d="M10 6h4v1h-4zm-1 1h6v1H9zm-1 1h8v6H8zm1 6h6v2H9zm1 2h4v2h-4z"/></g><g fill="#9400D3"><path d="M10 10h1v2h-1zm3 0h1v2h-1z"/></g><g fill="#00FF00" opacity="0.6"><path d="M9 9h6v4H9z"/></g></svg>';
        
        // Torch
        itemSVGs[4] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#FF4500"><path d="M11 4h2v3h-2zm-1 1h4v3h-4zm-1 1h6v3H9z"/></g><g fill="#FFD700"><path d="M11 5h2v2h-2z"/></g><g fill="#8B4513"><path d="M11 9h2v10h-2z"/></g><g fill="#654321"><path d="M10 17h4v2h-4z"/></g></svg>';
        
        // Wine
        itemSVGs[5] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#8B0000"><path d="M10 6h4v6h-4z"/></g><g fill="#2F4F4F"><path d="M10 6h4v1h-4zm1 6h2v4h-2zm-1 4h4v1h-4zm0 1h4v2h-4z"/></g><g fill="#DC143C" opacity="0.7"><path d="M10 7h4v4h-4z"/></g></svg>';
        
        // Scythe
        itemSVGs[6] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#C0C0C0"><path d="M8 4h8v1H8zm6 1h3v1h-3zm5 1h1v1h-1zm0 1h1v2h-1z"/></g><g fill="#8B4513"><path d="M11 5h2v14h-2z"/></g><g fill="#A9A9A9"><path d="M8 4h1v1H8zm7 1h1v1h-1zm3 1h1v1h-1z"/></g></svg>';
        
        // Staff
        itemSVGs[7] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#8B4513"><path d="M11 6h2v14h-2z"/></g><g fill="#9370DB"><path d="M10 4h4v4h-4z"/></g><g fill="#FFD700"><path d="M11 5h2v2h-2z"/></g><g fill="#4B0082"><path d="M10 4h1v1h-1zm3 0h1v1h-1zm-3 3h1v1h-1zm3 0h1v1h-1z"/></g></svg>';
        
        // Shoulder
        itemSVGs[8] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#696969"><path d="M7 8h4v3H7zm6 0h4v3h-4z"/></g><g fill="#A9A9A9"><path d="M7 8h4v1H7zm6 0h4v1h-4z"/></g><g fill="#FF0000"><path d="M8 9h2v1H8zm6 0h2v1h-2z"/></g></svg>';
        
        // Amulet
        itemSVGs[9] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#FFD700"><path d="M11 7h2v1h-2zm-1 1h4v1h-4zm-1 1h6v6H9zm1 6h4v1h-4zm1 1h2v1h-2z"/></g><g fill="#FF0000"><path d="M11 11h2v2h-2z"/></g><g fill="#FFA500"><path d="M10 10h1v1h-1zm3 0h1v1h-1zm-3 3h1v1h-1zm3 0h1v1h-1z"/></g></svg>';
    }
    
    function getItemSVG(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid item ID");
        return itemSVGs[id];
    }
    
    function getItemName(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid item ID");
        return itemNames[id];
    }
    
    // Owner can update SVGs if needed
    function setItemSVG(uint8 id, string calldata svg) external onlyOwner {
        require(id < 10, "Invalid item ID");
        itemSVGs[id] = svg;
    }
}