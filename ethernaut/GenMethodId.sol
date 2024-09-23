// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Gen {
    function run(string memory signature) public pure returns(bytes4) {
        bytes32 hash = keccak256(abi.encodePacked(signature));
        bytes4 methodId = bytes4(hash);

        return methodId;
    }
}