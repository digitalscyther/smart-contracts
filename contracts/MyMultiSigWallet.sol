// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract MultiSigWallet {
    address[] public owners;
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    event SubmitTransaction(uint indexed txIndex, address indexed owner, address indexed to, uint value);
    event ConfirmTransaction(uint indexed txIndex, address indexed owner);
    event ExecuteTransaction(uint indexed txIndex, address indexed owner);
    event RevokeConfirmation(uint indexed txIndex, address indexed owner);

    modifier OnlyOwner() {
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint _txIndex) {
        require(!confirmations[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _required) payable  {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number of confirmations");

        owners = _owners;
        required = _required;
    }

    function isOwner(address _addr) public view returns(bool) {
        for (uint i = 0; i < owners.length; i++) 
        {
            if (owners[i] == _addr) {
                return true;
            }
        }
        return false;
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public OnlyOwner {
        uint txIndex = transactions.length;
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
        }));

        emit SubmitTransaction(txIndex, msg.sender, _to, _value);
    }

    function confirmTransaction(uint _txIndex) public OnlyOwner txExists(_txIndex) notConfirmed(_txIndex) notExecuted(_txIndex) {
        confirmations[_txIndex][msg.sender] = true;
        transactions[_txIndex].confirmations++;

        emit ConfirmTransaction(_txIndex, msg.sender);
    }

    function revokeConfiramation(uint _txIndex) public OnlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        require(confirmations[_txIndex][msg.sender], "Transaction not confirmed");
        
        confirmations[_txIndex][msg.sender] = false;
        transactions[_txIndex].confirmations--;

        emit RevokeConfirmation(_txIndex, msg.sender);
    }

    function executeTransaction(uint _txIndex) public OnlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        require(transactions[_txIndex].confirmations >= required, "Not enough confirmations");
        
        Transaction storage txn = transactions[_txIndex];
        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        
        require(success, "Transaction failed");

        emit ExecuteTransaction(_txIndex, msg.sender);
    }
}
