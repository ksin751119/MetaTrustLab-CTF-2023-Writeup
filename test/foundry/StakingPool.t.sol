// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {StakingPoolsDeployment, StakingPools, ERC20} from "contracts/challenges/StakingPool/contracts/StakingPoolsDeployment.sol";
import {StakingPoolsSolver} from "contracts/challenges/StakingPool/contracts/StakingPoolsSolver.sol";

contract StakingPoolTest is Test {
    StakingPoolsDeployment public challenge;
    StakingPools public stakingPool;
    StakingPoolsSolver public solver;
    ERC20 public stakedToken;

    address public user;
    address public owner;

    function setUp() public {
        user = makeAddr("user");
        owner = makeAddr("owner");
        vm.prank(owner);
        challenge = new StakingPoolsDeployment();

        stakingPool = challenge.stakingPools();
        stakedToken = challenge.stakedToken();
        assertFalse(challenge.isSolved());
    }

    function testSolveStakingPool() public {
        vm.startPrank(user);

        // Deposit and wait for reward
        challenge.faucet();
        stakedToken.approve(address(stakingPool), type(uint256).max);
        stakingPool.deposit(stakedToken.balanceOf(user));
        vm.roll(block.number + 20);

        solver = new StakingPoolsSolver(address(challenge));
        stakingPool.transfer(address(solver), stakingPool.balanceOf(user));
        solver.solve();

        vm.stopPrank();
        assertTrue(challenge.isSolved());
    }
}
