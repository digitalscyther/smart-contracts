// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract OwnershipContract {
    address private owner;

    event OwnershipTrasfered(address indexed previousOwner, address indexed newOwner);

    modifier OnlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnershipTrasfered(address(0), owner);
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function transferOnwership(address newOwner) public OnlyOwner {
        require(address(0) != newOwner, "New owner is the zero address");

        emit OwnershipTrasfered(owner, newOwner);

        owner = newOwner;
    }

    function privilegedAction() public OnlyOwner view returns (string memory) {
        return string("You did it, Your Majesty");
    }
}