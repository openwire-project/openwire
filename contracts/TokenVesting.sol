// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TokenVesting {
    using SafeMath for uint256;

    address public beneficiary;

    uint256 public immutable cliff;
    uint256 public immutable start;
    uint256 public immutable duration;

    uint256 public released;

    mapping(address => uint256) public vesting;

    event TokensReleased(address token, uint256 amount);

    constructor(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration
    ) public {
        require(_beneficiary != address(0), "TokenVesting: beneficiary is zero address");
        require(_cliff <= _duration, "TokenVesting: cliff is longer than duration");
        require(_duration > 0, "TokenVesting: duration is 0");
        require(_start.add(_duration) > block.timestamp, "TokenVesting: final time is before current time");

        beneficiary = _beneficiary;
        duration = _duration;
        cliff = _start.add(_cliff);
        start = _start;
    }

    function setVesting(address token, uint256 amount) public {
        require(msg.sender == beneficiary, "TokenVesting: unauthorized");
        require(token != address(0), "TokenVesting: token is zero address");

        vesting[token] = vesting[token].add(amount);
        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

    function release(address token) public {
        uint256 vested = calculateVestedAmount(token, block.timestamp);
        require(vested > 0, "TokenVesting: no tokens to release");

        released = released.add(vested);
        vesting[token] = vesting[token].sub(vested);
        IERC20(token).transfer(beneficiary, vested);

        emit TokensReleased(token, vested);
    }

    function calculateVestedAmount(address token, uint256 timestamp) public view returns (uint256) {
        uint256 totalVested = vesting[token];
        if (timestamp < cliff) {
            return 0;
        } else if (timestamp >= start.add(duration)) {
            return totalVested;
        } else {
            uint256 elapsedTime = timestamp.sub(start);
            uint256 vested = totalVested.mul(elapsedTime).div(duration);
            uint256 unreleased = vested.sub(released);
            return unreleased;
        }
    }
}
