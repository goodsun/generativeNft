// SPDX-License-Identifier: MIT
// Auto-generated from bg/Void.svg
pragma solidity ^0.8.20;

/**
 * @title TragedyVoidBG
 * @notice Individual SVG contract for Void
 */
contract TragedyVoidBG {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg width="240px" height="240px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="voidGrad" cx="50%" cy="50%"><stop offset="0%" style="stop-color:#0A0014;stop-opacity:1" /><stop offset="50%" style="stop-color:#2D0066;stop-opacity:1" /><stop offset="100%" style="stop-color:#1A0033;stop-opacity:1" /></radialGradient><filter id="voidDistort"><feTurbulence baseFrequency="0.02" numOctaves="3" result="turbulence"/><feDisplacementMap in2="turbulence" in="SourceGraphic" scale="3"/></filter></defs><rect width="24" height="24" fill="url(#voidGrad)"/><circle cx="12" cy="12" r="8" fill="none" stroke="#1A0033" stroke-width="0.5" opacity="0.5" filter="url(#voidDistort)"/><circle cx="12" cy="12" r="6" fill="none" stroke="#1A0033" stroke-width="0.4" opacity="0.4" filter="url(#voidDistort)"/><circle cx="12" cy="12" r="4" fill="none" stroke="#1A0033" stroke-width="0.3" opacity="0.3" filter="url(#voidDistort)"/><circle cx="12" cy="12" r="2" fill="#000000" opacity="0.9"/><',
            'rect x="3" y="5" width="1.5" height="1.5" fill="#1A0033" transform="rotate(45 3.75 5.75)" opacity="0.6"/><rect x="18" y="8" width="1" height="1" fill="#1A0033" transform="rotate(30 18.5 8.5)" opacity="0.5"/><rect x="6" y="17" width="1.2" height="1.2" fill="#1A0033" transform="rotate(60 6.6 17.6)" opacity="0.5"/><path d="M8 6 L10 12 L8 18" stroke="#1A0033" stroke-width="0.3" fill="none" opacity="0.4"/><path d="M16 6 L14 12 L16 18" stroke="#1A0033" stroke-width="0.3" fill="none" opacity="0.4"/><circle cx="12" cy="12" r="0.5" fill="#000000"/><circle cx="4" cy="4" r="0.3" fill="#4D0099" opacity="0.8"/><circle cx="20" cy="20" r="0.3" fill="#4D0099" opacity="0.8"/><circle cx="4" cy="20" r="0.25" fill="#3D0080" opacity="0.7"/><circle cx="20" cy="4" r="0.25" fill="#3D0080" opacity="0.7"/></svg>'
        ));
    }
}