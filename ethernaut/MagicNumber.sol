// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract POC {
    event Log(address data);

    function run() public returns (address) {
        bytes memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }

        emit Log(solver);

        return solver;
    }
}