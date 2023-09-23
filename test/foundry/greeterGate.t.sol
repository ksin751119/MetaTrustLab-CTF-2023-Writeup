// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Gate as SetUp} from "contracts/challenges/greeterGate/contracts/greeterGate.sol";
import {GateSolver} from "contracts/challenges/greeterGate/contracts/greeterGateSolver.sol";

contract GreeterGateTest is Test {
    SetUp public challenge;

    address public user;
    address public someone;

    function setUp() public {
        user = makeAddr("user");
        someone = makeAddr("someone");

        challenge = new SetUp(
            bytes32(uint256(1)),
            bytes32(uint256(2)),
            bytes32(uint256(3))
        );
        assertFalse(challenge.isSolved());
    }

    function testSolveGreeterGate() public {
        bytes32 data = vm.load(address(challenge), bytes32(uint256(5)));
        vm.startPrank(user);
        new GateSolver(address(challenge), data);
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
