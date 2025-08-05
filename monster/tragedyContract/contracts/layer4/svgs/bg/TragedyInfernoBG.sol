// SPDX-License-Identifier: MIT
// Auto-generated from bg/Inferno.svg
pragma solidity ^0.8.20;

/**
 * @title TragedyInfernoBG
 * @notice Individual SVG contract for Inferno
 */
contract TragedyInfernoBG {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg width="240px" height="240px" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><defs><radialGradient id="infernoGrad" cx="50%" cy="70%"><stop offset="0%" style="stop-color:#FF4500;stop-opacity:1" /><stop offset="50%" style="stop-color:#FF6347;stop-opacity:1" /><stop offset="100%" style="stop-color:#8B0000;stop-opacity:1" /></radialGradient><filter id="flame"><feTurbulence baseFrequency="0.05" numOctaves="2" seed="3"/><feDisplacementMap in2="turbulence" in="SourceGraphic" scale="2"/></filter></defs><rect width="24" height="24" fill="url(#infernoGrad)"/><path d="M0 16 Q4 15 8 16 T16 16 Q20 15 24 16 L24 24 L0 24 Z" fill="#8B0000"/><path d="M0 18 Q3 17 6 18 T12 18 Q15 17 18 18 T24 18 L24 24 L0 24 Z" fill="#B22222" opacity="0.8"/><path d="M6 20 L5 16 L7 16 Z" fill="#FF4500" filter="url(#flame)"/><path d="M5.5 16 L5 12 L6 12 Z" fill="#FF6347" opacity="0.8" filter="url(#flame)"/><path d="M18 22 L17 18 L19 18 Z" fill="#FF4500" filter="url(#flame)"/><path d="M17.5 18 L17 14 L18 14 Z" ',
            'fill="#FF6347" opacity="0.8" filter="url(#flame)"/><path d="M12 18 L10 10 L14 10 Z" fill="#FF4500" filter="url(#flame)"/><path d="M12 14 L11 8 L13 8 Z" fill="#FF6347" opacity="0.7" filter="url(#flame)"/><circle cx="4" cy="8" r="0.3" fill="#FFD700" opacity="0.8"/><circle cx="8" cy="6" r="0.2" fill="#FFD700" opacity="0.7"/><circle cx="16" cy="7" r="0.3" fill="#FFD700" opacity="0.7"/><circle cx="20" cy="9" r="0.2" fill="#FFD700" opacity="0.6"/><ellipse cx="12" cy="4" rx="8" ry="3" fill="#8B0000" opacity="0.3"/><ellipse cx="10" cy="2" rx="6" ry="2" fill="#8B0000" opacity="0.2"/></svg>'
        ));
    }
}