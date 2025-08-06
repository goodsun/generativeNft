// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./layer4/generated/TragedyDetailedEffectBank.sol";

contract TestEffectBank {
    TragedyDetailedEffectBank public bank;
    
    constructor() {
        bank = new TragedyDetailedEffectBank();
    }
    
    function getMeteorSVG() external view returns (string memory) {
        return bank.getEffectSVG(3); // Meteor is ID 3
    }
}