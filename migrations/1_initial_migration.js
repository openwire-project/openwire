const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const OpenZeppelinUpgrades = artifacts.require('OpenZeppelinUpgrades');

module.exports = async function (deployer) {
  await deployer.deploy(OpenZeppelinUpgrades);
  const instance = await OpenZeppelinUpgrades.deployed();
  console.log('OpenZeppelinUpgrades deployed at:', instance.address);
};
