pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    // Solidity also supports arrays.
    // Fixed arrays - length is fixed: uint256[2] fixedArray;
    // Dynamic arrays - no fixed size, can keep growing: uint256[] dynamicArray;

    // Public arrays - Solidity automatically creates a getter method for them.
    // Other contracts will then be able to read data from these arrays, however, not write.
    // Syntax: Zombie[] public zombies;

    Zombie[] public zombies;
}
