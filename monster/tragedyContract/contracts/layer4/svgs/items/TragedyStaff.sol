// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyStaff
 * @notice Individual SVG contract for Staff item (scaled to 24x24)
 */
contract TragedyStaff {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="5.5"y="4"width="0.5"height="5"fill="#8B4513"/><rect x="5"y="4.5"width="0.5"height="4"fill="#654321"/><rect x="6"y="4.5"width="0.5"height="4"fill="#A0522D"/><rect x="4.5"y="2"width="2.5"height="0.5"fill="#9370DB"/><rect x="4"y="2.5"width="3.5"height="0.5"fill="#9370DB"/><rect x="4"y="3"width="3.5"height="0.5"fill="#9370DB"/><rect x="4"y="3.5"width="3.5"height="0.5"fill="#9370DB"/><rect x="4.5"y="4"width="2.5"height="0.5"fill="#9370DB"/><rect x="5"y="2.5"width="1"height="0.5"fill="#DDA0DD"/><rect x="5.5"y="3"width="1"height="0.5"fill="#DDA0DD"/><rect x="4"y="3.5"width="1"height="0.5"fill="#6A0DAD"/><rect x="6.5"y="3.5"width="1"height="0.5"fill="#6A0DAD"/><rect x="5.5"y="1"width="0.5"height="0.5"fill="#FFD700"/><rect x="3.5"y="2.5"width="0.5"height="0.5"fill="#FFD700"/><rect x="7.5"y="2.5"width="0.5"height="0.5"fill="#FFD700"/><rect x="5.5"y="4.5"width="0.5"height="0.5"fill="#FFD700"/><rect x="5"y="9"width="1.5"height="0.5"fill="#2F2F2F"/></svg>'
        
        ));
    }
}