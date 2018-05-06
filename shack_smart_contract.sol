pragma solidity ^0.4.18;

// Importing file ShackToken.sol
pragma solidity ^0.4.18;

// Importing file zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
pragma solidity ^0.4.18;

// Importing file StandardToken.sol
pragma solidity ^0.4.18;

// Importing file BasicToken.sol
pragma solidity ^0.4.18;


// Importing file ERC20Basic.sol
pragma solidity ^0.4.18;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
// Importing file math/SafeMath.sol
pragma solidity ^0.4.18;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}
// Importing file ERC20.sol
pragma solidity ^0.4.18;

// Importing file ERC20Basic.sol


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}
// Importing file ownership/Ownable.sol
pragma solidity ^0.4.18;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}

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
// Importing file zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
// Importing file zeppelin-solidity/contracts/math/SafeMath.sol

// Importing file zeppelin-solidity/contracts/ownership/Ownable.sol
// Importing file zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
pragma solidity ^0.4.18;

// Importing file math/SafeMath.sol
// Importing file Crowdsale.sol
pragma solidity ^0.4.18;

// Importing file token/ERC20/ERC20.sol
// Importing file math/SafeMath.sol

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropiate to concatenate
 * behavior.
 */

contract Crowdsale {
  using SafeMath for uint256;

  // The token being sold
  ERC20 public token;

  // Address where funds are collected
  address public wallet;

  // How many token units a buyer gets per wei
  uint256 public rate;

  // Amount of wei raised
  uint256 public weiRaised;

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  /**
   * @param _rate Number of token units a buyer gets per wei
   * @param _wallet Address where collected funds will be forwarded to
   * @param _token Address of the token being sold
   */
  function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
    require(_rate > 0);
    require(_wallet != address(0));
    require(_token != address(0));

    rate = _rate;
    wallet = _wallet;
    token = _token;
  }

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    buyTokens(msg.sender);
  }

  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    _processPurchase(_beneficiary, tokens);
    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
    token.transfer(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
   * @param _beneficiary Address receiving the tokens
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    return _weiAmount.mul(rate);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }
}


/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;

  /**
   * @dev Reverts if not in crowdsale time range.
   */
  modifier onlyWhileOpen {
    require(now >= openingTime && now <= closingTime);
    _;
  }

  /**
   * @dev Constructor, takes crowdsale opening and closing times.
   * @param _openingTime Crowdsale opening time
   * @param _closingTime Crowdsale closing time
   */
  function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
    require(_openingTime >= now);
    require(_closingTime >= _openingTime);

    openingTime = _openingTime;
    closingTime = _closingTime;
  }

  /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
   * @return Whether crowdsale period has elapsed
   */
  function hasClosed() public view returns (bool) {
    return now > closingTime;
  }

  /**
   * @dev Extend parent behavior requiring to be within contributing period
   * @param _beneficiary Token purchaser
   * @param _weiAmount Amount of wei contributed
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

}

// Importing file TokensCappedCrowdsale.sol
pragma solidity ^0.4.11;

// import "zeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
// Importing file zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
// Importing file zeppelin-solidity/contracts/math/SafeMath.sol

/**
* @dev Parent crowdsale contract is extended with support for cap in tokens
* Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
*
*/
contract TokensCappedCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

    uint256 tokensCap;

    function TokensCappedCrowdsale(uint256 _tokensCap) public {
      tokensCap = _tokensCap;
    }

    function calcTokens(uint256 weiAmount) internal constant returns(uint256) {
      // calculate token amount to be created
//      uint256 tokens = weiAmount.div(100).mul(rate).div(1 ether).mul(10**6);
      uint256 tokens = weiAmount.mul(rate).mul(10**6).div(1 ether).div(100);
      uint256 tokensLeft = tokensCap.sub(token.totalSupply());
      if ( tokensLeft < tokens ) {
        tokens = tokensLeft;
      }
      return tokens;
    }

    // overriding Crowdsale#validPurchase to add extra tokens cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal view returns(bool) {
      uint256 tokens = token.totalSupply().add(calcTokens(msg.value));
      bool withinCap = tokens <= tokensCap;
      return withinCap;
    }

    // overriding Crowdsale#hasEnded to add tokens cap logic
    // @return true if crowdsale event has ended
    function hasClosed() public constant returns(bool) {
      bool capReached = token.totalSupply() >= tokensCap;
      return super.hasClosed() || capReached;
    }

}
// Importing file PausableCrowdsale.sol
pragma solidity ^0.4.11;

// Importing file zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
// Importing file zeppelin-solidity/contracts/lifecycle/Pausable.sol
pragma solidity ^0.4.18;


// Importing file ownership/Ownable.sol


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}


/**
* @dev Parent crowdsale contract extended with support for pausable crowdsale, meaning crowdsale can be paused by owner at any time
* Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
*
* While the contract is in paused state, the contributions will be rejected
*
*/
contract PausableCrowdsale is Crowdsale, Pausable {

    function PausableCrowdsale(bool _paused) public {
        if (_paused) {
            pause();
        }
    }

    // overriding Crowdsale#validPurchase to add extra paused logic
    // @return true if investors can buy at the moment
    function validPurchase() internal constant returns(bool) {
        return !paused;
    }

}

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
  string  public constant crowdsaleTokenName = "SHK 98 Yale Huntington CA 92656";
  string  public constant crowdsaleTokenSymbol = "SHK.CA.92656.Huntington.98.Yale";
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
  * @dev Finalizes the crowdsale, mint and transfer all ramaining tokens to owner
  */
  function conclude() internal {

    if (token.totalSupply() < tokensCap) {
      uint tokens = tokensCap.sub(token.totalSupply());
      if ( !ShackToken(token).mint(ShackToken(token).getRemainingWallet(), tokens) ) {
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

  function getRemainingTokenWallet() public view returns(address) {
    return ShackToken(token).getRemainingWallet();
  }

  function buyBack(address _tokenHolder, uint256 _tokens) public onlyOwner {
    ShackToken(token).shackReturnFromCurrentHolder(_tokenHolder, _tokens);
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
// imported ['node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol', 'node_modules/zeppelin-solidity/contracts/math/SafeMath.sol', 'node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol', 'node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol', 'node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol', 'node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol', 'node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol', 'contracts/ShackToken.sol', 'node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol', 'node_modules/zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol', 'contracts/TokensCappedCrowdsale.sol', 'node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol', 'contracts/PausableCrowdsale.sol']
