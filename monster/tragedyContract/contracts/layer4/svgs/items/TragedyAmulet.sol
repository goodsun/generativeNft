// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyAmulet
 * @notice Individual SVG contract for Amulet item (scaled to 24x24)
 */
contract TragedyAmulet {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="4"y="2.5"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="7.5"y="2.5"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="4"y="3"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="7.5"y="3"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="4.5"y="3.5"width="3"height="0.5"fill="#FFD700"/><rect x="4"y="4"width="4"height="0.5"fill="#FFD700"/><rect x="3.5"y="4.5"width="5"height="0.5"fill="#FFD700"/><rect x="3.5"y="5"width="5"height="0.5"fill="#FFD700"/><rect x="3.5"y="5.5"width="5"height="0.5"fill="#FFD700"/><rect x="4"y="6"width="4"height="0.5"fill="#FFD700"/><rect x="4.5"y="6.5"width="3"height="0.5"fill="#FFD700"/><rect x="5.5"y="7"width="1"height="0.5"fill="#FFD700"/><rect x="5"y="4.5"width="2"height="0.5"fill="#9370DB"/><rect x="4.5"y="5"width="3"height="0.5"fill="#9370DB"/><rect x="5"y="5.5"width="2"height="0.5"fill="#9370DB"/><rect x="5.5"y="5"width="1"height="0.5"fill="#DDA0DD"/><rect x="4.5"y="4"width="1"height="0.5"fill="#FFFFE0"/><rect x="4"y="4.5"width="0.5"height="0.5"fill="#FFFFE0"/><rect ',
            'x="7"y="6"width="0.5"height="0.5"fill="#DAA520"/><rect x="7.5"y="5.5"width="0.5"height="0.5"fill="#DAA520"/><rect x="6"y="6.5"width="1"height="0.5"fill="#DAA520"/></svg>'
        
        ));
    }
}