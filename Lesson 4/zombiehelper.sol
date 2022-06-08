pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    // Chapter 1 - Payable - Part 1
    // Payable functions are special functions that can receive Ether.
    // msg.value is a way to see how much Ether was sent to the contract.
    // Ether is a built-in unit.
    // Note: A non-payable function rejects the transaction on trying to send it Ether.

    uint256 levelUpFee = 0.001 ether;

    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // Chapter 2 - Withdraw
    // We write a function to withdwal Ether from the contract.
    // Note: You cannot transfer Ether to an address unless that address is of type address payable.
    // Since _owner variable is type of uint160, it is necessary to typecast it to address payable.
    // Then, transfer function can be used to transfer Ether to this address.
    // address(this).balance returns the total balance stored on the contract.
    // Also, using msg.sender.transfer, it is possible to send money back to the sender.

    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }

    function setLevelUpFee(uint256 _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // Chapter 1 - Payable - Part 2
    function levelUp(uint256 _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

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

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
