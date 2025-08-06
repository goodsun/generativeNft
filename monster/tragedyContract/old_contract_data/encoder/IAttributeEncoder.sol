// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IAttributeEncoder
 * @notice Interface for different encoding systems
 */
interface IAttributeEncoder {
    function encode(uint8 a, uint8 b, uint8 c, uint8 d) external pure returns (string memory);
    function decode(string memory code) external pure returns (uint8 a, uint8 b, uint8 c, uint8 d);
    function getMaxValue() external pure returns (uint256);
    function getBase() external pure returns (uint8);
}