pragma solidity ^0.4.13;

import "zeppelin-solidity/contracts/token/MintableToken.sol";

contract ShackToken is MintableToken {
  string public name = "SHACk Token";
  string public symbol = "SHAC";
  uint256 public decimals = 18;

  function ShackToken(
	  string tokenName,
	  string tokenSymbol
  ) public {
	  name = tokenName;
	  symbol = tokenSymbol;
  }
}
