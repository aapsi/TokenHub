// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "./Token.sol";
import "dependencies/@uniswap-v2-core-1.0.1/contracts/interfaces/IUniswapV2Factory.sol";
import "dependencies/@uniswap-v2-periphery-1.1.0-beta.0/contracts/interfaces/IUniswapV2Router02.sol";

contract TokenFactory {

    uint256 public constant DECIMALS = 10 ** 18;
    uint256 public constant MAX_SUPPLY = (10 ** 9) * DECIMALS;
    uint256 public constant INITIAL_MINT = MAX_SUPPLY * 20 / 100;
    uint256 public constant k = 46875 ;
    uint256 public constant offset = 18750000000000000000000000000000;
    uint256 public constant SCALING_FACTOR = 10 ** 39;

    uint256 public constant FUNDING_GOAL = 30 ether;
    address public constant UNISWAP_FACTORY_ADDRESS = 0xB7f907f7A9eBC822a80BD25E224be42Ce0A698A0;
    address public constant UNISWAP_ROUTER_ADDRESS = 0x425141165d3DE9FEC831896C016617a52363b687;

    mapping(address => bool) public tokens;
    mapping(address => uint256) public collateral;
    mapping(address => mapping(address => uint256)) public balances;

    function createToken(string memory name, string memory ticker) public returns (address){
        Token token = new Token(name, ticker, INITIAL_MINT);
        tokens[address(token)] = true;
        return address(token);
    }

    function buy(address tokenAddress, uint256 amount) external payable {
        require(tokens[tokenAddress] == true , "Token not found");
        Token token = Token(tokenAddress);
        uint256 availableSupply = MAX_SUPPLY - INITIAL_MINT - token.totalSupply();
        require(availableSupply >= amount, "Not enough supply");

        // calculate required amount of ether to buy
        uint requiredEth = calculateRequiredEth(tokenAddress, amount);
        require(msg.value >= requiredEth, "Not enough ether");  
        collateral[tokenAddress] += requiredEth;
        balances[tokenAddress][msg.sender] += amount; // token balances for people who bought tokens not released yet
        token.mint(address(this), amount);

        if(collateral[tokenAddress] >= FUNDING_GOAL){
            // create Liquidity Pool
            // provide liquidity
            // burn liquidity tokens
        }

    }

    // This function calculates the required ETH using a trapezoidal rule approximation.
    function calculateRequiredEth(address tokenAddress, uint256 amount) public view returns (uint256){
        // Declare the token interface
        Token token = Token(tokenAddress);

        // Calculate the new and old total supplies
        uint256 a = token.totalSupply() - INITIAL_MINT; // Old total supply (initial state)
        uint256 b = a + amount; // New total supply after adding the specified amount

        // Calculate the function values at points a and b
        uint256 f_a = k * a + offset;
        uint256 f_b = k * b + offset;

        // Apply the trapezoidal rule
        // amount_eth = (b - a) * (f(a) + f(b)) / 2
        // The result is scaled by SCALING_FACTOR to maintain precision in integer arithmetic
        return (b - a) * (f_a + f_b) / (2 * SCALING_FACTOR);
    }

    function createLiquidityPool(address tokenAddress) external returns (address){
        require(collateral[tokenAddress] >= FUNDING_GOAL, "Not enough collateral");
        Token token = Token(tokenAddress);
        // create liquidity pool
        // provide liquidity
        // burn liquidity tokens
        IUniswapV2Factory factory = IUniswapV2Factory(UNISWAP_FACTORY_ADDRESS);
        IUniswapV2Router02 router = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        address pair = factory.createPair(tokenAddress, router.WETH());
        return pair;
    }

}
