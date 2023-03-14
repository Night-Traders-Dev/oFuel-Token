// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IOCash {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract OCPolygonBridge {
    address public oCashToken;
    address public polygonToken;
    address public destination;
    uint256 public fee;
    address public owner;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address _oCashToken, address _polygonToken, address _destination, uint256 _fee) {
        oCashToken = _oCashToken;
        polygonToken = _polygonToken;
        destination = _destination;
        fee = _fee;
        owner = msg.sender;
    }

    function deposit(uint256 amount) external {
        require(IOCash(oCashToken).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(IOCash(oCashToken).balanceOf(address(this)) >= amount, "Insufficient balance");
        uint256 polygonAmount = amount - fee;
        require(IERC20(polygonToken).balanceOf(address(this)) >= polygonAmount, "Insufficient Polygon balance");
        require(IERC20(polygonToken).transfer(destination, polygonAmount), "Transfer failed");
        require(IOCash(oCashToken).transfer(owner, fee), "Transfer failed");
        emit Withdrawal(destination, polygonAmount);
    }

    function depositPolygon(uint256 amount) external {
        require(IERC20(polygonToken).transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit Deposit(msg.sender, amount);
    }

    function withdrawPolygon(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(IERC20(polygonToken).balanceOf(address(this)) >= amount, "Insufficient balance");
        uint256 oCashAmount = calculateEquivalentOcashAmount(amount);
        require(IOCash(oCashToken).balanceOf(address(this)) >= oCashAmount, "Insufficient ōCash balance");
        require(IOCash(oCashToken).transfer(destination, oCashAmount), "Transfer failed");
        require(IERC20(polygonToken).transfer(owner, amount), "Transfer failed");
        emit Withdrawal(destination, oCashAmount);
    }

    function calculateEquivalentOcashAmount(uint256 polygonAmount) internal view returns (uint256) {
        uint256 totalPolygonBalance = IERC20(polygonToken).balanceOf(address(this));
        uint256 totalOcashBalance = IOCash(oCashToken).balanceOf(address(this));
        uint256 feeAmount = (polygonAmount * fee) / (totalPolygonBalance - polygonAmount);
        uint256 oCashAmount = ((polygonAmount - feeAmount) * totalOcashBalance) / totalPolygonBalance;
        return oCashAmount;
    }
}
