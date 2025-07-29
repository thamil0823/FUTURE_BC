// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract STDTradersToken {
    string public name = "STD Traders";
    string public symbol = "STD";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        owner = msg.sender;
        totalSupply = 1000000 * (10 ** uint256(decimals)); // 1 million tokens
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function mint(address to, uint256 value) public onlyOwner {
        totalSupply += value;
        balanceOf[to] += value;
        emit Transfer(address(0), to, value);
    }

    function burn(uint256 value) public {
        require(balanceOf[msg.sender] >= value, "Not enough to burn");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Transfer(msg.sender, address(0), value);
    }

    function airdrop(address[] memory recipients, uint256[] memory values) public onlyOwner {
        require(recipients.length == values.length, "Mismatched arrays");
        for (uint256 i = 0; i < recipients.length; i++) {
            require(balanceOf[msg.sender] >= values[i], "Insufficient balance for airdrop");
            balanceOf[msg.sender] -= values[i];
            balanceOf[recipients[i]] += values[i];
            emit Transfer(msg.sender, recipients[i], values[i]);
        }
    }
}
