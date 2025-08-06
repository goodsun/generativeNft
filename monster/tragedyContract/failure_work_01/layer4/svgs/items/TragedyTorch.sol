// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyTorch
 * @notice Individual SVG contract for Torch item (scaled to 24x24)
 */
contract TragedyTorch {
    function getSVG() external pure returns (string memory) {
        return string(abi.encodePacked(

            '<svg viewBox="0 0 24 24"xmlns="http://www.w3.org/2000/svg"><rect x="5.5"y="5"width="1"height="4"fill="#8B4513"/><rect x="5"y="5.5"width="0.5"height="3"fill="#654321"/><rect x="6.5"y="5.5"width="0.5"height="3"fill="#A0522D"/><rect x="5"y="4.5"width="2"height="0.5"fill="#2F2F2F"/><rect x="5"y="4"width="2"height="0.5"fill="#4A4A4A"/><rect x="5"y="3.5"width="2"height="0.5"fill="#2F2F2F"/><rect x="5"y="3"width="2"height="1"fill="#FF4500"/><rect x="4.5"y="2.5"width="3"height="0.5"fill="#FF4500"/><rect x="4"y="2"width="4"height="0.5"fill="#FF4500"/><rect x="4"y="1.5"width="1.5"height="0.5"fill="#FF4500"/><rect x="6.5"y="1.5"width="1.5"height="0.5"fill="#FF4500"/><rect x="4.5"y="1"width="1"height="0.5"fill="#FF4500"/><rect x="6.5"y="1"width="1"height="0.5"fill="#FF4500"/><rect x="5"y="0.5"width="0.5"height="0.5"fill="#FF4500"/><rect x="6.5"y="0.5"width="0.5"height="0.5"fill="#FF4500"/><rect x="5.5"y="3"width="1"height="1"fill="#FFA500"/><rect x="5"y="2.5"width="2"height="0.5"fill="#FFA500"/><rect x="5"y="2"width="2"height="0.5"fill="#FFA500"/><rect ',
            'x="5.5"y="1.5"width="1"height="0.5"fill="#FFA500"/><rect x="5.5"y="3"width="1"height="0.5"fill="#FFFF00"/><rect x="5.5"y="2.5"width="1"height="0.5"fill="#FFE4B5"/><rect x="3.5"y="0.5"width="0.5"height="0.5"fill="#FF6347"/><rect x="8"y="0.5"width="0.5"height="0.5"fill="#FF6347"/><rect x="4"y="0"width="0.5"height="0.5"fill="#FFA500"/><rect x="7.5"y="0"width="0.5"height="0.5"fill="#FFA500"/><rect x="5.5"y="0"width="0.5"height="0.5"fill="#FFD700"/><rect x="3"y="1.5"width="0.5"height="0.5"fill="#FF8C00"/><rect x="8.5"y="1.5"width="0.5"height="0.5"fill="#FF8C00"/><rect x="5"y="9"width="2"height="0.5"fill="#2F2F2F"/></svg>'
        
        ));
    }
}