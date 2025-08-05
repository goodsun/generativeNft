// SPDX-License-Identifier: MIT
// Auto-generated from bg/Venom.svg
pragma solidity ^0.8.20;

/**
 * @title TragedyVenomBG
 * @notice Individual SVG contract for Venom
 */
contract TragedyVenomBG {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg width="240px" height="240px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="venomGrad" cx="50%" cy="40%"><stop offset="0%" style="stop-color:#FF1493;stop-opacity:1" /><stop offset="50%" style="stop-color:#8B008B;stop-opacity:1" /><stop offset="100%" style="stop-color:#4B0082;stop-opacity:1" /></radialGradient><filter id="poison"><feTurbulence baseFrequency="0.8" numOctaves="1" seed="2"/><feColorMatrix values="0 0 0 0 1 0 0 0 0 0.08 0 0 0 0 0.58 0 0 0 0.8 0"/></filter></defs><rect width="24" height="24" fill="url(#venomGrad)"/><ellipse cx="12" cy="18" rx="10" ry="4" fill="#FF1493" opacity="0.4"/><ellipse cx="8" cy="17" rx="4" ry="2" fill="#FF1493" opacity="0.3" filter="url(#poison)"/><ellipse cx="16" cy="19" rx="3" ry="1.5" fill="#FF1493" opacity="0.3" filter="url(#poison)"/><ellipse cx="6" cy="14" rx="2" ry="1" fill="#8B008B"/><rect x="5.5" y="14" width="1" height="2" fill="#4B0082"/><circle cx="5.5" cy="13.5" r="0.2" fill="#FF1493"/><circle cx="6',
            '.5" cy="13.8" r="0.2" fill="#FF1493"/><ellipse cx="16" cy="12" rx="3" ry="1.5" fill="#8B008B"/><rect x="15" y="12" width="2" height="3" fill="#4B0082"/><circle cx="15" cy="11.5" r="0.3" fill="#FF1493"/><circle cx="17" cy="11.8" r="0.3" fill="#FF1493"/><circle cx="16" cy="11" r="0.3" fill="#FF1493"/><ellipse cx="12" cy="8" rx="6" ry="3" fill="#FF1493" opacity="0.2" filter="url(#poison)"/><ellipse cx="10" cy="6" rx="4" ry="2" fill="#FF1493" opacity="0.15" filter="url(#poison)"/><ellipse cx="9" cy="10" rx="0.3" ry="0.6" fill="#FF1493" opacity="0.8"/><ellipse cx="14" cy="9" rx="0.3" ry="0.6" fill="#FF1493" opacity="0.7"/></svg>'
        ));
    }
}