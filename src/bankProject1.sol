//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract bankProject1 {

    struct accounts {
        string name;
        uint256 accountBalance;
        address accountAddress;
        bool accountStatus;
        // bytes bvn;
    }

    address public bankOwner;
    uint256 public totalAmountInBank;

    // mapping key address to the value accounts
    mapping (address => accounts) public differentAccounts;

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
    // account creator
    function createAccount(string memory _name) public onlyBankOwner(bankOwner) {
        differentAccounts[msg.sender] = accounts({
            name: _name,
            accountBalance: 0,
            accountAddress: msg.sender,
            accountStatus: true
        });
    }
    
    // 2. user deposit money into differnt bank acccounts
        // payable 
        // msg.value
    function userDeposit() public payable {
        // pull out his bank account
        differentAccounts[msg.sender].accountBalance = differentAccounts[msg.sender].accountBalance + msg.value;

        // totalAmountInBank = totalAmountInBank + msg.value;
        totalAmountInBank += msg.value;
    }

    // 3. owner of account can withdraw money from an account
    function userWIthdraw(uint256 amount) public {
        //CEI CHECK- EFFECT - INTERACTION

        // EFFECT
        differentAccounts[msg.sender].accountBalance = differentAccounts[msg.sender].accountBalance - amount;
        
        //INTERACTION
        (bool isWithdrawn, ) = payable(msg.sender).call{value:amount}("");
        require(isWithdrawn, "it cancelled joor");

        totalAmountInBank -= amount;
    }

    // 4. Owner A can transfer to Owner B
    function userTransfer(address recipient, uint256 amount) public payable {
        // Owner A = msg.sender
        // Owner B = recipient
        differentAccounts[msg.sender].accountBalance -=  amount;
        differentAccounts[recipient].accountBalance += amount;

        // (bool isTransferred, ) = payable(recipient).call{value:amount}("");
        // require(isTransferred, "No transfer done");
        // totalAmountInBank -= amount;
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