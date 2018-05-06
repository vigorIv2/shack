pragma solidity ^0.4.18;


import "../ShackToken.sol";


// mock class using BasicToken
contract ShackTokenMock is ShackToken {

  constructor(address initialAccount, uint256 initialBalance) public {
    balances[initialAccount] = initialBalance;
    totalSupply_ = initialBalance;
  }

}
