const OpenWireToken = artifacts.require("OpenWireToken");
const OpenWireGovernance = artifacts.require("OpenWireGovernance");

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(OpenWireGovernance, OpenWireToken.address);
};
