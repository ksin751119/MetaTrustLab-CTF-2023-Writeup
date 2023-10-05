// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Foo} from "./Foo.sol";

contract FooSolverGenerator {
    constructor(address foo) {
        uint256 salt;
        FooSolver solver;
        while (true) {
            address solverAddress = calcSolverAddress(salt, foo);
            if (uint256(uint160(solverAddress)) % 1000 == 137) {
                solver = new FooSolver{salt: bytes32(salt)}(foo);
                break;
            }
            ++salt;
        }
        solver.solve();
    }

    function calcSolverAddress(
        uint256 salt,
        address foo
    ) internal view returns (address) {
        address result = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            bytes32(salt),
                            keccak256(
                                abi.encodePacked(
                                    type(FooSolver).creationCode,
                                    abi.encode(foo)
                                )
                            )
                        )
                    )
                )
            )
        );
        return result;
    }
}

contract FooSolver {
    Foo public foo;
    uint256 private _flag;
    uint256[] private answers;

    constructor(address foo_) {
        foo = Foo(foo_);
    }

    function solve() external {
        foo.setup();
        foo.stage1();
        _solveStage2();
        _solveStage3();
        foo.stage4();

        require(foo.isSolved(), "Not solved");
    }

    function check() external view returns (bytes32) {
        uint256 startGas = gasleft();
        uint256 flag = _flag; // need to put storage to memory
        uint256 costGas = startGas - gasleft();
        flag;

        if (costGas >= 1000) {
            return keccak256(abi.encodePacked("1337"));
        } else {
            return keccak256(abi.encodePacked("13337"));
        }
    }

    function sort(uint256[] memory) external view returns (uint256[] memory) {
        return answers;
    }

    function pos() external view returns (bytes32) {
        return _getStatSlot(1, 4, address(this));
    }

    function _solveStage3() internal {
        uint[] memory challenge = new uint[](8);
        challenge[0] = (block.timestamp & 0xf0000000) >> 28;
        challenge[1] = (block.timestamp & 0xf000000) >> 24;
        challenge[2] = (block.timestamp & 0xf00000) >> 20;
        challenge[3] = (block.timestamp & 0xf0000) >> 16;
        challenge[4] = (block.timestamp & 0xf000) >> 12;
        challenge[5] = (block.timestamp & 0xf00) >> 8;
        challenge[6] = (block.timestamp & 0xf0) >> 4;
        challenge[7] = (block.timestamp & 0xf) >> 0;

        /* bubble sort */
        for (uint i = 0; i < 8; i++) {
            for (uint j = i + 1; j < 8; j++) {
                if (challenge[i] > challenge[j]) {
                    uint tmp = challenge[i];
                    challenge[i] = challenge[j];
                    challenge[j] = tmp;
                }
            }
        }
        answers = challenge;
        foo.stage3();
    }

    function _solveStage2() internal {
        for (uint256 i = 40300; i < 40500; i++) {
            (bool success, ) = address(foo).call{gas: i}(
                abi.encodeWithSignature("stage2()")
            );
            if (success) {
                break;
            }
        }
    }

    function _getStatSlot(
        uint256 layout,
        uint256 key1,
        address key2
    ) internal pure returns (bytes32) {
        return keccak256(abi.encode(key2, keccak256(abi.encode(key1, layout))));
    }
}
