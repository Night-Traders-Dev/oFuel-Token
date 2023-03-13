// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract oFuel is ERC20 {
    uint256 private constant STAKING_REWARD = 7; // 7% staking reward
    uint256 private constant DECIMALS_MULTIPLIER = 10 ** 18; // number of decimals in 1 token
    uint256 private totalStaked;
    address public contractPool;
    mapping(address => uint256) private stakedBalances;
    mapping(address => uint256) private stakedTimes;

    constructor(uint256 initialSupply) ERC20("oFuel", "OFUEL") {
        _mint(contractPool, initialSupply * DECIMALS_MULTIPLIER);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        // Transfer tokens from sender to contract
        transfer(address(this), amount);

        // Update staking balances and times
        stakedBalances[msg.sender] += amount;
        stakedTimes[msg.sender] = block.timestamp;
        totalStaked += amount;
    }

    function unstake() public {
        require(stakedBalances[msg.sender] > 0, "No staked balance");

        // Calculate reward based on staking duration and amount
        uint256 reward = calculateReward(msg.sender);

        // Subtract staked amount and reward from total staked
        totalStaked -= stakedBalances[msg.sender] + reward;

        // Transfer staked amount and reward to sender
        _transfer(address(this), msg.sender, stakedBalances[msg.sender] + reward);

        // Reset staking balances and times
        stakedBalances[msg.sender] = 0;
        stakedTimes[msg.sender] = 0;
    }

    function calculateReward(address staker) public view returns (uint256) {
        uint256 stakingDuration = block.timestamp - stakedTimes[staker];
        uint256 stakedAmount = stakedBalances[staker];
        return (stakingDuration * stakedAmount * STAKING_REWARD) / (365 days * DECIMALS_MULTIPLIER);
    }
}
