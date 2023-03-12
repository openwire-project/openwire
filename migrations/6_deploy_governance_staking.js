const OpenWireToken = artifacts.require("OpenWireToken");
const OpenWireGovernanceStaking = artifacts.require("OpenWireGovernanceStaking");

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(OpenWireGovernanceStaking, OpenWireToken.address);
};
