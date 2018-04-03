pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

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

  function shackReturnFromCurrentHolder(address _from, address _to, uint256 _value) public {
    require(_to != address(0));
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(_from, _to, _value);
  }
  
  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */  
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
