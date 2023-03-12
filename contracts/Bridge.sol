pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract OpenwireBridge {
    address public admin;
    address public token;
    uint256 public bridgeFee;
    
    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed recipient, uint256 amount);
    
    constructor(address _admin, address _token, uint256 _bridgeFee) {
        admin = _admin;
        token = _token;
        bridgeFee = _bridgeFee;
    }
    
    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        
        // Transfer tokens from sender to bridge contract
        require(IERC20(token).transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        emit Deposit(msg.sender, _amount);
    }
    
    function withdraw(address _recipient, uint256 _amount) external {
        require(msg.sender == admin, "Only admin can call this function");
        require(_amount > 0, "Amount must be greater than 0");
        
        // Calculate amount after bridge fee
        uint256 amountAfterFee = _amount - ((_amount * bridgeFee) / 10000);
        
        // Transfer tokens from bridge contract to recipient
        require(IERC20(token).transfer(_recipient, amountAfterFee), "Transfer failed");
        
        emit Withdraw(_recipient, _amount);
    }
}
