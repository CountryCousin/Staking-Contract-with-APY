// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    uint public constant maxTotalSupply = 10000000 * 10 ** 18;

    constructor() ERC20("Degen Gas", "DEG") {}

    function mint(uint _amount) internal {
        _mint(msg.sender, _amount);
    }
}