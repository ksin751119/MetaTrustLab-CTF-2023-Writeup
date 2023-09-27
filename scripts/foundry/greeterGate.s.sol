// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Gate as SetUp} from "../challenges/greeterGate/contracts/greeterGate.sol";
import {GateSolver} from "../challenges/greeterGate/contracts/greeterGateSolver.sol";

contract greeterGateScript is Script {
    SetUp public challenge = SetUp(0xFCDBe88965589C7724f8E1Da3a08B1B651cD5Fb7);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // console2.logBytes32(vm.load(address(challenge), bytes32(uint256(3))));
        // console2.logBytes32(vm.load(address(challenge), bytes32(uint256(4))));
        // console2.logBytes32(vm.load(address(challenge), bytes32(uint256(5))));

        vm.startBroadcast(deployerPrivateKey);
        bytes32 data = vm.load(address(challenge), bytes32(uint256(5)));
        new GateSolver(address(challenge), data);
        vm.stopBroadcast();
    }
}
