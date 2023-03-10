ōFuel 0.0.1
<br>
<br>
Update OFuelToken smart contract
<br>
<br>
Add lock and unlock functions to allow users to lock and unlock their tokens for a specified time period
<br>
<br>
Add stakers and totalStaked variables to keep track of staked tokens
<br>
<br>
Add stake and unstake functions to allow users to stake and unstake their tokens, respectively
<br>
<br>
Add rewards variable to keep track of the total reward amount
<br>
<br>
Add rewardPerToken variable to keep track of the reward amount per token staked
<br>
<br>
Add lastUpdateTime variable to keep track of the last time rewards were updated
<br>
<br>
Add rewardRate function to calculate the reward rate based on the reward amount and time
<br>
<br>
Add earned function to calculate the amount of rewards earned by a user
<br>
<br>
Add getReward function to allow users to claim their rewards
<br>
<br>
Add notifyRewardAmount function to notify the contract of the new reward amount
<br>
<br>
Add rewardDistribution variable to keep track of the reward distributor
<br>
<br>
Add onlyRewardDistribution modifier to restrict certain functions to the reward distributor
<br>
<br>
Update transfer and transferFrom functions to account for staked tokens
<br>
<br>
Update constructor to assign the reward distributor role to the contract deployer and notify the contract of the initial reward amount.
<br>
