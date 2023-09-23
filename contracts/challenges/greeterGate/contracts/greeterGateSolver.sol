// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Gate} from "./greeterGate.sol";

contract GateSolver {
    constructor(address gate, bytes32 data) {
        bytes memory resolveData = abi.encodeCall(
            Gate.unlock,
            (abi.encodePacked(data))
        );
        Gate(gate).resolve(resolveData);
    }
}
