// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract HelloWorld {
    string greeting = "Hello world!";

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}