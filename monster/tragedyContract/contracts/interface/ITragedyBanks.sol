// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMonsterBank {
    function getSpeciesSVG(uint8 id) external view returns (string memory);
}

interface IBackgroundBank {
    function getBackgroundSVG(uint8 id) external view returns (string memory);
}

interface IItemBank {
    function getItemSVG(uint8 id) external view returns (string memory);
}

interface IEffectBank {
    function getEffectSVG(uint8 id) external view returns (string memory);
}