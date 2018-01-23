pragma solidity ^0.4.18;

import './ShackToken.sol';
import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./TokensCappedCrowdsale.sol";
import "./PausableCrowdsale.sol";

/**
  Smart Home Acquisition Contract crowdsale
*/
                                                                                     
//contract ShackSale is Ownable, PausableCrowdsale(false), TokensCappedCrowdsale(1000000000000000000), RefundableCrowdsale {
contract ShackSale is Ownable, PausableCrowdsale(false), TokensCappedCrowdsale(3) {
  using SafeMath for uint256;

// https://www.epochconverter.com/
  uint256 constant _decimals = 6; 
  uint256 constant _duration  = 60; // default sale duration
  uint256 constant _rate = 3 * 10**_decimals; // total of 6 decimals
  address private constant _wallet    = 0x2999A54A61579d42E598F7F2171A06FC4609a2fC;
  address public remainingTokensWallet = 0x0D7257484F4d7847e74dc09d5454c31bbfc94165;
  string  public constant crowdsaleTokenName = "SHAC for 5393 Meadowlark Dr. Huntington Beach CA 92649";
  string  public constant crowdsaleTokenSymbol = "SHAC.CA.92649.Huntington_Beach.5393.Meadowlark_Dr";
  string  public constant crowdfundedPropertyURL = "https://drive.google.com/open?id=1hSj4Rt7lU3nH0uDlH8Vfby6fif6bV8df";
  uint256 constant _tokensCap = 15; // cap total property value in USD
  uint256 constant _crowdsaleGoal = 6; // goal sufficient to cover current loans 
  uint256 public tokensGoal = 0; // goal sufficient to cover current loans in tokens with 6 decimal 
  uint256 public constant termMonths = 12;

  function ShackSale() public 
    Crowdsale(now + 1, now + 1 + (86400 * _duration), _rate, _wallet) {
    require(_tokensCap > 0);
    require(_rate > 0);
    require(_crowdsaleGoal > 0);
    require(_crowdsaleGoal < _tokensCap);
    require(_duration >= 1);
    require(termMonths >= 1);

    uint256 newCap = _tokensCap.mul(10**_decimals);
    tokensGoal = _crowdsaleGoal.mul(10**_decimals); 
    setCap(newCap);
  }

  enum Statuses { SaleInProgress, PendingApproval, Disapproved, Succeeded }
  Statuses public status = Statuses.SaleInProgress;

  function setStatus(Statuses _status) internal {
    status = _status;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is in progress
   */
  modifier whenInProgress() {
    require(status == Statuses.SaleInProgress);
    _;
  }
  
  /**
   * @dev Modifier to make a function callable only when the contract is pendingApproval 
   */
  modifier whenPendingApproval() {
    require(status == Statuses.PendingApproval);
    _;
  }
  
  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    ShackToken tokenLoc = new ShackToken(crowdsaleTokenName,crowdsaleTokenSymbol);
    return tokenLoc;
  }


  function mintTokens(address beneficiary, uint256 tokens) private {
    require(beneficiary != 0x0);
    require(tokens > 0);
    require(now <= endTime);                               // Crowdsale (without startTime check)
    require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale

    token.mint(beneficiary, tokens);
  }

  // Events
  event RateChange(uint256 rate);
 
  /**
  * @dev Sets SHACK to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
  * since SHACK cost is fixed in USD, but USD/ETH rate is changing
  * @param paramRate defines SHK/ETH rate: 1 ETH = paramRate SHKs
  */
  function setRate(uint256 paramRate) public onlyOwner {
    require(paramRate != 0x0);
    rate = paramRate;
    RateChange(paramRate);
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(status == Statuses.SaleInProgress);
    require(validPurchase());

    uint256 weiAmount = msg.value;
    // calculate token amount to be created
    uint256 tokens = calcTokens(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);
    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    forwardFunds();
    if ( token.totalSupply() >= tokensGoal ) {
      pause();
      setStatus(Statuses.PendingApproval);
    }
        
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }
  
  /**
  * @dev Allows to adjust the crowdsale end time
  */
  function setEndTime(uint256 _endTime) public onlyOwner {
    require(_endTime >= startTime);
    require(_endTime >= now);
    endTime = _endTime;
  }

  /**
  * @dev Sets the wallet to forward ETH collected funds
  */
  function setWallet(address paramWallet) public onlyOwner {
    require(paramWallet != 0x0);
    wallet = paramWallet;
  }

  /**
  *  allows to approve the sale if goal in dollars reached, or other admin reasons
  */
  function approve() public whenPendingApproval {
    setStatus(Statuses.Succeeded);
    conclude();
  }

  /**
  * allows to disapprove the sale if goal in dollars not reached, or other admin reasons
  */
  function disapprove() public whenPendingApproval {
    setStatus(Statuses.Disapproved);
    conclude();
  }
  
  /**
  * @dev Sets the wallet to hold unsold tokens at the end of Current TDE
  */
  function setRemainingTokensWallet(address _remainingTokensWallet) public onlyOwner {
    require(_remainingTokensWallet != 0x0);
    remainingTokensWallet = _remainingTokensWallet;
  }

  /**
  * @dev Finalizes the crowdsale, mint and transfer all ramaining tokens to owner
  */
  function conclude() internal {

    if (token.totalSupply() < tokensCap) {
      uint tokens = tokensCap.sub(token.totalSupply());
      token.mint(remainingTokensWallet, tokens);
    }
    token.finishMinting();

    // take onwership over ShacToken contract
    token.transferOwnership(owner);
  }

}
