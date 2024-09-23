// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.8.2 <0.9.0;

contract NftDs is ERC721Burnable, Ownable {
    string private _baseTokenURI;

    constructor() ERC721("DigitalScyther NFT", "DSNFT") Ownable(msg.sender) {}

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function mint(address to, uint256 tokenId) public onlyOwner {
        _mint(to, tokenId);
    }
}
