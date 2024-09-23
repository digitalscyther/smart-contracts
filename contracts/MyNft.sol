// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.8.2 <0.9.0;

contract Nft is ERC721, Ownable {
    uint256 nextTokenId;
    string public baseURI;

    constructor(string memory _nftBaseUri) ERC721("MyNFT", "MNFT") Ownable(msg.sender) {
        baseURI = _nftBaseUri;
    }

    function mint(address to) public onlyOwner {
        _safeMint(to, nextTokenId);
        nextTokenId++;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}