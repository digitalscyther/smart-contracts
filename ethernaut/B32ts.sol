// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Convert {
    function bytesToString(bytes memory _bytes) public pure returns (string memory) {
        return abi.decode(_bytes, (string));
    }
}