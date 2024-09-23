// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint vote;
    }

    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    event Voted(address indexed voter, uint indexed candidateId);

    function addCandidate(string memory name) public {
        candidates.push(Candidate(candidates.length, name, 0));
    }

    modifier onlyOnce() {
        require(!voters[msg.sender].voted, "You have already voted.");
        _;
    }

    function vote(uint candidateId) public onlyOnce {
        require(candidateId < candidates.length, "Invalid candidate ID.");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = candidateId;

        candidates[candidateId].voteCount++;

        emit Voted(msg.sender, candidateId);
    }

    function getCanddidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}