const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Generated SVG Libraries Test", function () {
    it("Should compile and return valid SVG from TragedyMeteorLib", async function () {
        // Deploy a test contract that uses the library
        const TestContract = await ethers.getContractFactory("TestMeteorSVG");
        const test = await TestContract.deploy();
        await test.deployed();
        
        const svg = await test.getSVG();
        
        // Check that it returns a string
        expect(svg).to.be.a('string');
        
        // Check that it contains SVG elements
        expect(svg).to.include('<svg');
        expect(svg).to.include('</svg>');
        
        // Check that Unicode was properly escaped
        expect(svg).to.include('\u2605'); // ★ character
        
        console.log("SVG length:", svg.length);
        console.log("First 200 chars:", svg.substring(0, 200));
    });
});

// Test contract
const testContractCode = `
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../contracts/layer4/generated/effect/TragedyMeteorLib.sol";

contract TestMeteorSVG {
    function getSVG() external pure returns (string memory) {
        return TragedyMeteorLib.getSVG();
    }
}
`;