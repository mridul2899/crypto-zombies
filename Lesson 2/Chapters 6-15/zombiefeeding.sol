pragma solidity >=0.5.0 <0.6.0;

// Chapter 6 - Import
// put import statement here
// We use import statements to split our codes into different files,
// hence making the codebase manageable.
import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
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

    function feedAndMultiply(uint256 _zombieId, uint256 _targetDna) public {
        require(zombieToOwner[_zombieId] == msg.sender);
        Zombie storage myZombie = zombies[_zombieId];

        // Chapter 8 - Zombie DNA
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

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
}
