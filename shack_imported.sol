pragma solidity ^0.4.13;

// Importing file contracts/ShackToken.sol
pragma solidity ^0.4.13;

// Importing file zeppelin-solidity/contracts/token/MintableToken.sol
pragma solidity ^0.4.11;


// Importing file StandardToken.sol
pragma solidity ^0.4.11;


// Importing file BasicToken.sol
pragma solidity ^0.4.11;


// Importing file ERC20Basic.sol
pragma solidity ^0.4.11;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
// Importing file math/SafeMath.sol
pragma solidity ^0.4.11;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
  function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
  }

}
// Importing file ERC20.sol
pragma solidity ^0.4.11;


// Importing file ERC20Basic.sol


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
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

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));

    uint256 _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
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
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval (address _spender, uint _addedValue)
    returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue)
    returns (bool success) {
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
pragma solidity ^0.4.11;


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
  function Ownable() {
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
  function transferOwnership(address newOwner) onlyOwner public {
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
    Transfer(0x0, _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}
// Importing file zeppelin-solidity/contracts/token/BurnableToken.sol
pragma solidity ^0.4.13;

// Importing file StandardToken.sol

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is StandardToken {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public {
        require(_value > 0);

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }
}
// Importing file zeppelin-solidity/contracts/token/PausableToken.sol
pragma solidity ^0.4.11;

// Importing file StandardToken.sol
// Importing file lifecycle/Pausable.sol
pragma solidity ^0.4.11;


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
 * @title Pausable token
 *
 * @dev StandardToken modified with pausable transfers.
 **/

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

/**
* SHACK - Smart Home Acquisition Contract token
*/
contract ShackToken is MintableToken, PausableToken, BurnableToken {
  string public name = "SHACk Token2";
  string public symbol = "SHAC2";
  uint256 public creationTime;
  uint256 public decimals = 6;

  function ShackToken(
	  string tokenName,
	  string tokenSymbol
  ) public {
	  name = tokenName;
	  symbol = tokenSymbol;
    creationTime = now;
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
//
  /**
    * @dev Override MintableTokenn.finishMinting() to add canMint modifier
  */
  function finishMinting() onlyOwner canMint public returns(bool) {
      return super.finishMinting();
  }

}
//import "zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol";
//import "zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol";
// Importing file zeppelin-solidity/contracts/ownership/Ownable.sol
// Importing file contracts/TokensCappedCrowdsale.sol
pragma solidity ^0.4.11;

// Importing file zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
pragma solidity ^0.4.11;

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


  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
    require(_startTime >= now);
    require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != 0x0);

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
  function () payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != 0x0);
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
  function validPurchase() internal constant returns (bool) {
    bool withinPeriod = now >= startTime && now <= endTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    return now > endTime;
  }


}


/**
* @dev Parent crowdsale contract is extended with support for cap in tokens
* Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
*
*/
contract TokensCappedCrowdsale is Crowdsale {

    uint256 public tokensCap;

    function TokensCappedCrowdsale(uint256 _tokensCap) public {
        tokensCap = _tokensCap;
    }

    // overriding Crowdsale#validPurchase to add extra tokens cap logic
    // @return true if investors can buy at the moment
    function validPurchase() internal constant returns(bool) {
        uint256 tokens = token.totalSupply().add(msg.value.mul(rate));
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
// Importing file contracts/PausableCrowdsale.sol
pragma solidity ^0.4.11;

// Importing file zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
// Importing file zeppelin-solidity/contracts/lifecycle/Pausable.sol


/**
* @dev Parent crowdsale contract extended with support for pausable crowdsale,
* meaning crowdsale can be paused by owner at any time
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
contract ShackTokenCrowdsale is TokensCappedCrowdsale(1), PausableCrowdsale(true) {

  string public crowdsaleTokenName;
  string public crowdsaleTokenSymbol;
  string public crowdfundedPropertyURL;
  uint256 public crowdsaleGoal;
  uint256 public termMonths;
  address public remainingTokensWallet;

  function ShackTokenCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet,
                              address _remainingTokensWallet,
                              string _crowdsaleTokenName,
                              string _crowdsaleTokenSymbol,
                              string _crowdfundedPropertyURL,
                              uint256 _tokensCap,
                              uint256 _crowdsaleGoal,
                              uint256 _termMonths
  ) public
    Crowdsale(_startTime, _endTime, _rate, _wallet) {
    remainingTokensWallet = _remainingTokensWallet;
    crowdsaleTokenName = _crowdsaleTokenName;
    crowdsaleTokenSymbol = _crowdsaleTokenSymbol;
    crowdfundedPropertyURL = _crowdfundedPropertyURL;
    tokensCap = _tokensCap;
    crowdsaleGoal = _crowdsaleGoal;
    termMonths = _termMonths;

    // allocate tokens to Shack Crowdsale
    mintTokens(wallet, crowdsaleGoal);
  }

  // creates the token to be sold.
  // override this method to have crowdsale of a specific MintableToken token.
  function createTokenContract() internal returns (MintableToken) {
    ShackToken token = new ShackToken(crowdsaleTokenName,crowdsaleTokenSymbol);
    token.pause();
    return token;
  }

  function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
    require(beneficiary != 0x0);
    require(tokens > 0);
    require(now <= endTime);                               // Crowdsale (without startTime check)
//    require(!isFinalized);                                 // FinalizableCrowdsale
    require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale

    token.mint(beneficiary, tokens);
  }

//
//  /**
//  * @dev Sets SHACK to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
//  * since SHACK cost is fixed in USD, but USD/ETH rate is changing
//  * @param _rate defines CAT/ETH rate: 1 ETH = _rate CATs
//  */
//  function setRate(uint256 _rate) external onlyOwner {
//      require(_rate != 0x0);
//      rate = _rate;
//      RateChange(_rate);
//  }
//
//  /**
//  * @dev Allows to adjust the crowdsale end time
//  */
//  function setEndTime(uint256 _endTime) external onlyOwner {
//      require(!isFinalized);
//      require(_endTime >= startTime);
//      require(_endTime >= now);
//      endTime = _endTime;
//  }
//
//  /**
//  * @dev Sets the wallet to forward ETH collected funds
//  */
//  function setWallet(address _wallet) external onlyOwner {
//      require(_wallet != 0x0);
//      wallet = _wallet;
//  }
//
//  /**
//  * @dev Sets the wallet to hold unsold tokens at the end of Current TDE
//  */
//  function setRemainingTokensWallet(address _remainingTokensWallet) external onlyOwner {
//      require(_remainingTokensWallet != 0x0);
//      remainingTokensWallet = _remainingTokensWallet;
//  }
//
//  // Events
//  event RateChange(uint256 rate);
//
//  /**
//  * @dev Finalizes the crowdsale, mint and transfer all ramaining tokens to owner
//  */
//  function finalization() internal {
//      super.finalization();
//
//      // Mint tokens up to CAP
//      if (token.totalSupply() < tokensCap) {
//          uint tokens = tokensCap.sub(token.totalSupply());
//          token.mint(remainingTokensWallet, tokens);
//      }
//
//      // disable minting of CATs
//      token.finishMinting();
//
//      // take onwership over CAToken contract
//      token.transferOwnership(owner);
//  }
//
//  /**
//  * @dev Helper to Pause ShackToken
//  */
//  function pauseTokens() public onlyOwner {
//      ShackToken(token).pause();
//  }
//
//  /**
//  * @dev Helper to UnPause ShackToken
//  */
//  function unpauseTokens() public onlyOwner {
//      ShackToken(token).unpause();
//  }
//

}
// imported ['node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol', 'node_modules/zeppelin-solidity/contracts/math/SafeMath.sol', 'node_modules/zeppelin-solidity/contracts/token/BasicToken.sol', 'node_modules/zeppelin-solidity/contracts/token/ERC20.sol', 'node_modules/zeppelin-solidity/contracts/token/StandardToken.sol', 'node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol', 'node_modules/zeppelin-solidity/contracts/token/MintableToken.sol', 'node_modules/zeppelin-solidity/contracts/token/BurnableToken.sol', 'node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol', 'node_modules/zeppelin-solidity/contracts/token/PausableToken.sol', 'contracts/ShackToken.sol', 'node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol', 'contracts/TokensCappedCrowdsale.sol', 'contracts/PausableCrowdsale.sol']
