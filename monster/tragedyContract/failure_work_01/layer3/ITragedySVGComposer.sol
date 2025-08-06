// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ITragedySVGComposer
 * @notice Interface for composing SVG from multiple layers
 */
interface ITragedySVGComposer {
    /**
     * @notice Compose SVG from species, equipment, realm, and curse
     * @param species Species ID (0-9)
     * @param equipment Equipment ID (0-9) 
     * @param realm Realm ID (0-9)
     * @param curse Curse ID (0-9)
     * @return Complete SVG string
     */
    function composeSVG(
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (string memory);
    
    /**
     * @notice Set the material bank contract address
     * @param bank Address of TragedyMaterialBank
     */
    function setMaterialBank(address bank) external;
}