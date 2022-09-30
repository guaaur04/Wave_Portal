// SPDX License-Identifier: UNLICENSED 

pragma solidity ^0.8.0;

import "hardhat/console.sol"; 

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave (address indexed from, uint256 timestamp, string message);

    /* I create a struct named Wave wherein we can customize what data we hold. 
    */

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /* Array of structs
    */

    Wave[] waves;

    /*
    *This is an address => uint mapping, meaning I can associate a number with an number!
    *In this case, I'll be storing the address with the last time the user waved at us. 
    */

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        require(
            /*
            *We need to make sure the current timestamp is at least 30 seconds than the last.
            */
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

    /* Here we store the wave data in an array.
    */

        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                 prizeAmount <= address(this).balance,
                 "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");

        }

        emit NewWave(msg.sender, block.timestamp, _message);

    }

    /*
    Adding a function getAllWaves which will return the struct array, waves. 
    */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves; 
    }

}
