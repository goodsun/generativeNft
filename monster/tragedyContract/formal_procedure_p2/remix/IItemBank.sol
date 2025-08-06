// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IItemBank {
    function getItemSVG(uint8 itemId) external view returns (string memory);
    function getItemName(uint8 itemId) external view returns (string memory);
}

interface IItemBankV3 {
    function bank1() external view returns (address);
    function bank2() external view returns (address);
    function getItemSVG(uint8 itemId) external view returns (string memory);
    function getItemName(uint8 itemId) external view returns (string memory);
}