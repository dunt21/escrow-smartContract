// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Escrow {
    address public sender;
    address public reciever;
    address public holder;
    bool public approved = false;

    constructor(address _reciever, address _holder) payable{
        sender = msg.sender;
        reciever = _reciever;
        holder = _holder;
    }

    function approveTransfer() public{
      require(msg.sender == holder, "Only the middleman can approve");
      require(approved == false, "Transfer is already approved");

      approved = true;
    (bool success, ) = payable(reciever).call{value: address(this).balance}("");
    require(success, "Transfer failed");
    }
}