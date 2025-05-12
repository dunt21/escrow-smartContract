// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/Escrow-Contract.sol";

contract EscrowTest is Test{
address sender = address(1);
address reciever = address(2);
address holder = address(3);
Escrow escrow;

function setUp() public{
    vm.deal(sender, 1 ether);
    vm.prank(sender);
    escrow = new Escrow{value: 1 ether}(reciever, holder);
}

function testInitialState() public view{
    assertEq(address(escrow).balance, 1 ether);
    assertEq(escrow.sender(), sender);
    assertEq(escrow.reciever(), reciever);
    assertEq(escrow.holder(), holder);
    assertEq(escrow.approved(), false);
} 

function testOnlyMiddleManCanApprove() public {
    vm.expectRevert("Only the middleman can approve");
    escrow.approveTransfer();
}

function testApproveTransfer() public{
    vm.prank(holder);
    uint256 recieverBalance = reciever.balance;
    escrow.approveTransfer();

    assertEq(reciever.balance, recieverBalance + 1 ether);
    assertEq(escrow.approved(), true);
}

function testCannotApproveTwice() public{
    vm.prank(holder);
    escrow.approveTransfer();

    vm.expectRevert("Transfer is already approved");
    vm.prank(holder);
    escrow.approveTransfer();
}


}
