const OpenWireToken = artifacts.require("OpenWireToken");
const OpenWireStaking = artifacts.require("OpenWireStaking");

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(OpenWireStaking, OpenWireToken.address);
};
