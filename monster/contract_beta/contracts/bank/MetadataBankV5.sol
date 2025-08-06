// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MetadataBank.sol";

/**
 * @title MetadataBankV5
 * @notice Proxy contract that delegates metadata generation to TragedyMetadataV3
 */
contract MetadataBankV5 is IMetadataBank {
    address public immutable metadataContract;
    
    constructor(address _metadataContract) {
        metadataContract = _metadataContract;
    }
    
    function getMetadata(uint256 index) external view override returns (string memory) {
        return IMetadataBank(metadataContract).getMetadata(index);
    }
    
    function getMetadataCount() external view override returns (uint256) {
        return IMetadataBank(metadataContract).getMetadataCount();
    }
}