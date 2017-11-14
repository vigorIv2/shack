pragma solidity ^0.4.13;

import 'contracts/ShackToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/Crowdsale.sol';


contract ShackTokenCrowdsale is Crowdsale {

  function ShackTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public 
    Crowdsale(_startTime, _endTime, _rate, _wallet) {
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    return new ShackToken("SHAC.CA.123.Lane.5.Goose","SHAC.CA.123.Lane.5.Goose");
  }

}
