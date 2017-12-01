const ShackToken = artifacts.require("ShackToken")

module.exports = function(deployer, network, accounts) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  const endTime = startTime + (86400 * 20) // 20 days
  const rate = new web3.BigNumber(1000)
  const wallet = accounts[0]

  const crowdsaleTokenName = "Smart Home Acquisition Contract for 3 Eagle Town CA 2"
  const crowdsaleTokenSymbol = "SHK.CA.2.Town.3.Eagle"
  deployer.deploy(ShackToken, crowdsaleTokenName, crowdsaleTokenSymbol)
  
};
