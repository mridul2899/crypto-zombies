pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    // Events allow contract to communicate from blockchain with any listeners on the front-end.
    // An event is declared first by specifying the name of the event and the parameters to pass.
    // Example: as shown below
    event NewZombie(uint256 id, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint256 _dna) private {
        // push returns the length of the zombies array after pushing.
        // Therefore, here, id is same as the index of the newly created zombie in the array.
        uint256 id = zombies.push(Zombie(_name, _dna)) - 1;

        // Emit an event to the blockchain, i.e., communicate that this event happened.
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
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
