pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint256 _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    // To return any value, after public/private add the following:
    // returns (type from_location)
    // For reference types like string, we specify the location from where it is to be returned, like memory

    // If a function is not intended for changing state, i.e., doesn't change any value or write,
    // declare it as a view function, by putting "view" directly after public/private.

    // Pure functions are those functions which do not even read the state.
    // Return value for these functions depend only on the parameters.
    // Use keyword view for them.

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {}
}
