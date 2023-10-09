// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeFiPlatform, Vault, SetUp} from "contracts/challenges/DefiMaze/contracts/Setup.sol";

contract DefiMazeTest is Test {
    SetUp public challenge;
    DeFiPlatform public platform;
    Vault public vault;

    address public user;
    address public owner;
    address public yourAddress;

    function setUp() public {
        user = makeAddr("user");
        vm.deal(user, 100 ether);
        owner = makeAddr("owner");

        vm.prank(owner);
        challenge = new SetUp();
        assertFalse(challenge.isSolved());

        platform = challenge.platfrom();
        vault = challenge.vault();
        yourAddress = challenge.yourAddress();
    }

    function testSolveDefiMaze() public {
        vm.startPrank(user);
        uint256 amount = 7 ether;
        platform.depositFunds{value: amount}(amount);
        platform.calculateYield(1, 1, 1);
        platform.requestWithdrawal(amount);
        vault.isSolved();
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
