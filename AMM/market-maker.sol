// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract oFuelMarketMaker {
    using SafeERC20 for IERC20;

    address public immutable oFuelAddress;
    address public immutable stablecoinAddress;
    uint256 public immutable spread; // in basis points (0.01%)
    uint256 public immutable minTradeSize;

    constructor(address _oFuelAddress, address _stablecoinAddress, uint256 _spread, uint256 _minTradeSize) {
        require(_oFuelAddress != address(0), "Invalid oFuel address");
        require(_stablecoinAddress != address(0), "Invalid stablecoin address");
        require(_spread <= 1000, "Spread can't be greater than 10%");
        require(_minTradeSize > 0, "Minimum trade size must be greater than 0");

        oFuelAddress = _oFuelAddress;
        stablecoinAddress = _stablecoinAddress;
        spread = _spread;
        minTradeSize = _minTradeSize;
    }

    function buy(uint256 amount) external {
        require(amount >= minTradeSize, "Trade size too small");
        IERC20(oFuelAddress).safeTransferFrom(msg.sender, address(this), amount);

        uint256 stablecoinAmount = calculateBuyAmount(amount);

        IERC20(stablecoinAddress).safeTransfer(msg.sender, stablecoinAmount);
    }

    function sell(uint256 amount) external {
        require(amount >= minTradeSize, "Trade size too small");
        IERC20(oFuelAddress).safeTransfer(msg.sender, amount);

        uint256 stablecoinAmount = calculateSellAmount(amount);

        IERC20(stablecoinAddress).safeTransferFrom(msg.sender, address(this), stablecoinAmount);
    }

    function calculateBuyAmount(uint256 amount) public view returns (uint256) {
        uint256 spreadAmount = (amount * spread) / 10000;
        return amount + spreadAmount;
    }

    function calculateSellAmount(uint256 amount) public view returns (uint256) {
        uint256 spreadAmount = (amount * spread) / 10000;
        return amount - spreadAmount;
    }
}
