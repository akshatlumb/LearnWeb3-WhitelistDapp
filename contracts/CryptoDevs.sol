//SPDX-License-Identifier: MITJ

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    //Setting the price of NFT and maximum number of them to be released
    uint256 public constant _price = 0.01 ether;
    uint256 public constant maxTokenIds = 20;

    //An instance of Whitelist contract
    Whitelist whitelist;

    uint256 public reservedTokens;
    uint256 public reservedTokensClaimed = 0;

    //Constructor is initialising whitelist contract instance at a given address
    constructor(address whitelistContractAddress) ERC721("CryptoDevs", "CD") {
        whitelist = Whitelist(whitelistContractAddress);
        reservedTokens = whitelist.maxWhitelistedAddresses();
    }

    function mint() public payable {
        //Making sure that we always leave room for reserved tokens
        require(
            totalSupply() + reservedTokens - reservedTokensClaimed <
                maxTokenIds,
            "EXCEEDED_MAX_SUPPLY"
        );
        //Checking if the account is whitelisted and in that case the sender sends less eth than price
        if (whitelist.whitelistedAddresses(msg.sender) && msg.value < _price) {
            //Checking if sender already owns an NFT
            require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");
            reservedTokensClaimed += 1;
        } else {
            require(msg.value > _price, "NOT_ENOUGH_ETH");
        }

        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
