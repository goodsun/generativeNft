// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyScythe
 * @notice Individual SVG contract for Scythe item (scaled to 24x24)
 */
contract TragedyScythe {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="5.5"y="2"width="0.5"height="7"fill="#8B4513"/><rect x="6"y="2.5"width="0.5"height="6.5"fill="#654321"/><rect x="5"y="2"width="1.5"height="0.5"fill="#2F2F2F"/><rect x="5"y="2.5"width="1.5"height="0.5"fill="#4A4A4A"/><rect x="5.5"y="3"width="3.5"height="0.5"fill="#C0C0C0"/><rect x="6.5"y="3.5"width="3"height="0.5"fill="#C0C0C0"/><rect x="7"y="4"width="2.5"height="0.5"fill="#C0C0C0"/><rect x="7.5"y="4.5"width="2"height="0.5"fill="#C0C0C0"/><rect x="7.5"y="5"width="1.5"height="0.5"fill="#C0C0C0"/><rect x="8"y="5.5"width="1"height="0.5"fill="#C0C0C0"/><rect x="8"y="6"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="7"y="3"width="1.5"height="0.5"fill="#E5E5E5"/><rect x="8"y="4"width="1"height="0.5"fill="#E5E5E5"/><rect x="6.5"y="3.5"width="0.5"height="1.5"fill="#808080"/><rect x="5.5"y="9"width="1"height="1"fill="#8B0000"/><rect x="5"y="9.5"width="2"height="0.5"fill="#8B0000"/></svg>'
        
        ));
    }
}