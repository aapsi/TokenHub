// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";

contract CounterTest is Test {
    TokenFactory public factory;

    function setUp() public {
        factory = new TokenFactory();
    }

    function test_CreateToken() public {
        string memory name = "Test Token";
        string memory ticker = "TT";
        address tokenAddress = factory.createToken(name, ticker);
        Token token = Token(tokenAddress);
        uint256 totalSupply = token.totalSupply();

        assertEq(token.balanceOf(address(factory)), factory.INITIAL_MINT(), "Balance of creator not equal to initial mint");
        assertEq(totalSupply, factory.INITIAL_MINT(), "Total supply not equal to initial mint");
        // assertEq(factory.tokens(tokenAddress), true, "Token address not found on factory");
    }

    function test_calculateRequiredEth() public {
        string memory name = "Test Token";
        string memory ticker = "TT";
        address tokenAddress = factory.createToken(name, ticker);
        Token token = Token(tokenAddress);
        uint256 totalBuyableSupply = factory.MAX_SUPPLY()  - token.totalSupply() ;
        uint256 requiredEth = factory.calculateRequiredEth(tokenAddress, totalBuyableSupply);

        // Expected value calculated manually
        uint256 expectedEth = 30 * 10 ** 18;
        
        console.log("Required ETH: ", requiredEth);
        console.log("Expected ETH: ", expectedEth);

        assertEq(requiredEth, expectedEth, "Required eth not equal to 30 ETH");
    }

    function test_calculateRequiredEth2() public {
        string memory name = "Test Token";
        string memory ticker = "TT";
        address tokenAddress = factory.createToken(name, ticker);
        Token token = Token(tokenAddress);
        uint256 totalBuyableSupply = factory.MAX_SUPPLY()  - token.totalSupply() ;
        uint256 requiredEth = factory.calculateRequiredEth(tokenAddress, totalBuyableSupply);

        // Expected value calculated manually
        uint256 expectedEth = 30 * 10 ** 18;
        
        console.log("Required ETH: ", requiredEth);
        console.log("Expected ETH: ", expectedEth);

        assertEq(requiredEth, expectedEth, "Required eth not equal to 30 ETH");
    }
}
