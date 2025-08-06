// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyWine
 * @notice Individual SVG contract for Wine item (scaled to 24x24)
 */
contract TragedyWine {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="3.8"y="3"width="4.5"height="0.3"fill="#E0E0E0"/><rect x="3.5"y="3.4"width="5"height="0.7"fill="#E0E0E0"/><rect x="3.5"y="4"width="5"height="2.5"fill="#E0E0E0"/><rect x="3.8"y="6.5"width="4.5"height="0.7"fill="#E0E0E0"/><rect x="4"y="7.2"width="4"height="0.3"fill="#E0E0E0"/><rect x="3.8"y="4.8"width="4.5"height="1.5"fill="#DC143C"/><rect x="4"y="4.5"width="4"height="0.3"fill="#FF1744"/><rect x="5.8"y="7.5"width="0.5"height="1.8"fill="#E0E0E0"/><rect x="4.8"y="9.3"width="2.5"height="0.3"fill="#E0E0E0"/><rect x="4.5"y="9.6"width="3"height="0.4"fill="#E0E0E0"/><rect x="3.8"y="3.5"width="1"height="1.3"fill="#FFF"/><rect x="4"y="4.8"width="0.8"height="1"fill="#FFE0E0"/></svg>'
        
        ));
    }
}