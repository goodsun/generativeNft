// SPDX-License-Identifier: MIT
// Auto-generated extra effect
pragma solidity ^0.8.20;

/**
 * @title TragedyBlackoutEffect
 * @notice Individual SVG contract for Blackout effect
 */
contract TragedyBlackoutEffect {
    function getSVG() external pure returns (string memory) {
        return '<svg xmlns="http://www.w3.org/2000/svg"width="240"height="240"><rect width="240"height="240"fill="black"><animate attributeName="opacity"values="0;1;1;0"dur="2s"repeatCount="indefinite"/></rect></svg>';
    }
}