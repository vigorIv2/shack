pragma solidity ^0.4.18;


import "ShackToken.sol";


// mock class using ShackToken
contract ShackTokenMock is ShackTokenToken {

  function ShackTokenMock(address initialAccount, uint256 initialBalance) public {
    balances[initialAccount] = initialBalance;
    totalSupply_ = initialBalance;
  }

}
