// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ITragedyTextMaterialBank
 * @notice Interface for text materials only
 */
interface ITragedyTextMaterialBank {
    // Name getters
    function getSpeciesName(uint8 id) external view returns (string memory);
    function getEquipmentName(uint8 id) external view returns (string memory);
    function getRealmName(uint8 id) external view returns (string memory);
    function getCurseName(uint8 id) external view returns (string memory);
    
    // Template getters
    function getNameTemplate(uint8 templateId) external view returns (string memory);
    function getDescriptionTemplate(uint8 templateId) external view returns (string memory);
}