pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    // Function declaration in Solidity looks like:
    // function functionName(reference_type memory _a, type _b, ...) public {
    // }

    // In reference types, function is called with a reference to the original variable.
    // For reference types like strings, arrays, structs, mappings, we store variables in memory
    // Therefore we add the keyword memory.

    // In value types, Solidity creates a new copy of param's value and passes it to function.
    // For value types we directly specify the parameter name.

    // public keyword allows the function to be called by other contracts.

    // It is a convention to use underscore (_) before param names to differentiate them from global variables.

    function createZombie(string memory _name, uint256 _dna) public {}
}
