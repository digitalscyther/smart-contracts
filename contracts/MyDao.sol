// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

pragma solidity >=0.8.2 <0.9.0;

contract Dao is Ownable, ReentrancyGuard {
    struct Proposal {
        address creator;
        string description;
        bool withTransfer;
        uint endTime;
        
        address to;
        bytes data;

        bool executed;

        uint votesFor;
        uint votesAgainst;
    }

    mapping(uint => Proposal) public proposals;
    uint nextProposalId;

    event ProposalCreated(address indexed creator, string description, uint endTime);
    event Voted(uint indexed proposalId, address indexed voter, uint amount, bool isVoteFor);
    event ProposalExecuted(uint indexed proposalId);

    constructor() Ownable(msg.sender) {
        nextProposalId = 0;
    }

    function createProposal(string calldata _description, bool _withTransfer, uint _durationSeconds, address _to, bytes calldata _data) public {
        uint endTime = block.timestamp + _durationSeconds;
        proposals[nextProposalId] = Proposal({
            creator: msg.sender,
            description: _description,
            withTransfer: _withTransfer,
            endTime: endTime,

            to: _to,
            data: _data,

            executed: false,

            votesFor: 0,
            votesAgainst: 0
        });

        emit ProposalCreated(msg.sender, _description, endTime);

        nextProposalId++;
    }

    function vote(uint _proposalId, bool _isVoteFor) public payable nonReentrant {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.endTime > block.timestamp , "Proposal voting ended");
        require(!proposal.executed, "Proposal already executed");

        if (_isVoteFor) {
            proposals[_proposalId].votesFor += msg.value;
        } else {
            proposals[_proposalId].votesAgainst += msg.value;
        }

        emit Voted(_proposalId, msg.sender, msg.value, _isVoteFor);
    }

    function executeProposal(uint _proposalId) public nonReentrant {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.endTime <= block.timestamp , "Proposal vote still ongoing");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votesFor >= proposal.votesAgainst, "Proposal voting result is \"Against\"");

        proposal.executed = true;

        uint amount = proposal.votesFor + proposal.votesAgainst;
        bool success;
        bytes memory returnData;
        if (proposal.withTransfer) {
            (success, returnData) = proposal.to.call{value: amount}(proposal.data);
        } else {
            require(isContract(proposal.to) && proposal.data.length > 0, "Impossible to execute proposal");
            (success, returnData) = proposal.to.call(proposal.data);
            require(success, string(returnData));
            (bool burnSuccess, ) = address(0).call{value: amount}("");
            require(burnSuccess, "Failed to burn proposal tokens");
        }
        require(success, string(returnData));

        emit ProposalExecuted(_proposalId);
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}