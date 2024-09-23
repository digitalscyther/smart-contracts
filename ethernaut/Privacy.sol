// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Privacy {
    function foo(bytes32 source) public pure returns(bytes16) {
        return bytes16(source);
    }
}