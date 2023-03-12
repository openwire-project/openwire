# Openwire

## Overview

Openwire is a layer 2 solution for Ethereum that aims to improve transaction speed and lower gas fees. This project includes a suite of smart contracts written in Solidity, a Web3.js library for interacting with the contracts, and deployment scripts for easy deployment on the Ethereum network.

## Features

- Fast and cost-efficient transactions
- Improved scalability for Ethereum
- Support for token vesting
- Secure and audited smart contracts

## Getting Started

To get started with Openwire, follow these steps:

1. Clone the GitHub repository:

git clone https://github.com/openwire-project/openwire.git


2. Install dependencies:

cd openwire
npm install


3. Deploy the smart contracts to the Ethereum network:

truffle migrate --network <network-name>


4. Interact with the contracts using the Web3.js library.

## Smart Contracts

The Openwire project includes the following smart contracts:

- Bridge.sol
- OpenWire.sol
- OpenWireGovernance.sol
- OpenWireGovernanceStaking.sol
- OpenWireStaking.sol
- OpenWireToken.sol
- Validator.sol
- TokenVesting.sol

## Deployment

The Openwire project includes deployment scripts for easy deployment on the Ethereum network. The deployment scripts are located in the `migrations` directory and include the following files:

- `1_initial_migration.js`
- `2_deploy_contracts.js`
- `2_deploy_token.js`
- `3_deploy_bridge.js`
- `4_deploy_staking.js`
- `5_deploy_governance.js`
- `6_deploy_governance_staking.js`
- `7_deploy_token_vesting.js`

## Contributing

Contributions to the Openwire project are welcome. To contribute, fork the repository, make your changes, and submit a pull request.

## License

The Openwire project is licensed under the MIT License.
