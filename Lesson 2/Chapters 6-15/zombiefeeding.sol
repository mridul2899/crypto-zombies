pragma solidity >=0.5.0 <0.6.0;

// put import statement here
// We use import statements to split our codes into different files,
// hence making the codebase manageable.
import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {
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

        // start here
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        _createZombie("NoName", newDna);
    }
}
