// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArweaveMonsterBank
 * @notice Stores monster SVG data on-chain for the hybrid Arweave approach
 * @dev All monster SVGs are stored as simple strings, will be base64 encoded by composer
 */
contract ArweaveMonsterBank {
    mapping(uint8 => string) private monsterSVGs;
    
    string[10] public monsterNames = [
        "Werewolf",
        "Goblin", 
        "Frankenstein",
        "Demon",
        "Dragon",
        "Zombie",
        "Vampire",
        "Mummy",
        "Succubus",
        "Skeleton"
    ];
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _initializeMonsters();
    }
    
    function _initializeMonsters() private {
        // Werewolf
        monsterSVGs[0] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#8B4513"><path d="M7 4h2v2h-2zm8 0h2v2h-2z"/></g><g fill="#4B0082"><path d="M9 6h6v2h-6zm-2 2h10v2H7zm-1 2h12v2H6zm0 2h12v2H6zm1 2h10v2H7zm2 2h6v2H9zm2 2h2v2h-2z"/></g><g fill="#FF0000"><path d="M10 10h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#FFF"><path d="M9 14h2v1H9zm4 0h2v1h-2z"/></g></svg>';
        
        // Goblin
        monsterSVGs[1] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#228B22"><path d="M8 5h8v2H8zm-2 2h12v2H6zm-1 2h14v2H5zm0 2h14v2H5zm0 2h14v2H5zm1 2h12v2H6zm2 2h8v2H8z"/></g><g fill="#FF0000"><path d="M9 9h2v2H9zm4 0h2v2h-2z"/></g><g fill="#FFF"><path d="M8 13h3v1H8zm5 0h3v1h-3z"/></g><g fill="#FFD700"><path d="M11 17h2v1h-2z"/></g></svg>';
        
        // Frankenstein
        monsterSVGs[2] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#696969"><path d="M8 4h8v2H8zm-1 2h10v2H7zm-1 2h12v2H6zm0 2h12v2H6zm0 2h12v2H6zm0 2h12v2H6zm1 2h10v2H7zm1 2h8v2H8z"/></g><g fill="#000"><path d="M10 8h1v1h-1zm3 0h1v1h-1zm-3 2h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#8B0000"><path d="M7 14h10v1H7z"/></g><g fill="#FF0"><path d="M11 5h1v1h-1zm0 2h1v1h-1z"/></g></svg>';
        
        // Demon  
        monsterSVGs[3] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#8B0000"><path d="M6 4h3v2H6zm9 0h3v2h-3zm-7 2h10v2H8zm-2 2h14v2H6zm-1 2h16v2H5zm0 2h16v2H5zm1 2h14v2H6zm2 2h10v2H8z"/></g><g fill="#FF4500"><path d="M10 10h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#FFF"><path d="M8 14h3v1H8zm5 0h3v1h-3z"/></g><g fill="#FFD700"><path d="M7 5h1v1H7zm9 0h1v1h-1z"/></g></svg>';
        
        // Dragon
        monsterSVGs[4] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#006400"><path d="M10 3h4v2h-4zm-2 2h8v2H8zm-2 2h12v2H6zm-1 2h14v2H5zm0 2h14v2H5zm0 2h14v2H5zm1 2h12v2H6zm2 2h8v2H8z"/></g><g fill="#FF0000"><path d="M9 9h2v2H9zm4 0h2v2h-2z"/></g><g fill="#FFF"><path d="M7 13h4v1H7zm6 0h4v1h-4z"/></g><g fill="#FFD700"><path d="M5 15h1v1H5zm13 0h1v1h-1z"/></g></svg>';
        
        // Zombie
        monsterSVGs[5] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#556B2F"><path d="M8 5h8v2H8zm-2 2h12v2H6zm-1 2h14v2H5zm0 2h14v2H5zm0 2h14v2H5zm1 2h12v2H6zm2 2h8v2H8z"/></g><g fill="#8B0000"><path d="M10 9h1v2h-1zm3 0h1v2h-1z"/></g><g fill="#A52A2A"><path d="M8 14h3v1H8zm5 0h3v1h-3z"/></g><g fill="#F5DEB3"><path d="M9 11h1v1H9zm5 0h1v1h-1z"/></g></svg>';
        
        // Vampire
        monsterSVGs[6] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#000"><path d="M7 3h10v2H7zm-1 2h12v2H6zm-1 2h14v2H5zm0 2h14v2H5zm0 2h14v2H5zm0 2h14v2H5zm1 2h12v2H6zm2 2h8v2H8z"/></g><g fill="#DC143C"><path d="M10 9h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#FFF"><path d="M9 13h2v2H9zm4 0h2v2h-2zm-3 1h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#8B0000"><path d="M11 4h2v1h-2z"/></g></svg>';
        
        // Mummy
        monsterSVGs[7] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#F5DEB3"><path d="M8 4h8v1H8zm-1 1h10v1H7zm-1 1h12v1H6zm0 1h12v1H6zm0 1h12v1H6zm0 1h12v1H6zm0 1h12v1H6zm0 1h12v1H6zm0 1h12v1H6zm0 1h12v1H6zm1 1h10v1H7zm1 1h8v1H8z"/></g><g fill="#000"><path d="M10 8h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#8B4513"><path d="M7 5h1v1H7zm2 0h1v1H9zm2 0h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1zm1 1h1v1h-1zm-9 1h1v1H7zm2 0h1v1H9z"/></g></svg>';
        
        // Succubus
        monsterSVGs[8] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#8B008B"><path d="M6 3h3v2H6zm9 0h3v2h-3z"/></g><g fill="#9370DB"><path d="M8 5h8v2H8zm-2 2h12v2H6zm-1 2h14v2H5zm0 2h14v2H5zm0 2h14v2H5zm1 2h12v2H6zm2 2h8v2H8z"/></g><g fill="#FF1493"><path d="M10 9h1v1h-1zm3 0h1v1h-1z"/></g><g fill="#FFF"><path d="M9 13h2v1H9zm4 0h2v1h-2z"/></g><g fill="#FF69B4"><path d="M11 16h2v1h-2z"/></g></svg>';
        
        // Skeleton
        monsterSVGs[9] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="#F5F5F5"><path d="M9 4h6v2H9zm-2 2h10v2H7zm-1 2h12v2H6zm0 2h12v2H6zm0 2h12v2H6zm0 2h12v2H6zm1 2h10v2H7zm2 2h6v2H9z"/></g><g fill="#000"><path d="M9 8h2v2H9zm4 0h2v2h-2zm-4 5h6v1H9zm1 2h1v1h-1zm2 0h1v1h-1zm2 0h1v1h-1z"/></g></svg>';
    }
    
    function getSpeciesSVG(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid monster ID");
        return monsterSVGs[id];
    }
    
    function getMonsterName(uint8 id) external view returns (string memory) {
        require(id < 10, "Invalid monster ID");
        return monsterNames[id];
    }
    
    // Owner can update SVGs if needed
    function setMonsterSVG(uint8 id, string calldata svg) external onlyOwner {
        require(id < 10, "Invalid monster ID");
        monsterSVGs[id] = svg;
    }
}