pragma solidity ^0.4.10;

contract ForeignToken {
    function balanceOf(address _owner) constant public returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract ShackPlainCrowdsale {
    address owner = msg.sender;

    bool public purchasingAllowed = false;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    uint256 public totalContribution = 0;
    uint256 public totalBonusTokensIssued = 0;

    uint256 public totalSupply = 0;

    function name() pure public returns (string) { return "SHAC.CA.92618.Irvine.381.Monroe"; }
    function symbol() pure public returns (string) { return "SHAC.CA.92618.Irvine.381.Monroe"; }
    function decimals() pure public returns (uint8) { return 18; }

    function balanceOf(address _owner) constant public returns (uint256) { return balances[_owner]; }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 short address attack
        if(msg.data.length < (2 * 32) + 4) { revert(); }

        if (_value == 0) { return false; }

        uint256 fromBalance = balances[msg.sender];

        bool sufficientFunds = fromBalance >= _value;
        bool overflowed = balances[_to] + _value < balances[_to];

        if (sufficientFunds && !overflowed) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;

            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 short address attack
        if(msg.data.length < (3 * 32) + 4) { revert(); }

        if (_value == 0) { return false; }

        uint256 fromBalance = balances[_from];
        uint256 allowance = allowed[_from][msg.sender];

        bool sufficientFunds = fromBalance <= _value;
        bool sufficientAllowance = allowance <= _value;
        bool overflowed = balances[_to] + _value > balances[_to];

        if (sufficientFunds && sufficientAllowance && !overflowed) {
            balances[_to] += _value;
            balances[_from] -= _value;

            allowed[_from][msg.sender] -= _value;

            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 spend/approval race condition
        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint256) {
        return allowed[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function enablePurchasing() public {
        if (msg.sender != owner) { revert(); }

        purchasingAllowed = true;
    }

    function disablePurchasing() public {
        if (msg.sender != owner) { revert(); }

        purchasingAllowed = false;
    }

    function withdrawForeignTokens(address _tokenContract) public returns (bool) {
        if (msg.sender != owner) { revert(); }

        ForeignToken token = ForeignToken(_tokenContract);

        uint256 amount = token.balanceOf(address(this));
        return token.transfer(owner, amount);
    }

    function getStats() constant public returns (uint256, uint256, uint256, bool) {
        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
    }

    function() payable private {
        if (!purchasingAllowed) { revert(); }

        if (msg.value == 0) { return; }

        owner.transfer(msg.value);
        totalContribution += msg.value;

        uint256 tokensIssued = (msg.value * 100);

        if (msg.value >= 10 finney) {
            tokensIssued += totalContribution;

            bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
            if (bonusHash[0] == 0) {
                uint8 bonusMultiplier =
                    ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) +
                    ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) +
                    ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) +
                    ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);

                uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
                tokensIssued += bonusTokensIssued;

                totalBonusTokensIssued += bonusTokensIssued;
            }
        }

        totalSupply += tokensIssued;
        balances[msg.sender] += tokensIssued;

        Transfer(address(this), msg.sender, tokensIssued);
    }
}
