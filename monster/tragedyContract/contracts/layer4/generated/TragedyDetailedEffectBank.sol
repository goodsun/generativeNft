// SPDX-License-Identifier: MIT
// Auto-generated Bank Contract
pragma solidity ^0.8.20;

import "./effect/TragedySeizureLib.sol";
import "./effect/TragedyMindblastLib.sol";
import "./effect/TragedyConfusionLib.sol";
import "./effect/TragedyMeteorLib.sol";
import "./effect/TragedyBatsLib.sol";
import "./effect/TragedyPoisoningLib.sol";
import "./effect/TragedyLightningLib.sol";
import "./effect/TragedyBlizzardLib.sol";
import "./effect/TragedyBurningLib.sol";
import "./effect/TragedyBrainwashLib.sol";

contract TragedyDetailedEffectBank {
    
    function getEffectSVG(uint8 id) external pure returns (string memory) {
        if (id == 0) return TragedySeizureLib.getSVG();
        if (id == 1) return TragedyMindblastLib.getSVG();
        if (id == 2) return TragedyConfusionLib.getSVG();
        if (id == 3) return TragedyMeteorLib.getSVG();
        if (id == 4) return TragedyBatsLib.getSVG();
        if (id == 5) return TragedyPoisoningLib.getSVG();
        if (id == 6) return TragedyLightningLib.getSVG();
        if (id == 7) return TragedyBlizzardLib.getSVG();
        if (id == 8) return TragedyBurningLib.getSVG();
        if (id == 9) return TragedyBrainwashLib.getSVG();
        revert("Invalid ID");
    }
}