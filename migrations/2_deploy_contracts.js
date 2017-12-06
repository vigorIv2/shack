const ShackSale = artifacts.require("./ShackSale.sol")

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ShackSale);
};
