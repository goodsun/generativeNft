// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ITragedyMetadataBank
 * @notice Interface for generating complete NFT metadata
 */
interface ITragedyMetadataBank {
    /**
     * @notice Generate complete tokenURI metadata for a given NFT
     * @param tokenId The token ID
     * @param species Species ID (0-9)
     * @param equipment Equipment ID (0-9)
     * @param realm Realm ID (0-9)
     * @param curse Curse ID (0-9)
     * @return Complete JSON metadata as data URI
     */
    function tokenURI(
        uint256 tokenId,
        uint8 species,
        uint8 equipment,
        uint8 realm,
        uint8 curse
    ) external view returns (string memory);
    
    /**
     * @notice Set the SVG composer contract address
     * @param composer Address of TragedySVGComposer
     */
    function setSVGComposer(address composer) external;
    
    /**
     * @notice Set the text composer contract address
     * @param composer Address of TragedyTextComposer
     */
    function setTextComposer(address composer) external;
    
    /**
     * @notice Set the material bank contract address
     * @param bank Address of TragedyMaterialBank
     */
    function setMaterialBank(address bank) external;
}