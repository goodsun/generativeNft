// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyCrown
 * @notice Individual SVG contract for Crown item (scaled to 24x24)
 */
contract TragedyCrown {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="3.5"y="1"width="1"height="2"fill="#FFD700"/><rect x="5.5"y="0"width="1"height="3"fill="#FFD700"/><rect x="7.5"y="1"width="1"height="2"fill="#FFD700"/><rect x="3.5"y="3"width="5"height="1"fill="#FFD700"/><rect x="4.5"y="2"width="1"height="1"fill="#FFD700"/><rect x="6.5"y="2"width="1"height="1"fill="#FFD700"/><rect x="3.5"y="0"width="1"height="1"fill="#DC143C"/><rect x="5.5"y="0"width="1"height="0.5"fill="#DC143C"/><rect x="7.5"y="0"width="1"height="1"fill="#DC143C"/><rect x="3"y="0"width="0.5"height="1"fill="#C0C0C0"/><rect x="4.5"y="0"width="0.5"height="1"fill="#C0C0C0"/><rect x="5"y="0"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="6.5"y="0"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="7"y="0"width="0.5"height="1"fill="#C0C0C0"/><rect x="8.5"y="0"width="0.5"height="1"fill="#C0C0C0"/><rect x="5"y="2.5"width="0.5"height="0.5"fill="#FFF"/><rect x="6.5"y="2.5"width="0.5"height="0.5"fill="#FFF"/><rect x="4"y="1.5"width="0.5"height="0.5"fill="#FFFFE0"/><rect x="6"y="0.5"',
            'width="0.5"height="1"fill="#FFFFE0"/></svg>'
        
        ));
    }
}