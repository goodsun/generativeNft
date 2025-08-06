// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TragedyMonsterSVGLib
 * @notice Library for monster SVG generation
 */
library TragedyMonsterSVGLib {
    
    function getWerewolfSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="werewolf">',
            '<rect x="10" y="6" width="4" height="6" fill="#4B4B4B"/>', // body
            '<rect x="9" y="4" width="6" height="3" fill="#4B4B4B"/>', // head
            '<rect x="8" y="2" width="2" height="3" fill="#4B4B4B"/>', // left ear
            '<rect x="14" y="2" width="2" height="3" fill="#4B4B4B"/>', // right ear
            '<rect x="10" y="5" width="1" height="1" fill="#FF0000"/>', // left eye
            '<rect x="13" y="5" width="1" height="1" fill="#FF0000"/>', // right eye
            '<rect x="9" y="12" width="2" height="2" fill="#4B4B4B"/>', // left leg
            '<rect x="13" y="12" width="2" height="2" fill="#4B4B4B"/>', // right leg
            '</g>'
        ));
    }
    
    function getGoblinSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="goblin">',
            '<rect x="10" y="8" width="4" height="4" fill="#2F7D32"/>', // body
            '<rect x="9" y="6" width="6" height="3" fill="#2F7D32"/>', // head
            '<rect x="8" y="5" width="2" height="2" fill="#2F7D32"/>', // left ear
            '<rect x="14" y="5" width="2" height="2" fill="#2F7D32"/>', // right ear
            '<rect x="10" y="7" width="1" height="1" fill="#000"/>', // left eye
            '<rect x="13" y="7" width="1" height="1" fill="#000"/>', // right eye
            '<rect x="10" y="12" width="2" height="2" fill="#2F7D32"/>', // left leg
            '<rect x="12" y="12" width="2" height="2" fill="#2F7D32"/>', // right leg
            '</g>'
        ));
    }
    
    function getFrankensteinSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="frankenstein">',
            '<rect x="9" y="6" width="6" height="6" fill="#7CB342"/>', // body
            '<rect x="9" y="3" width="6" height="4" fill="#7CB342"/>', // head
            '<rect x="8" y="2" width="1" height="1" fill="#666"/>', // bolt left
            '<rect x="15" y="2" width="1" height="1" fill="#666"/>', // bolt right
            '<rect x="10" y="4" width="1" height="1" fill="#000"/>', // left eye
            '<rect x="13" y="4" width="1" height="1" fill="#000"/>', // right eye
            '<rect x="10" y="12" width="2" height="2" fill="#7CB342"/>', // left leg
            '<rect x="12" y="12" width="2" height="2" fill="#7CB342"/>', // right leg
            '</g>'
        ));
    }
    
    function getDemonSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="demon">',
            '<rect x="8" y="6" width="8" height="4" fill="#8B0000"/>', // body
            '<rect x="7" y="4" width="2" height="2" fill="#FF0000"/>', // left horn
            '<rect x="15" y="4" width="2" height="2" fill="#FF0000"/>', // right horn
            '<rect x="10" y="7" width="1" height="1" fill="#000"/>', // left eye
            '<rect x="13" y="7" width="1" height="1" fill="#000"/>', // right eye
            '<rect x="9" y="10" width="6" height="2" fill="#8B0000"/>', // lower body
            '<rect x="10" y="12" width="2" height="2" fill="#8B0000"/>', // left foot
            '<rect x="12" y="12" width="2" height="2" fill="#8B0000"/>', // right foot
            '</g>'
        ));
    }
    
    function getDragonSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="dragon">',
            '<rect x="6" y="8" width="12" height="4" fill="#4A148C"/>', // body
            '<polygon points="8,6 16,6 12,3" fill="#4A148C"/>', // head
            '<rect x="4" y="7" width="3" height="4" fill="#7B1FA2"/>', // left wing
            '<rect x="17" y="7" width="3" height="4" fill="#7B1FA2"/>', // right wing
            '<rect x="10" y="4" width="1" height="1" fill="#FF0000"/>', // left eye
            '<rect x="13" y="4" width="1" height="1" fill="#FF0000"/>', // right eye
            '<rect x="10" y="12" width="4" height="2" fill="#4A148C"/>', // tail
            '</g>'
        ));
    }
    
    function getZombieSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="zombie">',
            _getZombieHead(),
            _getZombieBody(),
            '</g>'
        ));
    }
    
    function _getZombieHead() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="7" y="4" width="10" height="9" fill="#556B2F"/>',
            '<rect x="6" y="5" width="1" height="7" fill="#556B2F"/>',
            '<rect x="17" y="5" width="1" height="7" fill="#556B2F"/>',
            '<rect x="9" y="5" width="2" height="2" fill="#3E5F1B"/>',
            '<rect x="15" y="7" width="2" height="2" fill="#3E5F1B"/>',
            '<rect x="8" y="8" width="2" height="2" fill="#DC143C"/>',
            '<rect x="14" y="8" width="2" height="2" fill="#DC143C"/>',
            '<rect x="9" y="11" width="6" height="1" fill="#000"/>',
            '<rect x="10" y="12" width="1" height="1" fill="#FFF"/>',
            '<rect x="12" y="12" width="1" height="1" fill="#FFF"/>',
            '<rect x="14" y="12" width="1" height="1" fill="#FFF"/>'
        ));
    }
    
    function _getZombieBody() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="6" y="13" width="12" height="7" fill="#556B2F"/>',
            '<rect x="7" y="14" width="3" height="3" fill="#4B0082"/>',
            '<rect x="14" y="15" width="3" height="2" fill="#4B0082"/>',
            '<rect x="3" y="14" width="2" height="4" fill="#556B2F"/>',
            '<rect x="19" y="14" width="2" height="4" fill="#556B2F"/>',
            '<rect x="7" y="20" width="3" height="2" fill="#556B2F"/>',
            '<rect x="14" y="20" width="3" height="2" fill="#556B2F"/>'
        ));
    }
    
    function getVampireSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="vampire">',
            _getVampireHead(),
            _getVampireBody(),
            '</g>'
        ));
    }
    
    function _getVampireHead() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="6" y="2" width="12" height="3" fill="#000"/>',
            '<rect x="5" y="3" width="1" height="2" fill="#000"/>',
            '<rect x="18" y="3" width="1" height="2" fill="#000"/>',
            '<rect x="6" y="5" width="12" height="8" fill="#D3D3D3"/>',
            '<rect x="5" y="6" width="1" height="6" fill="#D3D3D3"/>',
            '<rect x="18" y="6" width="1" height="6" fill="#D3D3D3"/>',
            '<rect x="8" y="7" width="2" height="2" fill="#DC143C"/>',
            '<rect x="14" y="7" width="2" height="2" fill="#DC143C"/>',
            '<rect x="9" y="10" width="6" height="1" fill="#000"/>',
            '<rect x="9" y="11" width="1" height="2" fill="#FFF"/>',
            '<rect x="14" y="11" width="1" height="2" fill="#FFF"/>'
        ));
    }
    
    function _getVampireBody() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="4" y="12" width="16" height="2" fill="#4B0000"/>',
            '<rect x="7" y="14" width="10" height="5" fill="#000"/>',
            '<rect x="5" y="14" width="1" height="6" fill="#4B0000"/>',
            '<rect x="18" y="14" width="1" height="6" fill="#4B0000"/>',
            '<rect x="4" y="15" width="1" height="5" fill="#4B0000"/>',
            '<rect x="19" y="15" width="1" height="5" fill="#4B0000"/>',
            '<rect x="8" y="19" width="3" height="3" fill="#000"/>',
            '<rect x="13" y="19" width="3" height="3" fill="#000"/>'
        ));
    }
    
    function getMummySVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="mummy">',
            _getMummyHead(),
            _getMummyBody(),
            '</g>'
        ));
    }
    
    function _getMummyHead() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="7" y="3" width="10" height="9" fill="#F5DEB3"/>',
            '<rect x="6" y="4" width="1" height="7" fill="#F5DEB3"/>',
            '<rect x="17" y="4" width="1" height="7" fill="#F5DEB3"/>',
            '<rect x="7" y="5" width="10" height="1" fill="#D2B48C"/>',
            '<rect x="7" y="8" width="10" height="1" fill="#D2B48C"/>',
            '<rect x="7" y="11" width="10" height="1" fill="#D2B48C"/>',
            '<rect x="9" y="6" width="2" height="2" fill="#000"/>',
            '<rect x="13" y="6" width="2" height="2" fill="#000"/>'
        ));
    }
    
    function _getMummyBody() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="6" y="12" width="12" height="8" fill="#F5DEB3"/>',
            '<rect x="5" y="13" width="1" height="6" fill="#F5DEB3"/>',
            '<rect x="18" y="13" width="1" height="6" fill="#F5DEB3"/>',
            '<rect x="6" y="14" width="12" height="1" fill="#D2B48C"/>',
            '<rect x="6" y="17" width="12" height="1" fill="#D2B48C"/>',
            '<rect x="3" y="13" width="2" height="5" fill="#F5DEB3"/>',
            '<rect x="19" y="13" width="2" height="5" fill="#F5DEB3"/>',
            '<rect x="3" y="15" width="2" height="1" fill="#D2B48C"/>',
            '<rect x="19" y="15" width="2" height="1" fill="#D2B48C"/>',
            '<rect x="2" y="14" width="1" height="2" fill="#F5DEB3"/>',
            '<rect x="21" y="16" width="1" height="2" fill="#F5DEB3"/>',
            '<rect x="7" y="20" width="3" height="2" fill="#F5DEB3"/>',
            '<rect x="14" y="20" width="3" height="2" fill="#F5DEB3"/>'
        ));
    }
    
    function getSuccubusSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="succubus">',
            _getSuccubusHead(),
            _getSuccubusBody(),
            '</g>'
        ));
    }
    
    function _getSuccubusHead() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Horns
            '<rect x="8" y="2" width="1" height="1" fill="#8B0000"/>',
            '<rect x="15" y="2" width="1" height="1" fill="#8B0000"/>',
            '<rect x="7" y="3" width="2" height="1" fill="#DC143C"/>',
            '<rect x="15" y="3" width="2" height="1" fill="#DC143C"/>',
            // Hair
            '<rect x="6" y="4" width="12" height="2" fill="#4B0082"/>',
            '<rect x="5" y="5" width="1" height="9" fill="#4B0082"/>',
            '<rect x="18" y="5" width="1" height="8" fill="#4B0082"/>',
            // Face
            '<rect x="7" y="6" width="1" height="7" fill="#FFE4E1"/>',
            '<rect x="11" y="6" width="1" height="4" fill="#FFE4E1"/>',
            '<rect x="16" y="7" width="1" height="5" fill="#FFE4E1"/>',
            // Eyes
            '<rect x="8" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="10" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="13" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="15" y="8" width="1" height="2" fill="#8B0000"/>',
            '<rect x="9" y="8" width="1" height="1" fill="#FFF"/>',
            '<rect x="14" y="8" width="1" height="1" fill="#FFF"/>'
        ));
    }
    
    function _getSuccubusBody() private pure returns (string memory) {
        return string(abi.encodePacked(
            // Upper body
            '<rect x="10" y="11" width="2" height="1" fill="#DC143C"/>',
            '<rect x="10" y="12" width="5" height="1" fill="#FFE4E1"/>',
            // Dress
            '<rect x="9" y="14" width="5" height="3" fill="#8B0000"/>',
            '<rect x="8" y="15" width="1" height="2" fill="#8B0000"/>',
            '<rect x="14" y="15" width="1" height="2" fill="#8B0000"/>',
            // Wings
            '<rect x="3" y="13" width="2" height="4" fill="#4B0000"/>',
            '<rect x="18" y="13" width="3" height="3" fill="#4B0000"/>',
            // Legs
            '<rect x="8" y="17" width="1" height="5" fill="#FFE4E1"/>',
            '<rect x="9" y="19" width="1" height="4" fill="#FFE4E1"/>',
            '<rect x="13" y="19" width="2" height="1" fill="#FFE4E1"/>',
            '<rect x="13" y="20" width="1" height="3" fill="#FFE4E1"/>'
        ));
    }
    
    function getSkeletonSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<g id="skeleton">',
            _getSkeletonHead(),
            _getSkeletonBody(),
            '</g>'
        ));
    }
    
    function _getSkeletonHead() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="8" y="2" width="8" height="2" fill="#E8E8E8"/>',
            '<rect x="7" y="4" width="10" height="3" fill="#E8E8E8"/>',
            '<rect x="6" y="6" width="12" height="3" fill="#E8E8E8"/>',
            '<rect x="7" y="9" width="10" height="2" fill="#E8E8E8"/>',
            '<rect x="8" y="5" width="3" height="3" fill="#1C1C1C"/>',
            '<rect x="13" y="5" width="3" height="3" fill="#1C1C1C"/>',
            '<rect x="9" y="6" width="1" height="1" fill="#FF6B6B"/>',
            '<rect x="14" y="6" width="1" height="1" fill="#FF6B6B"/>',
            '<rect x="11" y="7" width="2" height="2" fill="#1C1C1C"/>',
            '<rect x="8" y="10" width="8" height="1" fill="#D3D3D3"/>',
            '<rect x="8" y="9" width="1" height="2" fill="#F5F5F5"/>',
            '<rect x="10" y="9" width="1" height="2" fill="#F5F5F5"/>',
            '<rect x="12" y="9" width="1" height="2" fill="#F5F5F5"/>',
            '<rect x="14" y="9" width="1" height="2" fill="#F5F5F5"/>'
        ));
    }
    
    function _getSkeletonBody() private pure returns (string memory) {
        return string(abi.encodePacked(
            '<rect x="7" y="13" width="10" height="1" fill="#E8E8E8"/>',
            '<rect x="6" y="14" width="12" height="1" fill="#D3D3D3"/>',
            '<rect x="7" y="15" width="10" height="1" fill="#E8E8E8"/>',
            '<rect x="8" y="16" width="8" height="1" fill="#D3D3D3"/>',
            '<rect x="11" y="13" width="2" height="6" fill="#F5F5F5"/>',
            '<rect x="4" y="13" width="3" height="2" fill="#E8E8E8"/>',
            '<rect x="17" y="13" width="3" height="2" fill="#E8E8E8"/>',
            '<rect x="3" y="15" width="2" height="4" fill="#D3D3D3"/>',
            '<rect x="19" y="15" width="2" height="4" fill="#D3D3D3"/>',
            '<rect x="9" y="20" width="2" height="2" fill="#E8E8E8"/>',
            '<rect x="13" y="20" width="2" height="2" fill="#E8E8E8"/>'
        ));
    }
}