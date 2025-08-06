// SPDX-License-Identifier: MIT
// Auto-generated from bg/Bloodmoon.svg
pragma solidity ^0.8.20;

/**
 * @title TragedyBloodmoonBG
 * @notice Individual SVG contract for Bloodmoon
 */
contract TragedyBloodmoonBG {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg width="240px" height="240px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="bloodSky" cx="50%" cy="30%"><stop offset="0%" style="stop-color:#8B0000;stop-opacity:1" /><stop offset="100%" style="stop-color:#2B0000;stop-opacity:1" /></radialGradient><radialGradient id="moon" cx="50%" cy="50%"><stop offset="0%" style="stop-color:#FF6B6B;stop-opacity:1" /><stop offset="70%" style="stop-color:#DC143C;stop-opacity:1" /><stop offset="100%" style="stop-color:#8B0000;stop-opacity:1" /></radialGradient></defs><rect width="24" height="24" fill="url(#bloodSky)"/><circle cx="18" cy="6" r="4" fill="url(#moon)"/><circle cx="18" cy="6" r="3.5" fill="none" stroke="#FF0000" stroke-width="0.2" opacity="0.8"/><path d="M0 14 L3 10 L6 12 L9 8 L12 11 L15 9 L18 13 L21 10 L24 14 L24 24 L0 24 Z" fill="#1A0000"/><ellipse cx="18" cy="10" rx="0.3" ry="1" fill="#8B0000" opacity="0.7"/><ellipse cx="17" cy="9" rx="0.2" ry="0.8" fill="#8B0000" opacity="0.5"/><rect x="4" y="11" wid',
            'th="2" height="3" fill="#0A0000"/><polygon points="3,11 5,9 7,11" fill="#0A0000"/><ellipse cx="12" cy="18" rx="8" ry="2" fill="#8B0000" opacity="0.2"/><ellipse cx="8" cy="20" rx="6" ry="1.5" fill="#8B0000" opacity="0.15"/></svg>'
        ));
    }
}