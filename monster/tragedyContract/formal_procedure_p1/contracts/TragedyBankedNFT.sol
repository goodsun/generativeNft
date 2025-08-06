// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BankedNFT.sol";

/**
 * @title TragedyBankedNFT
 * @notice Tragedy NFT using the BankedNFT base contract
 */
contract TragedyBankedNFT is BankedNFT {
    constructor(
        address _metadataBank
    ) BankedNFT(
        "Tragedy Myth Banked",
        "MYTHB",
        10000,
        0.01 ether,
        500 // 5% royalty
    ) {
        metadataBank = IMetadataBank(_metadataBank);
    }
}