// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/interfaces/IERC2981.sol";

/**
 * @title RoyaltyStandard
 * @notice Implementation of the ERC2981 NFT Royalty Standard
 * @dev Abstract contract that provides royalty information for NFT marketplaces
 */
abstract contract RoyaltyStandard is IERC2981 {

    struct RoyaltyInfo {
        address recipient;
        uint16 feeRate;
    }

    // Basis point denominator for percentage calculations (10000 = 100%)
    uint16 public constant INVERSE_BASIS_POINT = 10000;

    // Mapping from token ID to royalty information
    mapping(uint256 => RoyaltyInfo) private _royalties;

    /**
     * @dev Sets the royalty information for a specific token
     * @param tokenId The token ID to set royalty for
     * @param recipient The address that will receive royalties
     * @param feeRate The royalty fee rate in basis points (e.g., 250 = 2.5%)
     */
    function _setTokenRoyalty(
        uint256 tokenId,
        address recipient,
        uint256 feeRate
    ) internal {
        require(feeRate <= INVERSE_BASIS_POINT, "Fee rate exceeds 100%");
        require(recipient != address(0), "Invalid recipient");

        _royalties[tokenId] = RoyaltyInfo(recipient, uint16(feeRate));
    }

    /**
     * @notice Returns royalty information for a token sale
     * @param tokenId The token ID to check
     * @param salePrice The sale price of the token
     * @return receiver The address that should receive the royalty
     * @return royaltyAmount The amount of royalty to be paid
     */
    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view override returns (address receiver, uint256 royaltyAmount) {
        RoyaltyInfo memory royalty = _royalties[tokenId];
        receiver = royalty.recipient;
        royaltyAmount = (salePrice * royalty.feeRate) / INVERSE_BASIS_POINT;
    }

    /**
     * @notice Checks if the contract supports a specific interface
     * @param interfaceId The interface identifier to check
     * @return True if the interface is supported
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return interfaceId == type(IERC2981).interfaceId;
    }
}