pragma solidity >=0.5.0 <0.6.0;

// Chapter 2 - Ownable Contracts
// In the last chapter, anyone can change the address of the contract by calling the external function.
// Therefore, we would rely on Ownable contracts from OpenZeppelin to secure our DApp.
// Ownable contract does the following:
// 1. When a contract is created, it sets the owner to msg.sender (person who deployed it)
// 2. It adds an onlyOwner modifier, which can restrict access to certain functions to only the owner
// 3. It allows transferring ownership of a contract to a new owner.

// Note:
// A constructor is an optional function with the same name as the contract.
// It gets executed only once, when the contract is first created.

// Note:
// Function modifiers are kind of half-functions used to modify other functions.
// These are usually used to check some requirements before executing the function.

import "./ownable.sol";

contract ZombieFactory is Ownable {
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    // Chapter 5 - Time Units, Part 1
    // In Solidity, variable now returns the current unix timestamp of the latest block.
    // This is the time in seconds since Jan 1, 1970.
    // Although unix time is usually stored in 32-bit uints, this will lead to overflow in 2038.
    // Using a 64-bit uint would be costly for users in terms of gas, leading to a tradeoff.

    // Solidity also has time units - seconds, minutes, hours, days, weeks and years.
    // These convert uint into number of seconds contained in the unit.

    uint256 cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint256 dna;
        // Chapter 4 - Gas
        // In solidity, users have to pay a currency called gas
        // every time they execute a DApp function.
        // Users buy gas with Ether on Ethereum, and therefore need to spend ETH.
        // The amount of gas required depends on complexity of the function's logic.
        // Each individual operation has a gas cost based on computing resources needed.
        // For example, storage is much more expensive than adding two integers.
        // Hence, code optimization is very important in Ethereum.
        // Gas is necessary to prevent Ethereum network from clogging by intensive
        // computations set by malicious users.

        // Struct packing
        // Normally there is no benefit of using uint8, uint16, uint32 etc.
        // as Solidity reserves 256 bits of storage regardless of the uint size.
        // But there is an exception in case of structs.
        // Using smaller-sized uints inside structs allows Solidity to pack variables together.
        // Thus, they end up taking lesser storage.
        // Moreover, clustering identical data types together can
        // minimize the required storage space.

        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    function _createZombie(string memory _name, uint256 _dna) internal {
        // Chapter 5 - Time Units, Part 2
        // In the below line of code,
        // it is necessary to typecast to uint32 because now returns a uint256 by default.
        uint256 id = zombies.push(
            Zombie(_name, _dna, 1, uint32(now + cooldownTime))
        ) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint256 randDna = _generateRandomDna(_name);
        randDna = randDna - (randDna % 100);
        _createZombie(_name, randDna);
    }
}
