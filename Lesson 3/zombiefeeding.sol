pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract ZombieFeeding is ZombieFactory {
    // Chapter 1 - Immutability of Contracts
    // Ethereum DApps are quite different from normal applications in a number of ways.
    // Once a contract is deployed to Ethereum, it is immutable.
    // The initial code for the contract stays permanently on the blockchain.
    // Therefore, security is a huge concern in Solidity.
    // The only way to fix flaws would be to give your users a new address for corrected contract.

    // In previous lesson, we had hard-coded the CryptoKitties contact address.
    // Therefore it is better to have functions to allow updating the key portions of the DApp.
    // We have therefore removed the hard-coded address assignment and added the function.

    KittyInterface kittyContract;

    // Chapter 3 - onlyOwner Function Modifier
    // Function modifier uses the keyword "modifier" instead of the keyword "function".
    // It cannot be directly called unlike functions,
    // and can only be attached at the end of a function definition
    // to change the function's behaviour.
    // When a function with onlyOwner modifier is called,
    // it first executes the code within the modifier.
    // Once it hits the _; statement in onlyOwner,
    // it goes back and executes the code inside the function.

    // Note:
    // Giving owner special powers can also be used maliciously.
    // For example, the owner can add a backdoor function
    // that can make them take ownership of all the zombies.
    // Therefore, we need to read the source code to make sure a
    // DApp on Ethereum is actually decentralized.

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // Chapter 6 - Passing Structs as Arguments
    // It is possible to pass a storage pointer to a struct
    // as an argument to a private or internal function.
    // Syntax: function _doStuff(Zombie storage _zombie) internal {}
    // This way we can pass a reference to a struct into a function instead of looking it up with id.

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
