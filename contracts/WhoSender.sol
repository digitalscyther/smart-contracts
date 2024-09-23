// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract A {
    B b;

    constructor(address _b) {
        b = B(_b);
    }

    function approve() external {
        // Directly call B's function from A
        b.getMsgSender();
    }
}

contract B {
    event Log(address sender);

    function getMsgSender() public returns(address) {
        // Emit an event showing the actual msg.sender
        emit Log(msg.sender);
        // Return msg.sender
        return msg.sender;
    }
}