// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Helper {
    function getSlot0Index(uint arraySlotIndex) public pure returns (uint256) {
        return ((2**256) - 1) - uint(keccak256(abi.encode(arraySlotIndex))) + 1;
    }
    
    function addressAsBytes(address toEncode) public pure returns (bytes32) {
        return bytes32(uint256(uint160(toEncode)));
    }
}