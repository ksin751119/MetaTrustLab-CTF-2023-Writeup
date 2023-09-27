//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBytecodeVault {
    function withdraw() external;

    function isSolved() external view returns (bool);
}

contract BytecodeVaultSolver {
    address public owner;

    address public constant vault = 0xDDdDddDdDdddDDddDDddDDDDdDdDDdDDdDDDDDDd; // fake vault

    function solve() public {
        IBytecodeVault(vault).withdraw();
    }

    receive() external payable {}
}
