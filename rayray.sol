// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";

contract Cryptorayrays is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string _baseTokenURI;
    uint256 private _reserved = 500;
    uint256 private _giveAwayCount = 0;
    uint256 private _price = 0.0189 ether;
    bool public _paused = true;

    address t1 = 0xA934E7185D28A77d1c619601EA1F06b1f1D274B1;

    // Crypto rayrays
    // 9999 dogs in total
    constructor(string memory baseURI) ERC721("Cryptorayrays", "rayrays") {
        setBaseURI(baseURI);
    }

    function adopt(uint256 num) public payable {
        uint256 supply = totalSupply();
        require(!_paused, "Sale paused");
        require(num < 10, "You can adopt a maximum of 10 NFT");
        require(supply + num < 10000 - _reserved, "Exceeds maximum NFT supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        for (uint256 i = 0; i < num; i++) {
            uint256 mintIndex = totalSupply();
            if (totalSupply() < 10000) {
                _safeMint(msg.sender, 500 + mintIndex);
            }
        }
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    // Just in case Eth does some crazy stuff
    function setPrice(uint256 _newPrice) public onlyOwner {
        _price = _newPrice;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getPrice() public view returns (uint256) {
        return _price;
    }

    function giveAway(address _to, uint256 _amount) external onlyOwner {
        require(_amount <= _reserved, "Exceeds reserved NFT supply");
        require(_giveAwayCount < 500, "Exceeds reserved NFT supplyCount");

        // uint256 supply = totalSupply();
        for (uint256 i; i < _amount; i++) {
            if (_giveAwayCount < 500) {
                _safeMint(_to, _giveAwayCount);
                _giveAwayCount++;
            }
        }

        _reserved -= _amount;
    }

    function pause(bool val) public onlyOwner {
        _paused = val;
    }

    function withdrawAll() public payable onlyOwner {
        require(payable(t1).send(address(this).balance));
    }
}
