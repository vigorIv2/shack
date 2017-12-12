pragma solidity ^0.4.13;

import './ShackToken.sol';
//import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

// import "zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol";
//import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
//import "./TokensCappedCrowdsale.sol";
import "./PausableCrowdsale.sol";

/**
  Smart Home Acquisition Contract crowdsale
*/
// contract ShackTokenCrowdsale is Crowdsale, TokensCappedCrowdsale(1), PausableCrowdsale(true) {
contract ShackSale is Ownable, PausableCrowdsale(false) {
  using SafeMath for uint256;
// https://www.epochconverter.com/

  uint256 constant _duration  = 60; // default sale duration
  uint256 initialRate         = 620690000;
  address constant _wallet    = 0x2999A54A61579d42E598F7F2171A06FC4609a2fC;
  address public remainingTokensWallet = 0x0D7257484F4d7847e74dc09d5454c31bbfc94165;
  string  public constant crowdsaleTokenName = "SHAC for 5391 Meadowlark Dr. Huntington Beach CA 92649";
  string  public constant crowdsaleTokenSymbol = "SHAC.CA.92649.Huntington_Beach.5391.Meadowlark_Dr";
  string  public constant crowdfundedPropertyURL = "https://drive.google.com/open?id=1hSj4Rt7lU3nH0uDlH8Vfby6fif6bV8df";
  uint256 constant tokensCap = 5;
  uint256 constant _crowdsaleGoal = 2;
  uint256 public constant termMonths = 12;
  
  function ShackSale() public 
    Crowdsale(now + 1, now + 1 + (86400 * _duration), initialRate, _wallet) {
    
    // allocate tokens to Shack Crowdsale 
    mintTokens(_wallet, _crowdsaleGoal);
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    ShackToken tokenLoc = new ShackToken(crowdsaleTokenName,crowdsaleTokenSymbol);
    return tokenLoc;
  }


  // function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
  function mintTokens(address beneficiary, uint256 tokens) private {
    require(beneficiary != 0x0);
    require(tokens > 0);
    require(now <= endTime);                               // Crowdsale (without startTime check)
//    require(!isFinalized);                                 // FinalizableCrowdsale
//    require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale

    token.mint(beneficiary, tokens);
  }

  // Events
  event RateChange(uint256 rate);
 
  /**
  * @dev Sets SHACK to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
  * since SHACK cost is fixed in USD, but USD/ETH rate is changing
  * @param paramRate defines SHK/ETH rate: 1 ETH = paramRate SHKs
  */
  function setRate(uint256 paramRate) external onlyOwner {
      require(paramRate != 0x0);
      rate = paramRate;
      RateChange(paramRate);
  }

  function setRatePrime(uint256 paramRate) public onlyOwner {
      require(paramRate != 0x0);
      rate = paramRate;
      RateChange(paramRate);
  }


  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate).div(1000000000000);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }
  
  /**
  * @dev Allows to adjust the crowdsale end time
  */
  function setEndTime(uint256 _endTime) external onlyOwner {
//      require(!isFinalized);
      require(_endTime >= startTime);
      require(_endTime >= now);
      endTime = _endTime;
  }

  /**
  * @dev Sets the wallet to forward ETH collected funds
  */
  function setWallet(address paramWallet) external onlyOwner {
      require(paramWallet != 0x0);
      wallet = paramWallet;
  }

//  /**
//  * @dev Sets the wallet to hold unsold tokens at the end of Current TDE
//  */
//  function setRemainingTokensWallet(address _remainingTokensWallet) external onlyOwner {
//      require(_remainingTokensWallet != 0x0);
//      remainingTokensWallet = _remainingTokensWallet;
//  }
//
//  /**
//  * @dev Finalizes the crowdsale, mint and transfer all ramaining tokens to owner
//  */
//  function finalization() internal {
//      super.finalization();
//
//      // Mint tokens up to CAP
//      if (token.totalSupply() < tokensCap) {
//          uint tokens = tokensCap.sub(token.totalSupply());
//          token.mint(remainingTokensWallet, tokens);
//      }
//
//      // disable minting of CATs
//      token.finishMinting();
//
//      // take onwership over CAToken contract
//      token.transferOwnership(owner);
//  }
//

}
