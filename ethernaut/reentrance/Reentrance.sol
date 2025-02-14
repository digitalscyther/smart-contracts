// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Reentrance {
    mapping(address => uint256) public balances;
    event Donated(address to, uint amount);
    event Withdrawed(address to, uint amount);

    function donate(address _to) public payable {
        balances[_to] += msg.value;
        emit Donated(_to, msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}