// SPDX-License-Identifier: MIT
// Auto-generated Bank Contract
pragma solidity ^0.8.20;

import "./monsters/TragedyWerewolfLib.sol";
import "./monsters/TragedyGoblinLib.sol";
import "./monsters/TragedyFrankensteinLib.sol";
import "./monsters/TragedyDemonLib.sol";
import "./monsters/TragedyDragonLib.sol";
import "./monsters/TragedyZombieLib.sol";
import "./monsters/TragedyVampireLib.sol";
import "./monsters/TragedyMummyLib.sol";
import "./monsters/TragedySuccubusLib.sol";
import "./monsters/TragedySkeletonLib.sol";

contract TragedyDetailedMonstersBank {
    
    function getSpeciesSVG(uint8 id) external pure returns (string memory) {
        if (id == 0) return TragedyWerewolfLib.getSVG();
        if (id == 1) return TragedyGoblinLib.getSVG();
        if (id == 2) return TragedyFrankensteinLib.getSVG();
        if (id == 3) return TragedyDemonLib.getSVG();
        if (id == 4) return TragedyDragonLib.getSVG();
        if (id == 5) return TragedyZombieLib.getSVG();
        if (id == 6) return TragedyVampireLib.getSVG();
        if (id == 7) return TragedyMummyLib.getSVG();
        if (id == 8) return TragedySuccubusLib.getSVG();
        if (id == 9) return TragedySkeletonLib.getSVG();
        revert("Invalid ID");
    }
}