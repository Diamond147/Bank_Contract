//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract forLoop {
    // Struct definition
    struct Account {
        string name;
        address owner;
        uint256 balance;
        bool isActive;
    }

    // Dynamic array of Account structs
    Account[] public accounts;

    function addMultipleAccounts(string[] memory names, address[] memory owners, uint256[] memory balances) public {
        for (uint256 i = 0; i < names.length; i++) {
            Account memory newAccount =
                Account({name: names[i], owner: owners[i], balance: balances[i], isActive: true});
            accounts.push(newAccount);
        }
    }
}
