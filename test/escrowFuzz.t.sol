// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Escrow-Contract.sol";

contract EscrowFuzz is Test{
    function testFuzzRandomAddresses(address randomReciever, address randomHolder) public {
        // require(randomReciever != randomHolder, "Reciever can't be the same as holder");

        vm.assume(randomReciever != randomHolder);
        vm.assume(randomReciever != address(0));
        vm.assume(randomHolder != address(0));

         
         Escrow escrow = new Escrow{value: 1 ether}(randomReciever, randomHolder);


         vm.prank(randomHolder);
         uint256 recieverBalance = randomReciever.balance;
         escrow.approveTransfer();

         assertEq(randomReciever.balance, recieverBalance + 1 ether);
    }
}