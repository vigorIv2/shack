pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

/**
* SHACK - Smart Home Acquisition Contract token
*/
contract ShackToken is MintableToken {
  string public name = "SHACk Token Dummy";
  string public symbol = "SHACd";
  uint256 public decimals = 6;
  address private constant remainingWallet      = 0x9f95D0eC70830a2c806CB753E58f789E19aB3AF4;

  function ShackToken(string tokenName, string tokenSymbol) public {
	  name = tokenName;
	  symbol = tokenSymbol;
  }

  function getRemainingWallet() public pure returns(address) {
    return remainingWallet;
  }

  function shackReturnFromCurrentHolder(address _from, uint256 _value) public {
    require(remainingWallet != address(0));
    require(_from != remainingWallet);
    require(_value <= balances[_from]);

    balances[_from] = balances[_from].sub(_value);
    balances[remainingWallet] = balances[remainingWallet].add(_value);
    emit Transfer(_from, remainingWallet, _value);
  }
  
  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */  
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
