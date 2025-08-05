// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ITragedyVisualMaterialBank
 * @notice Interface for SVG materials only
 */
interface ITragedyVisualMaterialBank {
    // SVG getters
    function getSpeciesSVG(uint8 id) external view returns (string memory);
    function getEquipmentSVG(uint8 id) external view returns (string memory);
    function getBackgroundSVG(uint8 id) external view returns (string memory);
    function getEffectSVG(uint8 id) external view returns (string memory);
}