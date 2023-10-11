// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NaryaRegistry, NaryaRegistrySolver} from "contracts/challenges/NaryaRegistry/contracts/NaryaRegistrySolver.sol";

contract NaryaRegistryTest is Test {
    NaryaRegistry public challenge;
    NaryaRegistrySolver solver;

    address public user;
    address public owner;
    address public yourAddress;

    function setUp() public {
        user = makeAddr("user");
        vm.deal(user, 200 ether);
        owner = makeAddr("owner");
        vm.prank(owner);
        challenge = new NaryaRegistry();

        vm.prank(user);
        solver = new NaryaRegistrySolver(address(challenge));

        assertFalse(challenge.isNaryaHacker(user));
    }

    function testSolveNaryaRegistry() public {
        vm.startPrank(user);
        solver.solve();
        vm.stopPrank();
        assertTrue(challenge.isNaryaHacker(address(solver)));
    }
}
