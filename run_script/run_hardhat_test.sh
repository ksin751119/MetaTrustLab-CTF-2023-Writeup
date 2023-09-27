#/bin/bash

RPC=https://polygon.llamarpc.com

# RPC=$RPC npx hardhat test test/Lock.test.ts
RPC=$RPC npx hardhat test test/bytecodeVault.test.ts
