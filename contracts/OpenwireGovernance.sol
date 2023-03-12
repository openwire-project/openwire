pragma solidity ^0.8.0;

contract OpenWireGovernance {
    address public admin;
    uint public totalSupply;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        admin = msg.sender;
        totalSupply = 100000000000 * 10**8;
        balances[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(_to != address(0), "Invalid recipient");
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(_to != address(0), "Invalid recipient");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowed[_from][msg.sender] >= _value, "Insufficient allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
