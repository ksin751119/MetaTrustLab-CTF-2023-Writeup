// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ByteDance} from "contracts/challenges/byteDance/contracts/byteDance.sol";

contract ByteDanceTest is Test {
    ByteDance public challenge;

    address public user;
    address public owner;
    address public yourAddress;

    function setUp() public {
        user = makeAddr("user");
        vm.deal(user, 200 ether);
        owner = makeAddr("owner");
        vm.prank(owner);
        challenge = new ByteDance();
        assertFalse(challenge.isSolved());

        vm.prank(user);
    }

    function testSolveByteDance() public {
        vm.startPrank(user);
        yourAddress = deploy(_generateBytecode());
        challenge.checkCode(yourAddress);
        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }

    function deploy(bytes memory _code) public payable returns (address addr) {
        assembly {
            // create(v, p, n)
            // v = amount of ETH to send
            // p = pointer in memory to start of code
            // n = size of code
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        // return address 0 on error
        require(addr != address(0), "deploy failed");
    }

    function _generateBytecode() internal returns (bytes memory) {
        // Deploy code
        // PUSH32 0x6101015f555f5ff3ff0000000000000000000000000000000000000000000000
        // PUSH1 0x00
        // MSTORE
        // PUSH1 0x09 // code length in memory
        // PUSH1 0x00 // code start in memory
        // RETURN

        // Execution code (0x6101015f555f5ff3ff)
        // PUSH2 0x0101
        // PUSH0
        // SSTORE
        // PUSH0
        // PUSH0
        // RETURN
        // SELFDESTRUCT

        return
            hex"7f6101015f555f5ff3ff000000000000000000000000000000000000000000000060005260096000f3";
    }
}
