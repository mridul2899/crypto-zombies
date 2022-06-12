pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    // In Solidity, functions are public by default.
    // Thus, anyone or any contract can execute the function code.
    // Therefore, it is a good practice to make the functions private by default.
    // Just replace public word in the previous example with private as shown below.
    // Convention: start private function names with an underscore (_).

    function _createZombie(string memory _name, uint256 _dna) private {
        zombies.push(Zombie(_name, _dna));
    }
}
