//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract bankProject1 {
    address public immutable bankOwner;
    uint256 public constant FEE = 1e16; // 0.01 ether
    uint256 public totalFee;
    uint256 public totalAmountInBank;

    error FEEIsLow(uint256 _userFee);

    struct accounts {
        string name;
        uint256 accountBalance;
        address accountAddress;
        bool accountStatus;
        // bytes bvn;
    }

    // mapping key address to the value accounts
    mapping(address => accounts) public differentAccounts;

    // CONSTRUCTOR - set the owner of the bank
    constructor(address _owner) {
        bankOwner = _owner;
    }

    // MODIFIER - only the owner of the bank can create different accounts
    modifier onlyBankOwner(address _owner) {
        require(bankOwner == _owner, "you are not the owner");
        _;
    }

    // 1. bank can create different bank accounts
    function createAccount(string memory _name) public payable onlyBankOwner(bankOwner) {
        // Check
        if (msg.value < FEE) {
            revert FEEIsLow(msg.value);
        }
        totalFee += msg.value;

        differentAccounts[msg.sender] =
            accounts({name: _name, accountBalance: 0, accountAddress: msg.sender, accountStatus: true});
    }

    // 2. user deposit money into different bank acccounts
    function userDeposit() public payable {
        require(msg.value > 0, "you must send more than zero amount");
        // pull out his bank account
        differentAccounts[msg.sender].accountBalance += msg.value;

        totalAmountInBank += msg.value;
    }

    // 3. owner of account can withdraw money from an account
    function userWIthdraw(uint256 amount) public {
        //CEI = CHECK- EFFECT - INTERACTION
        // CHECK
        require(amount > 0, "amount must be greater than zero");
        require(differentAccounts[msg.sender].accountBalance >= amount, "insufficient balance");

        // EFFECT
        differentAccounts[msg.sender].accountBalance -= amount;
        totalAmountInBank -= amount;

        //INTERACTION
        (bool isWithdrawn,) = payable(msg.sender).call{value: amount}("");
        require(isWithdrawn, "it cancelled joor");
    }

    // 4. Owner A can transfer to Owner B -> only updates internal transfer system, it does not move real ETH
    function userTransfer(address recipient, uint256 amount) public {
        // Owner A = msg.sender
        // Owner B = recipient

        // Effect
        differentAccounts[msg.sender].accountBalance -= amount;
        differentAccounts[recipient].accountBalance += amount;
    }

    // 5.  close an account
    function closeAccount() public {
        // get the amount of the user that wants to close an account
        uint256 _amount = differentAccounts[msg.sender].accountBalance;

        // withdraw all the money from the contract for the user that want to close an account
        userWIthdraw(_amount);

        // delete the account from the mapping
        delete differentAccounts[msg.sender];
    }
}
