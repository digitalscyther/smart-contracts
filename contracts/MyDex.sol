// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX is ReentrancyGuard {
    address public token1;
    address public token2;
    uint public reserve1;
    uint public reserve2;
    uint public fee;

    struct LiquidityUnit {
        uint reserve1;
        uint reserve2;
    }

    mapping(address => LiquidityUnit) internal liquidityMembers;

    event LiquidityAdded(address indexed provider, uint amount1, uint amount2);
    event LiquidityRemoved(address indexed provider, uint amount1, uint amount2);
    event SwapExecuted(address indexed user, address indexed tokenIn, uint amountIn, address indexed tokenOut, uint amountOut);

    constructor(address _token1, address _token2, uint _fee) {
        require(_fee <= 10000, "fee should be smaller than 10000");

        token1 = _token1;
        token2 = _token2;
        fee = _fee;
    }

    function addLiquidity(uint amount1, uint amount2) public nonReentrant {
        require(amount1 > 0 && amount2 > 0, "Amounts must be greater than 0");
        
        reserve1 += amount1;
        reserve2 += amount2;
        
        liquidityMembers[msg.sender].reserve1 += amount1;
        liquidityMembers[msg.sender].reserve2 += amount2;

        require(
            IERC20(token1).transferFrom(msg.sender, address(this), amount1),
            "Transfer of token1 failed"
        );
        require(
            IERC20(token2).transferFrom(msg.sender, address(this), amount2),
            "Transfer of token2 failed"
        );

        emit LiquidityAdded(msg.sender, amount1, amount2);
    }

    function removeLiquidity(uint amount1, uint amount2) public nonReentrant {
        LiquidityUnit storage liquidityUnit = liquidityMembers[msg.sender];

        require(liquidityUnit.reserve1 >= amount1 && liquidityUnit.reserve2 >= amount2, "An attempt to withdraw more liquidity than deposited.");
        require(reserve1 >= amount1 && reserve2 >= amount2, "Not enough available liquidity.");

        liquidityUnit.reserve1 -= amount1;
        liquidityUnit.reserve2 -= amount2;
        
        reserve1 -= amount1;
        reserve2 -= amount2;

        require(
            IERC20(token1).transfer(msg.sender, amount1),
            "Transfer of token1 failed"
        );
        require(
            IERC20(token2).transfer(msg.sender, amount2),
            "Transfer of token2 failed"
        );

        emit LiquidityRemoved(msg.sender, amount1, amount2);
    }

    function swap(address tokenIn, uint amountIn, address tokenOut, uint amountOutMin) public nonReentrant {
        require(tokenIn != tokenOut, "It's should be different tokens");

        bool variant1 = (tokenIn == token1 && tokenOut == token2);
        bool variant2 = (tokenIn == token2 && tokenOut == token1);
        require(variant1 || variant2, "Found not allowed liquidity tokens.");
        
        uint reserveIn;
        uint reserveOut;
        (reserveIn, reserveOut) = variant1 ? (reserve1, reserve2) : (reserve2, reserve1);

        uint amountOut = getAmountOut(amountIn, reserveIn, reserveOut);
        require(amountOut >= amountOutMin, "The rate has changed too much");


        if (variant1) {
            reserve1 += amountIn;
            reserve2 -= amountOut;

            require(
                IERC20(token1).transferFrom(msg.sender, address(this), amountIn),
                "Transfer of token1 failed"
            );
            require(
                IERC20(token2).transfer(msg.sender, amountOut),
                "Transfer of token2 failed"
            );
        } else {
            reserve2 += amountIn;
            reserve1 -= amountOut;

            require(
                IERC20(token2).transferFrom(msg.sender, address(this), amountIn),
                "Transfer of token2 failed"
            );
            require(
                IERC20(token1).transfer(msg.sender, amountOut),
                "Transfer of token1 failed"
            );
        }

        emit SwapExecuted(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public view returns (uint) {
        uint amountInWithFee = amountIn * (10000 - fee) / 10000;
        uint product = reserveIn * reserveOut;
        return product / (reserveIn + amountInWithFee);  // AMM formula
    }

    function getRateToken1() public view returns (uint) {
        return getAmountOut(10**6, reserve1, reserve2);
    }

    function getRateToken2() public view returns (uint) {
        return getAmountOut(10**6, reserve2, reserve1);
    }
}