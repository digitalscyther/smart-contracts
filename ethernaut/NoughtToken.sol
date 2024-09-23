// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.8.2 <0.9.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract TokenManager is Ownable {
    address _owner;
    IERC20 public token;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        token = IERC20(_tokenAddress);
    }

    // Get all owner tokens on balance of the smart contract
    function getAllOwnerTokens() external onlyOwner {
        uint256 ownerBalance = token.balanceOf(msg.sender);
        require(token.transferFrom(msg.sender, address(this), ownerBalance), "Transfer failed.");
    }

    // Withdraw all tokens back to the owner
    function withdrawAllTokens() external onlyOwner {
        uint256 contractBalance = token.balanceOf(address(this));
        require(token.transfer(msg.sender, contractBalance), "Withdrawal failed.");
    }
}
