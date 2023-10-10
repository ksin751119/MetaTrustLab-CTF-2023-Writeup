// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SetUp, GuessGame, A} from "./A.sol";
import "forge-std/console.sol";

contract GuessGameSolver {
    SetUp public setup;
    A public a;
    GuessGame public game;

    constructor(address setup_) {
        setup = SetUp(setup_);
        game = setup.guessGame();
    }

    function solve() external payable {
        uint256 random01 = 96; // 0x60;

        uint256 random02;
        while (true) {
            uint256 y = (uint160(address(this)) + 1 + 2 + 32 + random02) & 0xff;
            if (y == 2) break;
            ++random02;
        }

        uint256 random03 = uint256(uint160(address(2))); // Precompiled Contracts
        uint256 random04 = 10;

        game.guess{value: 1}(random01, random02, random03, random04);
    }

    fallback() external payable {}
}
