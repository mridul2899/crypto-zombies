pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    // Chapter 8 - Function Modifiers with Arguments
    // Function modifiers can also take arguments just like functions.
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // This modifier is now used just like functions,
    // after specifying after specifying function's arguments.
    // Example: function name(type arg1) public aboveLevel(1, 2) {}

    // Chapter 9 - Zombie Modifiers
    // Note: Data location calldata is somehow similar to memory,
    // but only available to external functions.
    // TODO: Find more on difference between calldata and memory.

    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }
}
