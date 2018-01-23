pragma solidity ^0.4.11;

import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";


/**
* @dev Parent crowdsale contract is extended with support for cap in tokens
* Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
* 
*/
contract TokensCappedCrowdsale is Crowdsale {

    uint256 public tokensCap;

    function TokensCappedCrowdsale(uint256 _tokensCap) public {
        tokensCap = _tokensCap;
    }

    function calcTokens(uint256 weiAmount) internal constant returns(uint256) {
      // calculate token amount to be created
      uint256 tokens = weiAmount.mul(rate).div(1000000000000);
      return tokens;
    }  
    
    // overriding Crowdsale#validPurchase to add extra tokens cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal constant returns(bool) {
        uint256 tokens = token.totalSupply().add(calcTokens(msg.value));

        bool withinCap = tokens <= tokensCap;
        return super.validPurchase() && withinCap;
    }

    // cap setter, to set the value after constructor
    function setCap(uint256 newCap) public {
        tokensCap = newCap;
    }
    
    // overriding Crowdsale#hasEnded to add tokens cap logic
    // @return true if crowdsale event has ended
    function hasEnded() public constant returns(bool) {
        bool capReached = token.totalSupply() >= tokensCap;
        return super.hasEnded() || capReached;
    }

}
