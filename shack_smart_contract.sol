pragma solidity ^0.4.18;

// Importing file ShackToken.sol
pragma solidity ^0.4.13;

// Importing file zeppelin-solidity/contracts/token/MintableToken.sol
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
  uint256 public totalSupply;
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
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

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
    Transfer(msg.sender, _to, _value);
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
    Transfer(_from, _to, _value);
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
    Approval(msg.sender, _spender, _value);
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
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
    OwnershipTransferred(owner, newOwner);
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
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    MintFinished();
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

  function ShackToken(string tokenName, string tokenSymbol) public {
	  name = tokenName;
	  symbol = tokenSymbol;
  }

//  // Overrided destructor
//  function destroy() public onlyOwner {
//      require(mintingFinished);
//      super.destroy();
//  }
//
//  // Overrided destructor companion
//  function destroyAndSend(address _recipient) public onlyOwner {
//      require(mintingFinished);
//      super.destroyAndSend(_recipient);
//  }

  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
// Importing file zeppelin-solidity/contracts/token/MintableToken.sol
// Importing file zeppelin-solidity/contracts/math/SafeMath.sol

// Importing file zeppelin-solidity/contracts/ownership/Ownable.sol
// Importing file TokensCappedCrowdsale.sol
pragma solidity ^0.4.11;

// Importing file zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
pragma solidity ^0.4.18;

// Importing file token/MintableToken.sol
// Importing file math/SafeMath.sol

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
  using SafeMath for uint256;

  // The token being sold
  MintableToken public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // address where funds are collected
  address public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
    require(_startTime >= now);
    require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != address(0));

    token = createTokenContract();
    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    wallet = _wallet;
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific mintable token.
  function createTokenContract() internal returns (MintableToken) {
    return new MintableToken();
  }


  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = now >= startTime && now <= endTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    return now > endTime;
  }


}
// Importing file zeppelin-solidity/contracts/math/SafeMath.sol

/**
* @dev Parent crowdsale contract is extended with support for cap in tokens
* Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
*
*/
contract TokensCappedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 public tokensCap;

    function TokensCappedCrowdsale(uint256 _tokensCap) public {
      tokensCap = _tokensCap;
    }

    function calcTokens(uint256 weiAmount) internal constant returns(uint256) {
      // calculate token amount to be created
      uint256 tokens = weiAmount.div(100).mul(rate).div(1 ether).mul(10**6);
      return tokens;
    }

    // overriding Crowdsale#validPurchase to add extra tokens cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal constant returns(bool) {
      uint256 tokens = token.totalSupply().add(calcTokens(msg.value));

      bool withinCap = tokens <= tokensCap;
      return super.validPurchase() && withinCap;
    }

    // overriding Crowdsale#hasEnded to add tokens cap logic
    // @return true if crowdsale event has ended
    function hasEnded() public constant returns(bool) {
      bool capReached = token.totalSupply() >= tokensCap;
      return super.hasEnded() || capReached;
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
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    Unpause();
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
        return super.validPurchase() && !paused;
    }

}

/**
  Smart Home Acquisition Contract crowdsale
*/

//contract ShackSale is Ownable, PausableCrowdsale(false), TokensCappedCrowdsale(1000000000000000000), RefundableCrowdsale {
contract ShackSale is Ownable, PausableCrowdsale(false), TokensCappedCrowdsale(ShackSale.TOKENS_CAP) {
  using SafeMath for uint256;

// https://www.epochconverter.com/
  uint256 constant _decimals = 6;

//**********************************************************************************************
// ------------------------------ Customize Smart Contract -------------------------------------
//**********************************************************************************************
  uint256 constant _duration  = 60; // default crowd sale duration in days
  uint256 constant _rate = 200; // in USD cents per Ethereum
  address private constant _wallet    = 0x2999A54A61579d42E598F7F2171A06FC4609a2fC;
  address public remainingTokensWallet = 0x0D7257484F4d7847e74dc09d5454c31bbfc94165;
  string  public constant crowdsaleTokenName = "SHAC for 5394 Meadowlark Dr. Huntington Beach CA 92649";
  string  public constant crowdsaleTokenSymbol = "SHAC.CA.92649.Huntington_Beach.5394.Meadowlark_Dr";
  string  public constant crowdfundedPropertyURL = "https://drive.google.com/open?id=1hSj4Rt7lU3nH0uDlH8Vfby6fif6bV8df";
  uint256 public constant TOKENS_CAP = 15 * 10**_decimals; // total property value in USD aka tokens with 6 dec places
  uint256 public constant tokensGoal = 6 * 10**_decimals; // goal sufficient to cover current loans in tokens with 6 decimal
  uint256 public constant termMonths = 12;
//**********************************************************************************************


  function ShackSale() public
    Crowdsale(now + 1, now + 1 + (86400 * _duration), _rate, _wallet) {
    require(TOKENS_CAP > 0);
    require(_rate > 0);
    require(tokensGoal > 0);
    require(tokensGoal < TOKENS_CAP);
    require(_duration >= 1);
    require(termMonths >= 1);
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
// imported ['node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol', 'node_modules/zeppelin-solidity/contracts/math/SafeMath.sol', 'node_modules/zeppelin-solidity/contracts/token/BasicToken.sol', 'node_modules/zeppelin-solidity/contracts/token/ERC20.sol', 'node_modules/zeppelin-solidity/contracts/token/StandardToken.sol', 'node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol', 'node_modules/zeppelin-solidity/contracts/token/MintableToken.sol', 'contracts/ShackToken.sol', 'node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol', 'contracts/TokensCappedCrowdsale.sol', 'node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol', 'contracts/PausableCrowdsale.sol']
