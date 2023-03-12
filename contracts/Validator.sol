// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OpenwireToken.sol";
import "./Bridge.sol";

contract Validator {
    OpenwireToken public token;
    Bridge public bridge;
    mapping(uint256 => bool) public processedNonces;

    event Deposited(address from, address to, uint256 amount, uint256 nonce);
    event Withdrawn(address from, address to, uint256 amount, uint256 nonce);

    constructor(address tokenAddress, address bridgeAddress) {
        token = OpenwireToken(tokenAddress);
        bridge = Bridge(bridgeAddress);
    }

    function deposit(address to, uint256 amount, uint256 nonce) public {
        require(!processedNonces[nonce], "Nonce has already been processed");
        processedNonces[nonce] = true;
        token.transferFrom(msg.sender, address(this), amount);
        emit Deposited(msg.sender, to, amount, nonce);
        bridge.receiveTokens(to, amount);
    }

    function withdraw(address from, uint256 amount, uint256 nonce, bytes memory signature) public {
        bytes32 message = prefixed(keccak256(abi.encodePacked(from, amount, nonce, address(this))));
        require(recoverSigner(message, signature) == bridge.admin(), "Invalid signature");
        require(!processedNonces[nonce], "Nonce has already been processed");
        processedNonces[nonce] = true;
        token.transfer(from, amount);
        emit Withdrawn(address(this), from, amount, nonce);
    }

    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
        require(sig.length == 65, "Invalid signature length");
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := and(mload(add(sig, 65)), 255)
        }
        if (v < 27) {
            v += 27;
        }
        require(v == 27 || v == 28, "Invalid signature v value");
        return ecrecover(message, v, r, s);
    }
}
