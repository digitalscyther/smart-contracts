// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.8.2 <0.9.0;

contract Crowdfunding is Ownable {
    uint public goal;
    uint public deadline;
    mapping(address => uint) public contributions;

    event ContributionReceived(address indexed contributor, uint amount);
    event FundsWithdrawn(address indexed owner, uint amount);
    event RefundIssued(address indexed contributor, uint amount);

    modifier onlyEnded() {
        require(block.timestamp >= deadline, "Fundraising is still ongoing");
        _;
    }

    constructor(uint _goal, uint _duration) Ownable(msg.sender) {
        goal = _goal;
        deadline = block.timestamp + _duration;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "Fundraising period has ended");

        contributions[msg.sender] += msg.value;
        
        emit ContributionReceived(msg.sender, msg.value);
    }

    function checkGoalReached() public view returns (bool) {
        return address(this).balance >= goal;
    }

    function refund() public onlyEnded {
        require(address(this).balance < goal, "Goal has been reached, refunds are not possible");

        uint amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RefundIssued(msg.sender, amount);
    }

    function withdraw() public onlyOwner onlyEnded {
        require(checkGoalReached(), "Goal not reached, funds cannot be withdrawn");

        uint amount = address(this).balance;
        address _owner = owner();
        payable(_owner).transfer(amount);

        emit FundsWithdrawn(_owner, amount);
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Renouncing ownership is not allowed");
    }
}