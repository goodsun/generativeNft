// SPDX-License-Identifier: MIT
// Auto-generated from effect/confusion.svg
pragma solidity ^0.8.20;

library TragedyConfusionLib {
    function getSVG() internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<svg viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\"><defs><filter id=\"pixelate\"><feFlood x=\"0\" y=\"0\" width=\"1\" height=\"1\" flood-color=\"#FFE66D\"/><feComposite in2=\"SourceGraphic\" operator=\"over\"/></filter></defs><g><rect x=\"0\" y=\"0\" width=\"24\" height=\"24\" fill=\"url(#rainbow)\"><animate attributeName=\"opacity\" values=\"0.1;0.3;0.1\" dur=\"4s\" repeatCount=\"indefinite\"/></rect><defs><linearGradient id=\"rainbow\"><stop offset=\"0%\" stop-color=\"red\"><animate attributeName=\"stop-color\" values=\"red;yellow;green;cyan;blue;magenta;red\" dur=\"6s\" repeatCount=\"indefinite\"/></stop><stop offset=\"50%\" stop-color=\"green\"><animate attributeName=\"stop-color\" values=\"green;cyan;blue;magenta;red;yellow;green\" dur=\"6s\" repeatCount=\"indefinite\"/></stop><stop offset=\"100%\" stop-color=\"blue\"><animate attributeNa',
            'me=\"stop-color\" values=\"blue;magenta;red;yellow;green;cyan;blue\" dur=\"6s\" repeatCount=\"indefinite\"/></stop></linearGradient></defs></g></svg>'
        ));
    }
}