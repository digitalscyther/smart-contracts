// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract MyStorage {
    string _data;

    function setData(string memory newData) public {
        _data = newData;
    }

    function getData() public view returns (string memory) {
        return _data;
    }
}
