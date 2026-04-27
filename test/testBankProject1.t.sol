// SPDX-License-Identifier: MIT
pragma solidity 0.8.33;

import {Test} from "../lib/forge-std/src/Test.sol";

import {console} from "../lib/forge-std/src/console.sol";
import {bankProject1} from "../src/bankProject1.sol";

contract testBankProject1 is Test {
    // test creatAcount function
    address bankOwner = makeAddr("opeyemi");

    bankProject1 public ourDeployedContract;

    function setUp() public {
        ourDeployedContract = new bankProject1(bankOwner);
    }

    function testCreateAccount() public {
        vm.deal(bankOwner, 5 ether);
        vm.prank(bankOwner);
        ourDeployedContract.createAccount{value: 1 ether}("opeyemi");

        (string memory name, uint256 balance, address accountAddress, bool status) =
            ourDeployedContract.differentAccounts(bankOwner);
        assertEq(name, "opeyemi");
        assertEq(balance, 0);
        assertEq(accountAddress, bankOwner);
        assertTrue(status);

        console.log("this is the name of the account holder:", name);
        console.log("this is the balance of the account:", balance);
        console.log("this is the address of the account holder:", bankOwner);
    }

    function testUserDeposit() public {
        vm.deal(bankOwner, 5 ether);
        vm.prank(bankOwner);

        ourDeployedContract.userDeposit{value: 4 ether}();

        console.log("bankOwner money is now:", bankOwner.balance);
    }

    function testUserWithdraw() public {
        vm.deal(bankOwner, 5 ether);

        vm.prank(bankOwner);
        ourDeployedContract.userDeposit{value: 2 ether}();

        vm.prank(bankOwner);
        ourDeployedContract.userWIthdraw(2 ether);

        assertEq(bankOwner.balance, 5 ether);

        console.log("this is the balance of the account holder:", bankOwner.balance);
    }

    function testUserTransfer() public {
        vm.deal(bankOwner, 5 ether);

        vm.prank(bankOwner);
        ourDeployedContract.userDeposit{value: 2 ether}();

        vm.prank(bankOwner);
        ourDeployedContract.userTransfer(bankOwner, 2 ether);

        assertEq(3 ether, bankOwner.balance);
    }

    function testCloseAccount() public {
        vm.deal(bankOwner, 5 ether);

        vm.prank(bankOwner);
        ourDeployedContract.userDeposit{value: 2 ether}();

        vm.prank(bankOwner);
        ourDeployedContract.closeAccount();

        (string memory name, uint256 balance, address addr, bool status) =
            ourDeployedContract.differentAccounts(bankOwner);

        assertEq(name, "");
        assertEq(balance, 0);
        assertEq(addr, address(0));
        assertFalse(status);
    }
}
