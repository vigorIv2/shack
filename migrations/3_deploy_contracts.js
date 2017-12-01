const ShackTokenCrowdsale = artifacts.require("ShackTokenCrowdsale")

module.exports = function(deployer, network, accounts) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  const endTime = startTime + (86400 * 20) // 20 days
  const rate = new web3.BigNumber(1000)
  const wallet = accounts[0]

  const remainingTokensWallet = "0x0D7257484F4d7847e74dc09d5454c31bbfc94165"
  const crowdsaleTokenName = "Smart Home Acquisition Contract for 3 Eagle Town CA 2"
  const crowdsaleTokenSymbol = "SHK.CA.2.Town.3.Eagle"
  const crowdfundedPropertyURL = "https://drive.google.com/open?id=1hSj4Rt7lU3nH0uDlH8Vfby6fif6bV8df"
  const tokensCap = 100
  const crowdsaleGoal = 10
  deployer.deploy(ShackTokenCrowdsale, startTime, endTime, rate, wallet, 
    remainingTokensWallet, crowdsaleTokenName, crowdsaleTokenSymbol, crowdfundedPropertyURL, 
    tokensCap, crowdsaleGoal)
  
};
