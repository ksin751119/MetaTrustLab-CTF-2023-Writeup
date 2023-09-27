#/bin/bash
RPC=https://polygon.llamarpc.com


# forge test --fork-url $RPC -vvv --gas-report
forge test --fork-url $RPC


# For specific test fils
# forge test --fork-url $RPC --fork-block-number $BLOCK --match-path test/fees/FG.t.sol  --gas-report
# forge test --fork-url $RPC  --match-path test/foundry/greeterGate.t.sol -vvv



# For specific test cases
# forge test --fork-url $RPC --match-test  testUpgradeToAndCallCallByEP -vvv
