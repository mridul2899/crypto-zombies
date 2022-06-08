pragma solidity >=0.5.0 <0.6.0;

// Chapter 1 - Tokens on Ethereum
// A token on Ethereum is a smart contract that follows some common rules.
// It has to implement a standard set of functions that all other token contract shares.
// Internally, the smart contract has a mapping that keeps track of balance of each address.
// A token, therefore, is a contract that keeps track of who owns how much of that token,
// and some functions so those users can transfer their tokens to other addresses.
// Example - ERC20 tokens

// Since all ERC20 tokens share the same set of functions with the same names,
// they all can be interacted with in the same ways.
// Thus, any DApp capable of interacting with one token can interact with all.
// Thus, more tokens can be added easily to the app in future, by just specifiying token address.

// For this app, ERC20 tokens are not relevant though - ERC20 tokens can be owned in fractions.
// Moreover, their actual units are equal, unlike levels of Zombies.
// ERC721 tokens are not interchangeable since each one is assumed to be unique, and are not divisible.
// Each has a unique id and can only be traded in whole units.

// Benefit of using standard tokens like ERC721
// -> No need to implement the auction or escrow logic separately.
// -> Someone else can build an exchange for ERC721 and our tokens can be used there too.

import "./zombieattack.sol";

// Chapter 2 - ERC721 Standard, Multiple Inheritance
// When implementing a token contract, copy the interface to its own Solidity file and import it.
// In Solidity, a contract can inherit from multiple contracts, separated by commas.

import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    // Chapter 3 - balanceOf & ownerOf
    function balanceOf(address _owner) external view returns (uint256) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return zombieToOwner[_tokenId];
    }

    // Chapter 5 - ERC721: Transfer Logic
    // ERC721 spec has 2 different ways to transfer tokens:
    // 1. Token's owner calls transferFrom with their address as the _from,
    // receiver's address as the _to, and the _tokenId of the token to transfer.
    // 2. Token's owner first calls approve with the _to address and _tokenId.
    // The approved address is usually stored in a mapping.
    // Then the approved receiver calls transferFrom.

    // transferFrom checks whether msg.sender is owner or approved receiver.
    // If yes, the token gets transferred.

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        ownerZombieCount[_to]++;
        ownerZombieCount[_from]--;
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
        // Transfer here is an event described in ERC721 standard,
        // which needs to be fired upon token transfer.
    }
}
