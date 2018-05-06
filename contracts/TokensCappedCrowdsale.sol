pragma solidity ^0.4.11;

// import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
* @dev Parent crowdsale contract is extended with support for cap in tokens
* Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
* 
*/
contract TokensCappedCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

    uint256 tokensCap;

    constructor(uint256 _tokensCap) public {
      tokensCap = _tokensCap;
    }

    function calcTokens(uint256 weiAmount) internal constant returns(uint256) {
      // calculate token amount to be created
//      uint256 tokens = weiAmount.div(100).mul(rate).div(1 ether).mul(10**6);
      uint256 tokens = weiAmount.mul(rate).mul(10**6).div(1 ether).div(100);
      uint256 tokensLeft = tokensCap.sub(token.totalSupply());
      if ( tokensLeft < tokens ) {
        tokens = tokensLeft;
      }
      return tokens;
    }  
    
    // overriding Crowdsale#validPurchase to add extra tokens cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal view returns(bool) {
      uint256 tokens = token.totalSupply().add(calcTokens(msg.value));
      bool withinCap = tokens <= tokensCap;
      return withinCap;
    }

    // overriding Crowdsale#hasEnded to add tokens cap logic
    // @return true if crowdsale event has ended
    function hasClosed() public constant returns(bool) {
      bool capReached = token.totalSupply() >= tokensCap;
      return super.hasClosed() || capReached;
    }

}
