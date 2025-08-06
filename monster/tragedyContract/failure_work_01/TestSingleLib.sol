// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./layer4/generated/monsters/TragedyDemonLib.sol";

contract TestSingleLib {
    function getDemonSVG() external pure returns (string memory) {
        return TragedyDemonLib.getSVG();
    }
}