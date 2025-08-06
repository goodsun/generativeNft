// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IMetadataBank
 * @notice Interface for MetadataBank contracts
 */
interface IMetadataBank {
    function getMetadata(uint256 index) external view returns (string memory);
    function getMetadataCount() external view returns (uint256);
}