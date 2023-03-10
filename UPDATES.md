ōFuel 0.0.1
<b>
<b>
Update OFuelToken smart contract
<b>
<b>
Add lock and unlock functions to allow users to lock and unlock their tokens for a specified time period
<b>
Add stakers and totalStaked variables to keep track of staked tokens
<b>
Add stake and unstake functions to allow users to stake and unstake their tokens, respectively
<b>
Add rewards variable to keep track of the total reward amount
<b>
Add rewardPerToken variable to keep track of the reward amount per token staked
<b>
Add lastUpdateTime variable to keep track of the last time rewards were updated
<b>
Add rewardRate function to calculate the reward rate based on the reward amount and time
<b>
Add earned function to calculate the amount of rewards earned by a user
<b>
Add getReward function to allow users to claim their rewards
<b>
Add notifyRewardAmount function to notify the contract of the new reward amount
<b>
Add rewardDistribution variable to keep track of the reward distributor
<b>
Add onlyRewardDistribution modifier to restrict certain functions to the reward distributor
<b>
Update transfer and transferFrom functions to account for staked tokens
<b>
Update constructor to assign the reward distributor role to the contract deployer and notify the contract of the initial reward amount.
<b>
