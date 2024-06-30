// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "./Token.sol";

contract TokenFactory {

    uint256 public constant DECIMALS = 10 ** 18;
    uint256 public constant MAX_SUPPLY = (10 ** 9) * DECIMALS;
    uint256 public constant INITIAL_MINT = MAX_SUPPLY * 20 / 100;

    mapping(address => bool) public tokens;

    function createToken(string memory name, string memory ticker) public returns (address){
        Token token = new Token(name, ticker, INITIAL_MINT);
        tokens[address(token)] = true;
        return address(token);
    }
}
