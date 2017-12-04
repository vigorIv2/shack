const ShackTokenCrowdsaleOne = artifacts.require("./ShackTokenCrowdsaleOne.sol")

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ShackTokenCrowdsaleOne);
};
