pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    function _createZombie(string memory _name, uint256 _dna) private {
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;
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
        // require mandates a condition to be true for the following code in the function to be executed.
        // If the condition is not met, the function will throw an error and exit.

        // Note: Solidity doesn't have native string comparison.
        // Therefore, often keccak256 hashes are compared to see if strings are equal.

        require(ownerZombieCount[msg.sender] == 0);

        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
