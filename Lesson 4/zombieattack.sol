pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
    // Chapter 4 - Random Numbers
    // It is not safely possible to generate random numbers in Solidity.
    // Best source of randomness in Solidity is keccak256 hash function.

    // To generate a random number between 1 and 100, we can try doing the following:
    // uint256 randNonce = 0;
    // uint256 random =
    //     uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;
    // randNonce++;
    // Since the above code uses now and an incrementing nonce (a number that is only ever used once),
    // we don't run the same hash function with the same input parameters twice.
    // However, this method is vulnerable to attack by a dishonest node, as described below.

    // Upon calling an Ethereum contract function,
    // you broadcast it to nodes on the network as a transaction.
    // These nodes collect a bunch of transactions,
    // compete to solve a computationally-intensive mathematical problem as a "Proof of Work",
    // and then publish that group of transactions along with their PoW
    // as a block to the rest of the network.

    // Once a node has solved the PoW, the other nodes stop trying to solve the PoW,
    // verify that the other node's list of transactions is valid,
    // and then accept the block and move on to trying solve the next block.
    // A dishonest node can only publish a transaction to their own node and not share it.
    // Then according to the output of the random number, if favourable,
    // include the transaction in the next block it is solving.
    // And if unfavourable, not include the transaction in the next block.
    // And in case that node solves the PoW first, the node will profit according to the outcome.
    // This way, random number functions are exploitable.

    // In practice, however, unless the random function has a lot of money on the line, users of
    // the DApp likely won't have resources to attack it.
    // Oracles (a secure way to pull data in from outside of Ethereum) can generate secure numbers
    // from outside the blockchain.
    // Since the entire contents of the blockchain are visible to all participants,
    // this is a hard problem, out of scope of this tutorial.

    // Some ideas can be found here though:
    // https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract

    uint256 randNonce = 0;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }
}
