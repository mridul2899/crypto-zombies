pragma solidity >=0.5.0 <0.6.0;

// Chapter 6 - Import
// put import statement here
// We use import statements to split our codes into different files,
// hence making the codebase manageable.
import "./zombiefactory.sol";

// Chapter 10 - Interacting with Other Contracts
// We need to define an interface to interact with other contracts deployed on the blockchain.
// Even though defining an interface is looks like defining a contract, there are some differences.
// In an interface, we only declare the functions that we want to interact with.
// We don't mention any of the other functions or state variables.
// Moreover, we don't define function bodies.
// Instead of curly braces ({ and }), we end the function declaration with semicolon (;).
// This allows our contract to know what other contract's functions look like, how to call them,
// and what sort of response to expect.

// In Solidity, a function can return more than one values,
// and all such values can be specified after the return keyword within parentheses, separated by commas.

// To interact with CryptoKitties contract on the blockchain.
contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

// Chapter 14 - Wrap Up
// For putting our application built so far into the blockchain, we will need to compile
// and deploy the ZombieFeeding contract, and since it inherits from ZombieFactory,
// that will automatically get taken care of.
contract ZombieFeeding is ZombieFactory {
    // Chapter 11 - Using an Interface
    // To interact with CryptoKitties contract on the blockchain, we first need to have its address.
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;

    // Next we create an instance of the KittyInterface contract,
    // which would point to the CryptoKitties contract.
    // Thereafter, we can call the functions such as getKitty from the interface variable.
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // Chapter 7 - Data Location - Storage & Memory
    // In Solidity, there are two types of locations to store variables - storage and memory.
    // Storage variables are stored permanently on the blockchain.
    // Memory variables are temporary, and are erased between external function calls to the contract.
    // Most times we don't need to use these keywords as Solidity handles these variables automatically.
    // State variables (variables declared outside of functions) are by default storage.
    // Variables declared inside functions are memory.
    // When dealing with reference types, we need to use these keywords within functions.

    // When we change any attribute or object of a storage variable,
    // it permanently changes the original value on the blockchain because it's a pointer.
    // However, memory variable is just a copy of the original variable,
    // and any change will modify only the temporary variable, not the original.
    // Changing the permanent storage value, in this case, would need explicit value change.

    // Chapter 13 - If statements Part 1
    // if statements in Solidity look similar to those in javascript.
    // Modify function definition here:
    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) public {
        require(zombieToOwner[_zombieId] == msg.sender);
        Zombie storage myZombie = zombies[_zombieId];

        // Chapter 8 - Zombie DNA
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        // Chapter 13 - If statements Part 2
        // Add an if statement here
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }

        // Chapter 9 - More on Function Visibility
        // In Chapter 8, we called a private function from within ZombieFeeding.
        // However, it's a private function inside ZombieFactory.
        // This means none of the inherited contracts can access it, and therefore it was a mistake.

        // Soliidity has two more visibility keywords: internal and external.
        // internal is same as private, except that it's accessible from inherited contracts.
        // external is similar to public, except that functions can only be called outside the contract.
        // external functions cannot be called by other functions inside that contract.
        _createZombie("NoName", newDna);
    }

    // Chapter 12 - Handling Multiple Return Values
    // To return multiple values from a function, we simply use return keyword
    // and specify the values to return in paretheses, separated by commas.
    // Similarly, to assign multiple returned values,
    // we put the names of all the variables inside the parentheses, separated by commas,
    // and assign to them the function call.
    // We may leave fields inside the parentheses blank if we only care about certain values
    // among all the returned values while assignment.

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);

        // Chapter 13 - If statements Part 3
        // And modify function call here:
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
