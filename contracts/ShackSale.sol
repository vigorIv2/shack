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
contract ShackSale is Ownable, PausableCrowdsale(false), TokensCappedCrowdsale(ShackSale.TOKENS_CAP) {
  using SafeMath for uint256;

// https://www.epochconverter.com/

//**********************************************************************************************
// ------------------------------ Customize Smart Contract ------------------------------------- 
//**********************************************************************************************
  uint256 constant _rate = 86424; // in USD cents per Ethereum
  address private constant _wallet    = 0x2999A54A61579d42E598F7F2171A06FC4609a2fC;
  address public remainingWallet      = 0x9f95D0eC70830a2c806CB753E58f789E19aB3AF4;
  string  public constant crowdsaleTokenName = "SHK 5 Yale Irvine CA 92618";
  string  public constant crowdsaleTokenSymbol = "SHK.CA.92618.Irvine.5.Yale";
  string  public constant crowdfundedPropertyURL = "goo.gl/HqR8uT";
  uint256 public constant TOKENS_CAP =  1300000000;// total property value in USD aka tokens with 6 dec places
  uint256 public constant tokensGoal =   749000000; // goal sufficient to cover current loans in tokens with 6 decimal 
//**********************************************************************************************
  uint32 public buyBackRate = 100000; // in ETH with 6 decimal places per token, initially 0.100000 
//**********************************************************************************************

  function ShackSale() public 
// 86400*60+1=5184001  
    Crowdsale(now + 1, now + 5184000, _rate, _wallet) {
    require(TOKENS_CAP > 0);
    require(_rate > 0);
    require(tokensGoal > 0);
    require(tokensGoal < TOKENS_CAP);
  }

  enum Statuses { SaleInProgress, PendingApproval, Disapproved, Succeeded }
  Statuses public status = Statuses.SaleInProgress;

  function setStatus(Statuses _status) internal {
    status = _status;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is pendingApproval 
   */
  modifier whenPendingApproval() {
    require(status == Statuses.PendingApproval);
    _;
  }
  
  /**
   * @dev Modifier to make a function callable only when the contract is Approved
   */
  modifier whenSucceeded() {
    require(status == Statuses.Succeeded);
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
//    require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale, it will always be within the cap 

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
    require(paramRate >= 1);
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
  * @dev Allows to adjust the crowdsale end time by adding few more hours but no more than a month
  */
  function extend(uint256 _hours) public onlyOwner {
    require(_hours <= 744); // shorter than longest month, i.e. max one month
    require(_hours > 0);
    endTime = endTime.add(_hours.mul(3600)); // convert to seconds and add to endTime
  }

  /**
  * @dev Allows to resume crowdsale if it was pending approval
  */
  function resume(uint256 _hours) public onlyOwner whenPendingApproval {
    extend(_hours);
    setStatus(Statuses.SaleInProgress);
    if ( paused ) 
      unpause();
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
  function setRemainingTokensWallet(address _remainingWallet) public onlyOwner {
    require(_remainingWallet != 0x0);
    remainingWallet = _remainingWallet;
  }

  /**
  * @dev Finalizes the crowdsale, mint and transfer all ramaining tokens to owner
  */
  function conclude() internal {

    if (token.totalSupply() < tokensCap) {
      uint tokens = tokensCap.sub(token.totalSupply());
      token.mint(remainingWallet, tokens);
    }
    token.finishMinting();

    // take onwership over ShacToken contract
    token.transferOwnership(owner);
  }

  event BuyBackRateChange(uint32 rate);
  event BuyBackTransfer(address indexed from, address indexed to, uint256 value);

  function setBuyBackRate(uint32 paramRate) public onlyOwner {
    require(paramRate >= 1);
    buyBackRate = paramRate;
    BuyBackRateChange(buyBackRate);
  }

  /**
  * Accumulate some Ether on address of this contract to do buyback
  */
  function fundForBuyBack() payable public whenSucceeded returns(bool success) {
    return true;
  }
  
  /**
  * during buyBack tokens burnt for given address and corresponding USD converted to ETH transferred back to holder
  */
  function buyBack(address _tokenHolder, uint256 _tokens) public onlyOwner whenSucceeded {
    if ( ShackToken(token).burnFrom(_tokenHolder, _tokens) ) {
      uint256 buyBackWei = _tokens.mul(buyBackRate).mul(10**6);
      if (_tokenHolder.send(buyBackWei)) {
        BuyBackTransfer(this, _tokenHolder, buyBackWei);
      } else {
        revert();
      }
    }
  }
  
}
