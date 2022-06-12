pragma solidity ^0.4.25;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint256 _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        // Ethereum has the hash function keccak256 built in, which is a version of SHA3.
        // A hash function maps an input into a random 256-bit hexadecimal number.
        // keccak256 expects a single parameter of type bytes.
        // Therefore, we need to "pack" any parameters before calling keccak256.
        // Example: keccak256(abi.encodePacked("aaaab"));

        // Note: Secure random-number generation in blockchain is a very difficult problem.
        // The method here is insecure, but it works for this example.

        // To typecast in Solidity, simply use type() on the operand.

        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
}
