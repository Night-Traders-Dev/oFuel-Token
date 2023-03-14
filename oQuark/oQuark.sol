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
    
    constructor() ERC20("oQuark", "OQK") {
        _mint(msg.sender, TOTAL_SUPPLY);
        _taxRate = 100; // 1% tax on every transaction
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 tax = amount.mul(_taxRate).div(10000);
        uint256 transferAmount = amount.sub(tax);
        _taxPool = _taxPool.add(tax);
        super.transfer(recipient, transferAmount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 tax = amount.mul(_taxRate).div(10000);
        uint256 transferAmount = amount.sub(tax);
        _taxPool = _taxPool.add(tax);
        super.transferFrom(sender, recipient, transferAmount);
        return true;
    }
    
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
        _totalBurned = _totalBurned.add(amount);
    }
    
    function getTaxPool() public view returns (uint256) {
        return _taxPool;
    }
    
    function getTotalBurned() public view returns (uint256) {
        return _totalBurned;
    }
}
