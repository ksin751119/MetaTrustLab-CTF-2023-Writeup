//SPDX-License-Identifier: MIT
pragma solidity ^0.5.11;

contract BytecodeVault {
    address public owner;

    constructor() public payable {
        owner = msg.sender;
    }

    modifier onlyBytecode() {
        require(msg.sender != tx.origin, "No high-level contracts allowed!");
        _;
    }

    function withdraw() external onlyBytecode {
        uint256 sequence = 0xdeadbeef;
        bytes memory senderCode;

        address bytecaller = msg.sender;

        assembly {
            let size := extcodesize(bytecaller) // 取得該 address 的 code size
            senderCode := mload(0x40) // 取得 free memory pointer 的位置
            mstore(
                0x40, // 更新 free memory pointer 的位置
                add(senderCode, and(add(add(size, 0x20), 0x1f), not(0x1f))) // 更新free memory pointer的位置。這個位置是當前的指標位置加上大小、32以及一個讓其與32位元對齊的數值。
                // 概念是加上一個進位的數字，再捨去。讓整個都對齊 32
            ) // 把後面的值放到 mem[p…(p+32)]
            mstore(senderCode, size) // 第一個 bytes
            extcodecopy(bytecaller, add(senderCode, 0x20), 0, size) // 存入 senderCode
        }

        require(senderCode.length % 2 == 1, "Bytecode length must be even!");

        for (uint256 i = 0; i < senderCode.length - 3; i++) {
            // 在合約後面加一個0xdeadbeef
            if (
                senderCode[i] == bytes1(uint8(sequence >> 24)) &&
                senderCode[i + 1] == bytes1(uint8((sequence >> 16) & 0xFF)) &&
                senderCode[i + 2] == bytes1(uint8((sequence >> 8) & 0xFF)) &&
                senderCode[i + 3] == bytes1(uint8(sequence & 0xFF))
            ) {
                msg.sender.transfer(address(this).balance);
                return;
            }
        }
        revert("Sequence not found!");
    }

    function isSolved() public view returns (bool) {
        return address(this).balance == 0;
    }
}
