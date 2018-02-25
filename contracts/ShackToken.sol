pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/MintableToken.sol";

/**
* SHACK - Smart Home Acquisition Contract token
*/
contract ShackToken is MintableToken {
  string public name = "SHACk Token Dummy";
  string public symbol = "SHACd";
  uint256 public decimals = 6;

  function ShackToken(string tokenName, string tokenSymbol) public {
	  name = tokenName;
	  symbol = tokenSymbol;
  }

  /**
   * @dev Transfer tokens from one address to another, returning from investor during buyback
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function returnFrom(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */  
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
