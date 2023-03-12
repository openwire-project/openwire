// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./OpenWireToken.sol";
import "./OpenWireGovernance.sol";

contract OpenWireGovernanceStaking {
    struct Stake {
        uint256 amount;
        uint256 lockTime;
    }

    mapping(address => Stake) public stakes;

    OpenWireToken public owxToken;
    OpenWireGovernance public governance;

    event Staked(address indexed staker, uint256 amount, uint256 lockTime);
    event Unstaked(address indexed staker, uint256 amount);
    event RewardsClaimed(address indexed staker, uint256 amount);

    constructor(address _owxToken, address _governance) {
        owxToken = OpenWireToken(_owxToken);
        governance = OpenWireGovernance(_governance);
    }

    function stake(uint256 amount, uint256 lockTime) external {
        require(amount > 0, "Cannot stake 0 tokens");
        require(owxToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        Stake storage userStake = stakes[msg.sender];
        userStake.amount += amount;
        userStake.lockTime = lockTime;

        emit Staked(msg.sender, amount, lockTime);
    }

    function unstake() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake to withdraw");
        require(block.timestamp >= userStake.lockTime, "Stake is still locked");

        uint256 amount = userStake.amount;
        userStake.amount = 0;

        require(owxToken.transfer(msg.sender, amount), "Token transfer failed");

        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake to claim rewards for");

        uint256 reward = calculateRewards(msg.sender);
        require(reward > 0, "No rewards to claim");

        governance.transferRewards(msg.sender, reward);

        emit RewardsClaimed(msg.sender, reward);
    }

    function calculateRewards(address staker) public view returns (uint256) {
        Stake memory userStake = stakes[staker];

        if (userStake.amount == 0) {
            return 0;
        }

        uint256 timePassed = block.timestamp - userStake.lockTime;
        uint256 timeWeightedStake = userStake.amount * timePassed;
        uint256 totalStake = owxToken.balanceOf(address(this));

        return (timeWeightedStake * governance.getRewardsRate()) / totalStake;
    }
}