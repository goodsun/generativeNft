// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMonsterBank {
    function getMonsterSVG(uint8 monsterId) external view returns (string memory);
    function getMonsterName(uint8 monsterId) external view returns (string memory);
}

interface IMonsterBankV3 {
    function bank1() external view returns (address);
    function bank2() external view returns (address);
    function getMonsterSVG(uint8 monsterId) external view returns (string memory);
    function getMonsterName(uint8 monsterId) external view returns (string memory);
}