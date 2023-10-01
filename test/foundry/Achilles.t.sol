// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SetUp, PancakePair, WETH, Achilles} from "contracts/challenges/Achilles/contracts/Setup.sol";
import {AchillesSolver} from "contracts/challenges/Achilles/contracts/AchillesSolver.sol";

// A: 思路
// 1. 令 pair amount 落差過大，可以呼叫 Airdrop(uint256 amount)
// 2. 產生 seed 再轉帳的時候，把 airdrop 的錢轉到 yourAddress 上

contract AchillesTest is Test {
    SetUp public challenge;
    PancakePair public pair;
    WETH public weth;
    AchillesSolver public solver;
    Achilles public achilles;

    address public user;
    address public someone;

    function setUp() public {
        user = makeAddr("user");
        someone = makeAddr("someone");
        challenge = new SetUp();

        vm.expectRevert();
        challenge.isSolved();
        pair = challenge.pair();
        weth = challenge.weth();
        achilles = challenge.achilles();
        solver = new AchillesSolver(address(challenge));

        console.log("yourAddress", challenge.yourAddress());
        console.log("pair", address(challenge.pair()));
        console.log("weth", address(challenge.weth()));
        console.log("achilles", address(challenge.achilles()));
    }

    function testSolveAchilles() public {
        vm.startPrank(user);
        solver.solve();
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
