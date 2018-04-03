pragma solidity ^0.4.18;

import './ShackToken.sol';
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";

import "./TokensCappedCrowdsale.sol";
import "./PausableCrowdsale.sol";

/**
  Smart Home Acquisition Contract crowdsale
*/
                                                                                     
//contract ShackSale is Ownable, PausableCrowdsale(false), TokensCappedCrowdsale(1000000000000000000), RefundableCrowdsale {
contract ShackSale is Ownable, 
  PausableCrowdsale(false), 
  TimedCrowdsale(now + 1, now + 1 + ShackSale.SALE_DURATION),
  TokensCappedCrowdsale(ShackSale.TOKENS_CAP) {
  using SafeMath for uint256;

// https://www.epochconverter.com/

//**********************************************************************************************
// ------------------------------ Customize Smart Contract ------------------------------------- 
//**********************************************************************************************
  uint256 constant _rate = 86304; // in USD cents per Ethereum
  address private constant _wallet    = 0x2999A54A61579d42E598F7F2171A06FC4609a2fC;
  address public remainingWallet      = 0x9f95D0eC70830a2c806CB753E58f789E19aB3AF4;
  string  public constant crowdsaleTokenName = "SHK 97 Yale Huntington CA 92656";
  string  public constant crowdsaleTokenSymbol = "SHK.CA.92656.Huntington.97.Yale";
  string  public constant crowdfundedPropertyURL = "https://goo.gl/SwuRP4";
  uint256 public constant TOKENS_CAP =  1200000000;// total property value in USD aka tokens with 6 dec places
  uint256 public constant tokensGoal =   642000000; // goal sufficient to cover current loans in tokens with 6 decimal 
//**********************************************************************************************
  uint32 public buyBackRate = 1034; // in ETH with 6 decimal places per token, initially 0.001034
//**********************************************************************************************
  uint256 public constant SALE_DURATION = 5184000; 

  function ShackSale() public 
// 86400*60+1=5184001  
//    Crowdsale(now + 1, now + 5184000, _rate, _wallet) {
    Crowdsale(_rate, _wallet, new ShackToken(crowdsaleTokenName,crowdsaleTokenSymbol) ) {
    require(TOKENS_CAP > 0);
    require(_rate > 0);
    require(tokensGoal > 0);
    require(tokensGoal < TOKENS_CAP);
  }

  enum Statuses { SaleInProgress, PendingApproval, Cancelled, Succeeded }
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
//  // override this method to have crowdsale of a specific MintableToken token.
//  function createTokenContract() internal returns (MintableToken) {
//    ShackToken tokenLoc = new ShackToken(crowdsaleTokenName,crowdsaleTokenSymbol);
//    return tokenLoc;
//  }

  function mintTokens(address beneficiary, uint256 tokens) private {
    require(beneficiary != 0x0);
    require(tokens > 0);
    require(now <= closingTime);                               // Crowdsale (without startTime check)
//    require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale, it will always be within the cap 

    if ( !ShackToken(token).mint(beneficiary, tokens) ) {
      revert(); 
    }
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
    emit RateChange(paramRate);
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(status == Statuses.SaleInProgress);
    super._preValidatePurchase(msg.sender, msg.value) ; // it would throw exception if invalid purchase
    require(validPurchase());

    uint256 weiAmount = msg.value;
    // calculate token amount to be created
    uint256 tokens = calcTokens(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);
    if ( ShackToken(token).mint(beneficiary, tokens) ) {
      emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
      forwardFunds();

      if ( token.totalSupply() >= tokensGoal ) {
        pause();
        setStatus(Statuses.PendingApproval);
      }
    }
        
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }
  
  /**
  * @dev Allows to resume crowdsale if it was pending approval
  */
  function resume(uint256 _hours) public onlyOwner {
    require(_hours <= 744); // shorter than longest month, i.e. max one month
    require(_hours > 0);
    closingTime = closingTime.add(_hours.mul(3600)); // convert to seconds and add to closingTime
    
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
  function approve() public onlyOwner {
    setStatus(Statuses.Succeeded);
    conclude();
  }

  /**
  * to cancel the sale if goal in dollars not reached, or other admin reasons
  */
  function cancel() public onlyOwner {
    setStatus(Statuses.Cancelled);
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
      if ( !ShackToken(token).mint(remainingWallet, tokens) ) { 
        revert();
      }
    }
    ShackToken(token).finishMinting();

    // take onwership over ShacToken contract
    ShackToken(token).transferOwnership(owner);
  }

  event BuyBackRateChange(uint32 rate);
  event BuyBackTransfer(address indexed from, address indexed to, uint256 value);
  event ReturnBuyBack(address indexed from, address indexed to, uint256 value);

  function setBuyBackRate(uint32 paramRate) public onlyOwner {
    require(paramRate >= 1);
    buyBackRate = paramRate;
    emit BuyBackRateChange(buyBackRate);
  }

  /**
  * Accumulate some Ether on address of this contract to do buyback
  */
  function fundForBuyBack() payable public onlyOwner returns(bool success) {
    return true;
  }

  function buyBack(address _tokenHolder, uint256 _tokens) public onlyOwner {
    require(_tokenHolder != remainingWallet);
    ShackToken(token).shackReturnFromCurrentHolder(_tokenHolder, remainingWallet, _tokens);
    uint256 buyBackWei = _tokens.mul(buyBackRate).mul(10**6);
    if ( _tokenHolder.send(buyBackWei) ) {
      emit BuyBackTransfer(address(this), _tokenHolder, buyBackWei);
    } else {
      revert();
    }
  }
  
  /**
  * during buyBack return funds from smart contract account to funds account
  */
  function returnBuyBackFunds() public onlyOwner {
    uint256 weiToReturn = address(this).balance;
    if ( _wallet.send(weiToReturn) ) {
      emit ReturnBuyBack(this, _wallet, weiToReturn);
    } else {
      revert();
    }
  }
 
}
