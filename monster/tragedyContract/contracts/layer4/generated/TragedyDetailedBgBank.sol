// SPDX-License-Identifier: MIT
// Auto-generated Bank Contract
pragma solidity ^0.8.20;

import "./bg/TragedyBloodmoonLib.sol";
import "./bg/TragedyAbyssLib.sol";
import "./bg/TragedyDecayLib.sol";
import "./bg/TragedyCorruptionLib.sol";
import "./bg/TragedyVenomLib.sol";
import "./bg/TragedyVoidLib.sol";
import "./bg/TragedyInfernoLib.sol";
import "./bg/TragedyFrostLib.sol";
import "./bg/TragedyRagnarokLib.sol";
import "./bg/TragedyShadowLib.sol";

contract TragedyDetailedBgBank {
    
    function getBackgroundSVG(uint8 id) external pure returns (string memory) {
        if (id == 0) return TragedyBloodmoonLib.getSVG();
        if (id == 1) return TragedyAbyssLib.getSVG();
        if (id == 2) return TragedyDecayLib.getSVG();
        if (id == 3) return TragedyCorruptionLib.getSVG();
        if (id == 4) return TragedyVenomLib.getSVG();
        if (id == 5) return TragedyVoidLib.getSVG();
        if (id == 6) return TragedyInfernoLib.getSVG();
        if (id == 7) return TragedyFrostLib.getSVG();
        if (id == 8) return TragedyRagnarokLib.getSVG();
        if (id == 9) return TragedyShadowLib.getSVG();
        revert("Invalid ID");
    }
}