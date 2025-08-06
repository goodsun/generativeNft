// SPDX-License-Identifier: MIT
// Auto-generated Bank Contract
pragma solidity ^0.8.20;

import "./items/TragedyCrownLib.sol";
import "./items/TragedySwordLib.sol";
import "./items/TragedyShieldLib.sol";
import "./items/TragedyPoisonLib.sol";
import "./items/TragedyTorchLib.sol";
import "./items/TragedyWineLib.sol";
import "./items/TragedyScytheLib.sol";
import "./items/TragedyStaffLib.sol";
import "./items/TragedyShoulderLib.sol";
import "./items/TragedyAmuletLib.sol";

contract TragedyDetailedItemsBank {
    
    function getEquipmentSVG(uint8 id) external pure returns (string memory) {
        if (id == 0) return TragedyCrownLib.getSVG();
        if (id == 1) return TragedySwordLib.getSVG();
        if (id == 2) return TragedyShieldLib.getSVG();
        if (id == 3) return TragedyPoisonLib.getSVG();
        if (id == 4) return TragedyTorchLib.getSVG();
        if (id == 5) return TragedyWineLib.getSVG();
        if (id == 6) return TragedyScytheLib.getSVG();
        if (id == 7) return TragedyStaffLib.getSVG();
        if (id == 8) return TragedyShoulderLib.getSVG();
        if (id == 9) return TragedyAmuletLib.getSVG();
        revert("Invalid ID");
    }
}