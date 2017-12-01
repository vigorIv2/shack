pragma solidity ^0.4.13;

import 'contracts/ShackToken.sol';
//import "zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol";
//import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "contracts/TokensCappedCrowdsale.sol";
import "contracts/PausableCrowdsale.sol";

/**
  Smart Home Acquisition Contract crowdsale
*/
contract ShackTokenCrowdsale is TokensCappedCrowdsale(1), PausableCrowdsale(true) {

  string public crowdsaleTokenName;
  string public crowdsaleTokenSymbol;
  string public crowdfundedPropertyURL;
  uint256 public crowdsaleGoal;
  uint256 public termMonths;
  address public remainingTokensWallet;

  function ShackTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
                              address _remainingTokensWallet,
                              string _crowdsaleTokenName,
                              string _crowdsaleTokenSymbol,
                              string _crowdfundedPropertyURL,
                              uint256 _tokensCap,
                              uint256 _crowdsaleGoal,
                              uint256 _termMonths
  ) public 
    Crowdsale(_startTime, _endTime, _rate, _wallet) {
    remainingTokensWallet = _remainingTokensWallet;
    crowdsaleTokenName = _crowdsaleTokenName;
    crowdsaleTokenSymbol = _crowdsaleTokenSymbol;
    crowdfundedPropertyURL = _crowdfundedPropertyURL;
    tokensCap = _tokensCap;
    crowdsaleGoal = _crowdsaleGoal;
    termMonths = _termMonths;
    
    // allocate tokens to Shack Crowdsale 
    mintTokens(wallet, crowdsaleGoal);
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    ShackToken token = new ShackToken(crowdsaleTokenName,crowdsaleTokenSymbol);
    token.pause();
    return token;
  }

  function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
    require(beneficiary != 0x0);
    require(tokens > 0);
    require(now <= endTime);                               // Crowdsale (without startTime check)
//    require(!isFinalized);                                 // FinalizableCrowdsale
    require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale

    token.mint(beneficiary, tokens);
  }

//  
//  /**
//  * @dev Sets SHACK to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
//  * since SHACK cost is fixed in USD, but USD/ETH rate is changing
//  * @param _rate defines CAT/ETH rate: 1 ETH = _rate CATs
//  */
//  function setRate(uint256 _rate) external onlyOwner {
//      require(_rate != 0x0);
//      rate = _rate;
//      RateChange(_rate);
//  }
//
//  /**
//  * @dev Allows to adjust the crowdsale end time
//  */
//  function setEndTime(uint256 _endTime) external onlyOwner {
//      require(!isFinalized);
//      require(_endTime >= startTime);
//      require(_endTime >= now);
//      endTime = _endTime;
//  }
//
//  /**
//  * @dev Sets the wallet to forward ETH collected funds
//  */
//  function setWallet(address _wallet) external onlyOwner {
//      require(_wallet != 0x0);
//      wallet = _wallet;
//  }
//
//  /**
//  * @dev Sets the wallet to hold unsold tokens at the end of Current TDE
//  */
//  function setRemainingTokensWallet(address _remainingTokensWallet) external onlyOwner {
//      require(_remainingTokensWallet != 0x0);
//      remainingTokensWallet = _remainingTokensWallet;
//  }
//
//  // Events
//  event RateChange(uint256 rate);
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
//  /**
//  * @dev Helper to Pause ShackToken
//  */
//  function pauseTokens() public onlyOwner {
//      ShackToken(token).pause();
//  }
//
//  /**
//  * @dev Helper to UnPause ShackToken
//  */
//  function unpauseTokens() public onlyOwner {
//      ShackToken(token).unpause();
//  }
//

}
