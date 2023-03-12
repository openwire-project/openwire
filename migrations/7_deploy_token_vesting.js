const OpenWireToken = artifacts.require("OpenWireToken");
const TokenVesting = artifacts.require("TokenVesting");

module.exports = async function(deployer, network, accounts) {
  const token = await OpenWireToken.deployed();
  const startTime = Math.floor(Date.now() / 1000);
  const cliffDuration = 30 * 24 * 60 * 60; // 30 days
  const totalDuration = 365 * 24 * 60 * 60; // 1 year
  const releasePercentage = 25;

  await deployer.deploy(TokenVesting, token.address, startTime, cliffDuration, totalDuration, releasePercentage);
};
