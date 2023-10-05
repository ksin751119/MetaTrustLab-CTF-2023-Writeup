// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Foo} from "contracts/challenges/Foo/contracts/Foo.sol";
import {FooSolverGenerator} from "contracts/challenges/Foo/contracts/FooSolver.sol";

contract FooTest is Test {
    Foo public challenge;

    address public user;
    address public someone;

    function setUp() public {
        user = makeAddr("user");
        someone = makeAddr("someone");
        challenge = new Foo();
        assertFalse(challenge.isSolved());
    }

    function testSolveFoo() public {
        // Create solver by using create2

        vm.startPrank(user);
        new FooSolverGenerator(address(challenge));
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
