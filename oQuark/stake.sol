// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    struct Stake {
        uint256 amount;
        uint256 timestamp;
        uint256 lockDuration;
        uint256 interestRate;
    }

    IERC20 public oQuarkToken;
    uint256 public totalStaked;
    mapping(address => Stake[]) public stakes;

    constructor(IERC20 _oQuarkToken) {
        oQuarkToken = _oQuarkToken;
    }

    function stake(uint256 amount, uint256 lockDuration) external {
        require(amount > 0, "Amount cannot be zero");

        uint256 interestRate;
        if (lockDuration == 90 days) {
            interestRate = 500; // 5% APR
        } else if (lockDuration == 180 days) {
            interestRate = 798; // 7.98% APR
        } else if (lockDuration == 365 days) {
            interestRate = 1475; // 14.75% APR
        } else {
            revert("Invalid lock duration");
        }

        // Transfer the tokens from the user to the contract
        require(oQuarkToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Add the stake to the user's stakes
        stakes[msg.sender].push(Stake({
            amount: amount,
            timestamp: block.timestamp,
            lockDuration: lockDuration,
            interestRate: interestRate
        }));

        // Update the total staked amount
        totalStaked += amount;
    }

    function unstake(uint256 stakeIndex) external {
        Stake storage stake = stakes[msg.sender][stakeIndex];
        require(stake.amount > 0, "Stake not found");

        // Calculate the amount to return to the user
        uint256 lockDuration = stake.lockDuration;
        uint256 elapsedTime = block.timestamp - stake.timestamp;
        if (elapsedTime < lockDuration) {
            uint256 earlyWithdrawalFee = stake.amount.mul(lockDuration.sub(elapsedTime)).mul(stake.interestRate).div(lockDuration.mul(10000));
            uint256 amountToReturn = stake.amount.sub(earlyWithdrawalFee);
            oQuarkToken.transfer(msg.sender, amountToReturn);
        } else {
            oQuarkToken.transfer(msg.sender, stake.amount);
        }

        // Remove the stake from the user's stakes
        if (stakes[msg.sender].length > 1) {
            stakes[msg.sender][stakeIndex] = stakes[msg.sender][stakes[msg.sender].length - 1];
        }
        stakes[msg.sender].pop();

        // Update the total staked amount
        totalStaked -= stake.amount;
    }

    function getStakes(address account) external view returns (Stake[] memory) {
        return stakes[account];
    }

    function getTotalStaked() external view returns (uint256) {
        return totalStaked;
    }
}
