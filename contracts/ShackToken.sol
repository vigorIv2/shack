pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/token/BurnableToken.sol";

/**
* SHACK - Smart Home Acquisition Contract token
*/
contract ShackToken is BurnableToken, MintableToken {
  string public name = "SHACk Token Dummy";
  string public symbol = "SHACd";
  uint256 public decimals = 6;

  function ShackToken(string tokenName, string tokenSymbol) public {
	  name = tokenName;
	  symbol = tokenSymbol;
  }

  /**
   * Destroy tokens from other account
   *
   * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
   *
   * @param _from the address of the sender
   * @param _value the amount of money to burn
   */
  function burnFrom(address _from, uint256 _value) public returns (bool success) {
    require(balances[_from] >= _value);                // Check if the targeted balance is enough
    balances[_from] = balances[_from].sub(_value);     // Subtract from the targeted balance
    totalSupply = totalSupply.sub(_value);
    Burn(_from, _value);
    return true;
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

  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */  
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
