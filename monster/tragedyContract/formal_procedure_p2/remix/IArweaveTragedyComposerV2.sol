// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IArweaveTragedyComposerV2 {
    struct FilterParams {
        uint16 hueRotate;
        uint16 saturate;
        uint16 brightness;
    }
    
    function composeSVG(
        uint8 species,
        uint8 background,
        uint8 item,
        uint8 effect
    ) external view returns (string memory);
    
    function filterParams(uint8 backgroundId) external view returns (
        uint16 hueRotate,
        uint16 saturate,
        uint16 brightness
    );
    
    function setFilterParams(
        uint8 backgroundId,
        uint16 hueRotate,
        uint16 saturate,
        uint16 brightness
    ) external;
    
    function monsterBank() external view returns (address);
    function itemBank() external view returns (address);
    function backgroundBank() external view returns (address);
    function effectBank() external view returns (address);
    function owner() external view returns (address);
}