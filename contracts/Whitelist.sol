//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Whitelist {
    // Maximum number of whitelisted addresses for minting NFT for free when cryptodevs is launched
    uint8 public maxWhitelistedAddresses;

    // This mapping keeps track of whitelisted addresses
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted keeps track of how many addresses have been whitelisted
    uint8 public numAddressesWhitelisted;

    // Constructor initialises the maximum number of addresses which can be whitelisted
    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    function addAddressToWhitelist() public {
        //Checking if the address is already listed
        require(!whitelistedAddresses[msg.sender], "Address already listed!");

        //Checking if Maximum number of addresses to be listed is reached
        require(
            numAddressesWhitelisted < maxWhitelistedAddresses,
            "Maximum number of accounts listed"
        );

        whitelistedAddresses[msg.sender] = true;
        numAddressesWhitelisted += 1;
    }
}
