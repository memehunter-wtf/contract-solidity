// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./2_pair.sol";

contract PairFactory {

    constructor()
    {}

    event PairCreated(address indexed tokenAddress, address indexed pairAddress);
    function createPair(
        // address wethAddress,
        address tokenAddress,
        uint256 wethAmount,
        uint256 tokenAmount
    ) public {
        Pair pair = new Pair(
            // wethAddress,
            tokenAddress,
            wethAmount,
            tokenAmount
        );
        pair.transferOwnership(msg.sender);

        emit PairCreated(tokenAddress, address(pair));
    }

}

// 0x4200000000000000000000000000000000000006
// 0xA5eBc251e9f8501756346ED50a0d7b043dBd2ea0
// 1000000000000000000 -> 1251000000000000
// 1000000000000000000000000000