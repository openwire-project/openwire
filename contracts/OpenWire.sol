// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OpenwireToken.sol";

contract OpenwireLayer2 {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    uint256 public totalSupply;

    string public name;
    string public symbol;
    uint8 public decimals;

    OpenwireToken public token;

    constructor(address _tokenAddress) {
        name = "Openwire";
        symbol = "OPW";
        decimals = 18;
        token = OpenwireToken(_tokenAddress);
    }

    function deposit(uint256 _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] += _amount;
        totalSupply += _amount;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        token.transfer(msg.sender, _amount);
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
    }

    function transfer(address _recipient, uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
    }

    function approve(address _spender, uint256 _amount) external {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
    }

    function transferFrom(address _sender, address _recipient, uint256 _amount) external {
        require(balances[_sender] >= _amount, "Insufficient balance");
        require(allowed[_sender][msg.sender] >= _amount, "Not enough allowance");
        balances[_sender] -= _amount;
        balances[_recipient] += _amount;
        allowed[_sender][msg.sender] -= _amount;
        emit Transfer(_sender, _recipient, _amount);
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
