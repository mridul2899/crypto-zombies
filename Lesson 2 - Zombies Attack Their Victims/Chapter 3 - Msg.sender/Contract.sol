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

        // In Solidity, there are certain global variables available to all functions.
        // One of these variables is msg.sender, which refers to the address of the caller.
        // This is the address of the person or contract that is executing the function.

        // Note: In Solidity, function execution always needs to start with an external caller.
        // Hence, there will always be a msg.sender.

        // Using msg.sender gives you the security of the Ethereum blockchain.
        // The only way someone can modify someone else's data would be to steal the private key
        // associated with their Ethereum address.

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        // TODO: Confirm if mapping by default assumes the value to be 0 in case of uint for a new key.

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
