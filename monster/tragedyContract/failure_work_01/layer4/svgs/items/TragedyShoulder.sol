// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyShoulder
 * @notice Individual SVG contract for Shoulder item (scaled to 24x24)
 */
contract TragedyShoulder {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="4"y="3"width="4"height="0.5"fill="#696969"/><rect x="3.5"y="3.5"width="5"height="0.5"fill="#696969"/><rect x="3"y="4"width="6"height="0.5"fill="#696969"/><rect x="3"y="4.5"width="6"height="0.5"fill="#696969"/><rect x="3"y="5"width="6"height="0.5"fill="#696969"/><rect x="3.5"y="5.5"width="5"height="0.5"fill="#696969"/><rect x="4"y="6"width="4"height="0.5"fill="#696969"/><rect x="4.5"y="6.5"width="3"height="0.5"fill="#696969"/><rect x="4.5"y="3.5"width="1"height="0.5"fill="#C0C0C0"/><rect x="4"y="4"width="1"height="0.5"fill="#C0C0C0"/><rect x="3.5"y="4.5"width="0.5"height="0.5"fill="#C0C0C0"/><rect x="5"y="2.5"width="0.5"height="0.5"fill="#808080"/><rect x="6.5"y="2.5"width="0.5"height="0.5"fill="#808080"/><rect x="5"y="2"width="0.5"height="0.5"fill="#A9A9A9"/><rect x="6.5"y="2"width="0.5"height="0.5"fill="#A9A9A9"/><rect x="4"y="5"width="0.5"height="0.5"fill="#4B4B4B"/><rect x="7.5"y="5"width="0.5"height="0.5"fill="#4B4B4B"/><rect x="5"y="6"width="0.5"height="0.5"fill="#4B4B4B"/><rect',
            ' x="6.5"y="6"width="0.5"height="0.5"fill="#4B4B4B"/><rect x="8"y="4"width="0.5"height="0.5"fill="#2F2F2F"/><rect x="8.5"y="4.5"width="0.5"height="0.5"fill="#2F2F2F"/><rect x="8"y="5"width="0.5"height="0.5"fill="#2F2F2F"/><rect x="7"y="6.5"width="0.5"height="0.5"fill="#2F2F2F"/><rect x="5"y="7"width="0.5"height="0.5"fill="#8B4513"/><rect x="6.5"y="7"width="0.5"height="0.5"fill="#8B4513"/><rect x="5"y="7.5"width="2"height="0.5"fill="#8B4513"/></svg>'
        
        ));
    }
}