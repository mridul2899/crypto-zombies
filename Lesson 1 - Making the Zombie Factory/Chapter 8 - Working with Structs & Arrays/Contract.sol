pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    function createZombie(string memory _name, uint256 _dna) public {
        // Example to use struct - create a new zombie:
        // Zombie zombiename = Zombie("zombiename", 3442349838);
        // Example to add data to array - push created zombie to zombies array:
        // zombies.push(zombiename);
        // Doing it all in one line:

        zombies.push(Zombie(_name, _dna));

        // Push adds element to the end of an array.
        // Moreover, push returns the length of the array after the push.
    }
}
