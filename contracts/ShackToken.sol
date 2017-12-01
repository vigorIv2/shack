pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/token/BurnableToken.sol";
import "zeppelin-solidity/contracts/token/PausableToken.sol";

/**
* SHACK - Smart Home Acquisition Contract token
*/
contract ShackToken is MintableToken, PausableToken, BurnableToken {
  string public name = "SHACk Token2";
  string public symbol = "SHAC2";
  uint256 public creationTime;
  uint256 public decimals = 6;

  function ShackToken(
	  string tokenName,
	  string tokenSymbol
  ) public {
	  name = tokenName;
	  symbol = tokenSymbol;
    creationTime = now;
  }

//  // Overrided destructor
//  function destroy() public onlyOwner {
//      require(mintingFinished);
//      super.destroy();
//  }
//
//  // Overrided destructor companion
//  function destroyAndSend(address _recipient) public onlyOwner {
//      require(mintingFinished);
//      super.destroyAndSend(_recipient);
//  }
//
  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */  
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
