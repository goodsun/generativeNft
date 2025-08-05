// SPDX-License-Identifier: MIT
// Auto-generated extra effect
pragma solidity ^0.8.20;

/**
 * @title TragedyMatrixEffect
 * @notice Individual SVG contract for Matrix effect
 */
contract TragedyMatrixEffect {
    function getSVG() external pure returns (string memory) {
        return '<svg xmlns="http://www.w3.org/2000/svg"width="240"height="240"><defs><pattern id="matrix"x="0"y="0"width="20"height="20"patternUnits="userSpaceOnUse"><text x="0"y="15"font-size="15"fill="#00ff00"opacity="0.8">0<animate attributeName="opacity"values="0;1;0"dur="1s"repeatCount="indefinite"/></text><text x="10"y="15"font-size="15"fill="#00ff00"opacity="0.8">1<animate attributeName="opacity"values="0;1;0"dur="1.5s"repeatCount="indefinite"/></text></pattern></defs><rect width="240"height="240"fill="black"/><rect width="240"height="240"fill="url(#matrix)"/></svg>';
    }
}