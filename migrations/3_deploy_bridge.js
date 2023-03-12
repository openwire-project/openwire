const OpenWireToken = artifacts.require("OpenWireToken");
const OpenWire = artifacts.require("OpenWire");
const Validator = artifacts.require("Validator");
const Bridge = artifacts.require("Bridge");

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(Bridge, OpenWire.address, Validator.address, OpenWireToken.address);
};
