// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OpenWireToken.sol";

contract OpenWireStaking {
    OpenWireToken public token;
    uint256 public totalStaked;
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public lastStakedTime;
    uint256 public stakingDuration;
    uint256 public stakingRewardRate;
    uint256 public stakingCap;
    uint256 public stakingPenaltyRate;
    address public stakingAdmin;

    event Staked(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);
    event RewardPaid(address indexed account, uint256 amount);
    event StakingParametersUpdated(uint256 duration, uint256 rewardRate, uint256 cap, uint256 penaltyRate);

    constructor(
        OpenWireToken _token,
        uint256 _stakingDuration,
        uint256 _stakingRewardRate,
        uint256 _stakingCap,
        uint256 _stakingPenaltyRate,
        address _stakingAdmin
    ) {
        token = _token;
        stakingDuration = _stakingDuration;
        stakingRewardRate = _stakingRewardRate;
        stakingCap = _stakingCap;
        stakingPenaltyRate = _stakingPenaltyRate;
        stakingAdmin = _stakingAdmin;
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Cannot stake 0 tokens");

        uint256 newBalance = stakedBalances[msg.sender] + _amount;
        require(newBalance <= stakingCap, "Staking cap reached");

        if (stakedBalances[msg.sender] == 0) {
            lastStakedTime[msg.sender] = block.timestamp;
        }

        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        stakedBalances[msg.sender] = newBalance;
        totalStaked += _amount;

        emit Staked(msg.sender, _amount);
    }

    function withdraw() external {
        uint256 stakedAmount = stakedBalances[msg.sender];
        require(stakedAmount > 0, "Cannot withdraw 0 tokens");

        uint256 rewardAmount = calculateReward(stakedAmount);
        uint256 penaltyAmount = calculatePenalty(stakedAmount);

        uint256 withdrawAmount = stakedAmount + rewardAmount - penaltyAmount;

        stakedBalances[msg.sender] = 0;
        lastStakedTime[msg.sender] = 0;
        totalStaked -= stakedAmount;

        require(token.transfer(msg.sender, withdrawAmount), "Token transfer failed");

        emit Withdrawn(msg.sender, stakedAmount);
        if (rewardAmount > 0) {
            emit RewardPaid(msg.sender, rewardAmount);
        }
    }

    function calculateReward(uint256 _stakedAmount) public view returns (uint256) {
        uint256 stakedTime = block.timestamp - lastStakedTime[msg.sender];
        if (stakedTime > stakingDuration) {
            stakedTime = stakingDuration;
        }
        return (_stakedAmount * stakedTime * stakingRewardRate) / stakingDuration / 100;
    }

    function calculatePenalty(uint256 _stakedAmount) public view returns (uint256) {
    uint256 stakedTime = block.timestamp - lastStakedTime[msg.sender];
    if (stakedTime <= stakingDuration) {
        return 0;
    }
    uint256 penaltyTime = stakedTime - stakingDuration;
    return (_stakedAmount * penaltyTime * stakingPenaltyRate) / stakingDuration / 100;
}

    function setStakingRewardRate(uint256 _stakingRewardRate) external onlyAdmin {
        require(_stakingRewardRate > 0, "Reward rate must be greater than 0");
        stakingRewardRate = _stakingRewardRate;
    }

    function setStakingCap(uint256 _stakingCap) external onlyAdmin {
        stakingCap = _stakingCap;
    }

    function setStakingPenaltyRate(uint256 _stakingPenaltyRate) external onlyAdmin {
        stakingPenaltyRate = _stakingPenaltyRate;
    }

    function withdrawTokens(address _tokenAddress, uint256 _amount) external onlyAdmin {
        require(_tokenAddress != address(token), "Cannot withdraw staking tokens");
        IERC20 tokenToWithdraw = IERC20(_tokenAddress);
        require(tokenToWithdraw.transfer(msg.sender, _amount), "Token transfer failed");
    }

    function withdrawStakingTokens() external onlyAdmin {
        uint256 stakingTokens = token.balanceOf(address(this)) - totalStaked;
        require(token.transfer(msg.sender, stakingTokens), "Token transfer failed");
    }
}
