pragma solidity ^0.4.13;

import './ShackTokenCrowdsaleGeneric.sol';

/**
  Smart Home Acquisition Contract crowdsale
*/
contract ShackTokenCrowdsaleOne is ShackTokenCrowdsaleGeneric {
  uint256 startTime = now + 1;
  uint256 endTime   = startTime + (86400 * 20); // 20 days
  uint256 rate      = 1;
  address wallet    = 0x2999A54A61579d42E598F7F2171A06FC4609a2fC;
  address remainingTokensWallet = 0x0D7257484F4d7847e74dc09d5454c31bbfc94165;
  string crowdsaleTokenName = "Smart Home Acquisition Contract for 3 Eagle Town CA 2";
  string crowdsaleTokenSymbol = "SHK.CA.2.Town.3.Eagle";
  string crowdfundedPropertyURL = "https://drive.google.com/open?id=1hSj4Rt7lU3nH0uDlH8Vfby6fif6bV8df";
  uint256 tokensCap = 5;
  uint256 crowdsaleGoal = 2;
  uint256 termMonth = 12;

  function ShackTokenCrowdsaleOne() public 
    ShackTokenCrowdsaleGeneric(startTime, endTime, rate, wallet,
                              remainingTokensWallet,
                              crowdsaleTokenName,
                              crowdsaleTokenSymbol,
                              crowdfundedPropertyURL,
                              tokensCap,
                              crowdsaleGoal,
                              termMonths
                              ) {
  }

}
