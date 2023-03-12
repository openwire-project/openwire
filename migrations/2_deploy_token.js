const OpenWireToken = artifacts.require("OpenWireToken");

module.exports = function(deployer) {
  deployer.deploy(OpenWireToken, "OpenWire", "OWT");
};
