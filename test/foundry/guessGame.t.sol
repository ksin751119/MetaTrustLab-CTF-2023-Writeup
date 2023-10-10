// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SetUp, GuessGame, A} from "contracts/challenges/guessgame/contracts/A.sol";
import {GuessGameSolver} from "contracts/challenges/guessgame/contracts/guessGameSolver.sol";

contract GuessGameTest is Test {
    SetUp public challenge;
    GuessGame public game;
    A public a;
    GuessGameSolver public solver;

    address public user;
    address public owner;
    address public yourAddress;

    function setUp() public {
        user = makeAddr("user");
        vm.deal(user, 200 ether);
        owner = makeAddr("owner");

        vm.prank(owner);
        challenge = new SetUp();
        assertFalse(challenge.isSolved());

        solver = new GuessGameSolver(address(challenge));
    }

    function testSolveGuessGame() public {
        vm.startPrank(user);
        solver.solve{value: 1}();
        solver.solve{value: 1}();
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
