pragma solidity ^0.4.20;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ShackToken.sol";

contract TestShackcoin {

  function testInitialBalanceUsingDeployedContract() public {
    ShackToken shack = ShackToken(DeployedAddresses.ShackToken());

    uint expected = 10000;

    Assert.equal(shack.balanceOf(tx.origin), expected, "Owner should have 10000 ShackToken initially");
  }

  function testInitialBalanceWithNewShackToken() public {
    ShackToken shack = new ShackToken("Shack Unit Test","Shack Token Symbol");

    uint expected = 10000;

    Assert.equal(shack.balanceOf(tx.origin), expected, "Owner should have 10000 ShackToken initially");
  }

}
