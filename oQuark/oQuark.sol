// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract oQuark is ERC20 {
    using SafeMath for uint256;
    
    uint256 public constant TOTAL_SUPPLY = 100000000000000000000000000000;
    uint256 private _totalBurned;
    uint256 private _taxPool;
    uint256 private _taxRate;
    uint256 private _baseBurnRate;
    uint256 private _maxBurnRate;
    
    constructor() ERC20("oQuark", "OQK") {
        _mint(msg.sender, TOTAL_SUPPLY);
        _taxRate = 100; // 1% tax on every transaction
        _baseBurnRate = 50; // 0.5% burn rate
        _maxBurnRate = 500; // 5% max burn rate
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 tax = amount.mul(_taxRate).div(10000);
        uint256 transferAmount = amount.sub(tax);
        uint256 burnAmount = calculateBurnAmount(amount);
        _taxPool = _taxPool.add(tax);
        _burn(msg.sender, burnAmount);
        super.transfer(recipient, transferAmount.sub(burnAmount));
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 tax = amount.mul(_taxRate).div(10000);
        uint256 transferAmount = amount.sub(tax);
        uint256 burnAmount = calculateBurnAmount(amount);
        _taxPool = _taxPool.add(tax);
        _burn(sender, burnAmount);
        super.transferFrom(sender, recipient, transferAmount.sub(burnAmount));
        return true;
    }
    
    function burn(uint256 amount) public {
        uint256 burnAmount = calculateBurnAmount(amount);
        _burn(msg.sender, burnAmount);
        _totalBurned = _totalBurned.add(burnAmount);
    }
    
    function calculateBurnAmount(uint256 amount) private view returns (uint256) {
        uint256 currentSupply = totalSupply();
        uint256 availableBurn = currentSupply.mul(_maxBurnRate).div(10000);
        uint256 actualBurnRate = _baseBurnRate.add((_maxBurnRate.sub(_baseBurnRate)).mul(currentSupply.sub(amount)).div(currentSupply));
        uint256 burnAmount = amount.mul(actualBurnRate).div(10000);
        if (burnAmount > availableBurn) {
            burnAmount = availableBurn;
        }
        return burnAmount;
    }
    
    function getTaxPool() public view returns (uint256) {
        return _taxPool;
    }
    
    function getTotalBurned() public view returns (uint256) {
        return _totalBurned;
    }
}
