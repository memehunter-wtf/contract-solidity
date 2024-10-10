// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./2_iweth.sol";

contract Pair {
    using SafeMath for uint256;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint256 public reserve0;
    uint256 private feeReserve0;
    uint256 private initialReserve0;

    uint256 public reserve1;
    uint256 private feeReserve1;
    uint256 private minimumReserve1 = 200000000000000000000000000;

    uint256 public supply;

    constructor(
        address _token1,
        uint256 _token0Amount,
        uint256 _token1Amount
    )
    {
        token0 = IERC20(0x4200000000000000000000000000000000000006);
        token1 = IERC20(_token1);
        initialReserve0 = _token0Amount;
        _updateReserve(_token0Amount, _token1Amount);
    }

    function _updateReserve(uint256 _reserve0, uint256 _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function readInitialReserve0() external view returns (uint256) {
        return initialReserve0;
    }
 
    function swapAmountOut(
        address tokenIn, 
        uint256 amountIn,
        uint256 amountOutMin
    ) public view returns (uint256 amountOut, uint256 amountInWithFee) {
        require(
            tokenIn == address(token0) || tokenIn == address(token1),
            "invalid address"
        );
        require(amountIn > 0, "amount is 0");

        bool isToken0 = tokenIn == address(token0);
        (
            uint256 _reserve0, uint256 _reserve1
        ) = isToken0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);

    
        amountInWithFee = amountIn.mul(990).div(1000);
        require(amountInWithFee > 0, "amount is 0");

        uint256 amountOutTop = _reserve1.mul(amountInWithFee);
        uint256 amountOutBottom = _reserve0.add(amountInWithFee);
        amountOut = amountOutTop.div(amountOutBottom);
        require(amountOut >= amountOutMin, "amount out is not enough");
    }

    function getAllowance(address token) external view returns (uint256) {
        return ERC20(token).allowance(msg.sender, address(this));
    }

    receive() external payable { }

    function readWethIn() private view returns (uint256) {
        uint256 val = (reserve0.mul(reserve1).div(minimumReserve1)).sub(reserve0);
        return val;
    }

    event SwapExactETHForTokens(uint256 amountETH, uint256 amountToken, address token);
    function swapExactETHForTokens(
        // uint256 amountIn,
        uint256 amountOutMin
    ) external payable  {
        require(reserve1 > minimumReserve1, "carrier bag has been fully filled");

        uint256 _wethIn = msg.value;
        (uint256 _amountOut, uint256 amountInWithFee) = swapAmountOut(address(token0), _wethIn, amountOutMin);

        if (reserve1.sub(_amountOut) <= minimumReserve1) {
            _amountOut = reserve1.sub(minimumReserve1);
            _wethIn = readWethIn();
            amountInWithFee = _wethIn.mul(100).div(99);
            feeReserve0 = feeReserve0.add(amountInWithFee.div(100));
            payable(msg.sender).transfer(msg.value.sub(amountInWithFee));
        } else {
            feeReserve0 = feeReserve0.add(_wethIn.sub(amountInWithFee));
        }

        _updateReserve(
            reserve0.add(amountInWithFee),
            reserve1.sub(_amountOut)
        );

        IWETH(address(token0)).deposit{value: _wethIn}();
        token1.transfer(msg.sender, _amountOut);
        emit SwapExactETHForTokens(_wethIn, _amountOut, address(token1));
    }

    event SwapExactTokensForETH(uint256 amountToken, uint256 amountETH, address token);
    function swapExactTokensForETH (
        uint256 amountIn,
        uint256 amountOutMin
    ) external {
        require(reserve1 > minimumReserve1, "carrier bag has been fully filled");

        (uint256 _amountOut, uint256 amountOutWithFee) = swapAmountOut(address(token1), amountIn, amountOutMin);
        token1.transferFrom(msg.sender, address(this), amountIn);

        IWETH(address(token0)).withdraw(_amountOut);
        (bool sent, ) = msg.sender.call{value: _amountOut}("");
        require(sent, "failed to send ETH");

        feeReserve1 += amountIn - amountOutWithFee;
        _updateReserve(
            reserve0 - _amountOut,
            reserve1 + amountOutWithFee
        );

        emit SwapExactTokensForETH(amountIn, _amountOut, address(token1));
    }

    function readFee0() external view returns(uint) {
        return feeReserve0;
    }

    function readFee1() external view returns(uint) {
        return feeReserve1;
    }

    function collectFee() external {
        require(feeReserve0 > 0, "fee WETH is empty");

        IWETH(address(token0)).withdraw(feeReserve0);
        (bool sent, ) = payable(owner()).call{value: feeReserve0}("");
        require(sent, "failed to send ETH");

        token1.transfer(owner(), feeReserve1);

        feeReserve0 = 0;
        feeReserve1 = 0;
    }

    event SwapExactETHForTokensByDev(uint256 amountETH, uint256 amountToken, address token);
    function swapExactETHForTokensByDev(
        // uint256 amountIn,
        // uint256 _amountOut
        address devWallet
    ) external payable {
        uint256 _wethIn = msg.value;
        (uint256 _amountOut, uint256 amountInWithFee) = swapAmountOut(address(token0), _wethIn, 1);

        if (reserve1.sub(_amountOut) <= minimumReserve1) {
            _amountOut = reserve1.sub(minimumReserve1);
            _wethIn = readWethIn();
            feeReserve0 = feeReserve0.add(_wethIn);
            payable(devWallet).transfer(msg.value.sub(_wethIn));
        } else {
            feeReserve0 = feeReserve0.add(_wethIn.sub(amountInWithFee));
        }

        _updateReserve(
            reserve0.add(amountInWithFee),
            reserve1.sub(_amountOut)
        );

        IWETH(address(token0)).deposit{value: _wethIn}();
        emit SwapExactETHForTokens(_wethIn, _amountOut, address(token1));
    }

    bool private _inWithdrawal;
    modifier lock() {
        require(!_inWithdrawal, "Contract is currently busy with another withdrawal");
        _inWithdrawal = true;
        _;
        _inWithdrawal = false;
    }
 
    event WithdrawAttempt(address indexed owner, uint256 token1Amount, uint256 token0Amount);
    event WithdrawSuccess(address indexed owner, uint256 token1Amount, uint256 token0Amount, uint256 ethAmount);

    function withdraw(address to) public lock {
        uint256 amount0 = token0.balanceOf(address(this));
        uint256 amount1 = token1.balanceOf(address(this));
        emit WithdrawAttempt(to, amount0, amount1);
 
        // Transfer token1 & token0 to owner
        token1.transfer(to, amount1);
        token0.transfer(to, amount0);
 
        emit WithdrawSuccess(to, amount1, amount0, amount0);
    }

}
