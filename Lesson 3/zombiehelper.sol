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

    // Chapter 10 - Saving Gas with 'View' Functions
    // View function are used to only read data from the blockchain.
    // View functions do not cost any gas when they're called externally by a user.
    // This is because view functions don't actually change anything on the blockchain.
    // Therefore, view tells web3.js to query your local Ethereum node to run the function,
    // and it doesn't actually have to create a txn which runs on the blockchain,
    // to be run by every single node and cost gas.
    // Therefore, DApp's gas usage can be optimized using read-only external view functions.

    // Note: If a view function is called internally from another function in the same contract,
    // it will still cost gas because the other function creates a txn on Ethereum,
    // and will still need to be verified from every node.

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        // Chapter 11 - Storage is Expensive
        // Using storage (data location) - particularly writes are expensive operations in Solidity.
        // This is because any change in data is written permanently to the blockchain.
        // And this data is replicated on thousands of nodes.
        // Therefore, to keep costs low, it is important to write to storage only when necessary.
        // This can be inefficiet though especially when copying data into the memory on every call.
        // In Solidity, looping over data is way cheaper than using storage in external view functions,
        // as external view functions don't cost users any gas.

        // Declaring arrays in memory
        // Use memory keyword with arrays to create a new array inside a function
        // This doesn't need writing anything to storage.
        // This array will exist until the end of the function call.
        // Syntax - uint[] memory varName = new uint[](length);

        // Note: Memory arrays must be created with a length argument.
        // They currently cannot be resized unlike storage arrays with array.push().
        // This may change in a future version of Solidity, however.

        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        return result;
    }
}
