ōFuel 0.0.1

Update OFuelToken smart contract

Add lock and unlock functions to allow users to lock and unlock their tokens for a specified time period
Add stakers and totalStaked variables to keep track of staked tokens
Add stake and unstake functions to allow users to stake and unstake their tokens, respectively
Add rewards variable to keep track of the total reward amount
Add rewardPerToken variable to keep track of the reward amount per token staked
Add lastUpdateTime variable to keep track of the last time rewards were updated
Add rewardRate function to calculate the reward rate based on the reward amount and time
Add earned function to calculate the amount of rewards earned by a user
Add getReward function to allow users to claim their rewards
Add notifyRewardAmount function to notify the contract of the new reward amount
Add rewardDistribution variable to keep track of the reward distributor
Add onlyRewardDistribution modifier to restrict certain functions to the reward distributor
Update transfer and transferFrom functions to account for staked tokens
Update constructor to assign the reward distributor role to the contract deployer and notify the contract of the initial reward amount.
