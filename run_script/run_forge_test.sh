#/bin/bash
RPC=https://polygon.llamarpc.com


# forge test --fork-url $RPC -vvv --gas-report
forge test --fork-url $RPC


# For specific test fils
# forge test --match-path test/foundry/Achilles.t.sol -vvv
