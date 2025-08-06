// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBackgroundBank {
    function getBackgroundUrl(uint8 backgroundId) external pure returns (string memory);
    function getBackgroundName(uint8 backgroundId) external pure returns (string memory);
}