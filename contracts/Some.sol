// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Some {
    string public data;

    constructor(string memory _data) {
        data = _data;
    }

    function changeData(string memory newData) public {
        data = newData;
    }
}
