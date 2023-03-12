const OpenWireToken = artifacts.require("OpenWireToken");
const OpenWireGovernance = artifacts.require("OpenWireGovernance");
const OpenWireGovernanceStaking = artifacts.require("OpenWireGovernanceStaking");
const OpenWireStaking = artifacts.require("OpenWireStaking");
const Validator = artifacts.require("Validator");
const TokenVesting = artifacts.require("TokenVesting");

module.exports = async function(deployer, network, accounts) {
  // Deploy OpenWireToken
  await deployer.deploy(OpenWireToken);
  const openWireToken = await OpenWireToken.deployed();

  // Deploy OpenWireGovernance
  await deployer.deploy(OpenWireGovernance, openWireToken.address);
  const openWireGovernance = await OpenWireGovernance.deployed();

  // Deploy TokenVesting
  const beneficiary = accounts[1];
  const cliffDuration = 365; // 1 year
  const vestingDuration = 365 * 2; // 2 years
  const start = Math.floor(Date.now() / 1000) + 60; // start vesting in 1 minute
  const amount = web3.utils.toWei("1000000"); // 1M tokens
  await deployer.deploy(TokenVesting, openWireToken.address, beneficiary, start, cliffDuration, vestingDuration, amount);
  const tokenVesting = await TokenVesting.deployed();

  // Deploy Validator
  await deployer.deploy(Validator, openWireToken.address, openWireGovernance.address, tokenVesting.address);
  const validator = await Validator.deployed();

  // Deploy OpenWireGovernanceStaking
  const stakingDuration = 60 * 60 * 24 * 365; // 1 year
  const rewardPerBlock = web3.utils.toWei("10"); // 10 tokens
  await deployer.deploy(OpenWireGovernanceStaking, openWireToken.address, openWireGovernance.address, stakingDuration, rewardPerBlock);
  const openWireGovernanceStaking = await OpenWireGovernanceStaking.deployed();

  // Deploy OpenWireStaking
  const maxStakingAmount = web3.utils.toWei("100000"); // 100,000 tokens
  await deployer.deploy(OpenWireStaking, openWireToken.address, openWireGovernanceStaking.address, validator.address, maxStakingAmount);
  const openWireStaking = await OpenWireStaking.deployed();

  // Set the staking contract address in the governance contract
  await openWireGovernance.setStakingContract(openWireStaking.address);

  // Mint tokens to the token vesting contract
  await openWireToken.mint(tokenVesting.address, amount);

  console.log("Contracts deployed:");
  console.log("- OpenWireToken:", openWireToken.address);
  console.log("- OpenWireGovernance:", openWireGovernance.address);
  console.log("- TokenVesting:", tokenVesting.address);
  console.log("- Validator:", validator.address);
  console.log("- OpenWireGovernanceStaking:", openWireGovernanceStaking.address);
  console.log("- OpenWireStaking:", openWireStaking.address);
};
