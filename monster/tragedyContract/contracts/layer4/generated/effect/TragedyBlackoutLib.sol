// SPDX-License-Identifier: MIT
// Auto-generated from effect/blackout.svg
pragma solidity ^0.8.20;

library TragedyBlackoutLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\"><g><defs><mask id=\"iris-mask\"><rect x=\"0\" y=\"0\" width=\"24\" height=\"24\" fill=\"white\"/><circle cx=\"1.2\" cy=\"1.2\" r=\"20\" fill=\"black\"><animate attributeName=\"r\" values=\"20;0;0;0;0;20\" dur=\"4.2s\" repeatCount=\"indefinite\" keyTimes=\"0;0.714;0.714;0.952;0.952;1\"/></circle></mask></defs><g><rect x=\"0\" y=\"0\" width=\"24\" height=\"24\" fill=\"#000000\" mask=\"url(#iris-mask)\"/></g></g></svg>'
        ));
    }
}