// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "dependencies/@openzeppelin-contracts-5.0.2/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory ticker, uint256 initialMint) ERC20(name, ticker) {
        _mint(msg.sender, initialMint);
    }
}