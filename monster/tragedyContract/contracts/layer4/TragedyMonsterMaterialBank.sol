// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TragedyMonsterSVGLib.sol";

/**
 * @title TragedyMonsterMaterialBank
 * @notice Dedicated storage for monster SVGs only
 */
contract TragedyMonsterMaterialBank {
    
    // Monster SVG getter using library
    function getSpeciesSVG(uint8 id) external pure returns (string memory) {
        if (id == 0) return TragedyMonsterSVGLib.getWerewolfSVG();
        if (id == 1) return TragedyMonsterSVGLib.getGoblinSVG();
        if (id == 2) return TragedyMonsterSVGLib.getFrankensteinSVG();
        if (id == 3) return TragedyMonsterSVGLib.getDemonSVG();
        if (id == 4) return TragedyMonsterSVGLib.getDragonSVG();
        if (id == 5) return TragedyMonsterSVGLib.getZombieSVG();
        if (id == 6) return TragedyMonsterSVGLib.getVampireSVG();
        if (id == 7) return TragedyMonsterSVGLib.getMummySVG();
        if (id == 8) return TragedyMonsterSVGLib.getSuccubusSVG();
        if (id == 9) return TragedyMonsterSVGLib.getSkeletonSVG();
        revert("Invalid species ID");
    }
}