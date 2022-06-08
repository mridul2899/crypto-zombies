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

// Chapter 13 - Comments
// It's a good practice to comment your codes.
// Solidity supports multiline comments too /* --- */
// The standard in the Solidity community is to use a format called natspec, which uses tags.
// @title and @author in natspec are straightforward.
// @notice explains to a user what the contract/function does.
// @dev is for explaining extra details to developers.
// @param and @return are for describing parameters and return values of a function.
// While all tags are optional, at least leave a @dev tag for explaining what each function does.
// Natspec tags are preceded by 3 slashes (///).

/// @title A contract that manages transferring zombie ownership.
/// @author mridul2899
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft.
contract ZombieOwnership is ZombieAttack, ERC721 {
    // Chapter 6 - ERC721: Transfer Cont'd - Part 1
    mapping(uint256 => address) zombieApprovals;

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
        // Chapter 10 - SafeMath Part 2
        // library keyword is used instead of contract for libraries.
        // using keyword automatically allows that data type variables to use library methods.
        // Even though some functions like add require 2 arguments,
        // When we call it on a variable, the variable is automatically passed as the first arg.

        // assert is similar to require, where it will throw an error if false.
        // The difference is that require will refund the rest of user's gas, while assert doesn't.
        // Therefore, assert is only used when something goes horribly wrong with the code.
        // Overflow would be one such case.

        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
        // Transfer here is an event described in ERC721 standard,
        // which needs to be fired upon token transfer.

        // Delete approval for zombie, to prevent a loophole
        // Otherwise, suppose owner has approved an address,
        // and then transfers the ownership of the token to another address.
        // The approved address can then call transferFrom to steal the token to whom
        // the owner originally transferred.
        delete zombieApprovals[_tokenId];
    }

    // Chapter 6 - ERC721: Transfer Cont'd - Part 2
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(
            zombieToOwner[_tokenId] == msg.sender ||
                zombieApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    // Chapter 7 - ERC721: Approve
    function approve(address _approved, uint256 _tokenId)
        external
        payable
        onlyOwnerOf(_tokenId)
    {
        zombieApprovals[_tokenId] = _approved;

        // Chapter 8 - ERC721: Approve
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
