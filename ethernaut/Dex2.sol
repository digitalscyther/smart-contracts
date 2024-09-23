// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity >=0.8.2 <0.9.0;

interface IDex {
    function swap(address from, address to, uint256 amount) external;

    function approve(address spender, uint256 amount) external;
}

contract Attacker {
    IDex public dex = IDex(0xee65D001aEf2d27CE9575341B684A2d47b695e20);
    address public token1 = 0xc6A3F717BB073D5Ea5b7D4942C50A6f15ACfA196;
    address public token2 = 0xa87E49456B26ACc279BA4B99B47930c9D8D0D798;
    address public cheatToken1 = 0x6fA805E197f155BC46b73630ef4448cBF03A3b30;
    address public cheatToken2 = 0xAbFd09f2d9A142Dfe258b9C66F97AA05CF343245;

    function attack() public {
        
    }
}

contract CheatToken is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}