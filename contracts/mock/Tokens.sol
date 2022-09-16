// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Dai is ERC20 {
    constructor() ERC20("Dai", "DAI") {
        _mint(msg.sender, 500000 * 10**18);
    }
}

contract Usdt is ERC20 {
    constructor() ERC20("Tether", "USDT") {
        _mint(msg.sender, 500000 * 10**18);
    }
}

contract Usdc is ERC20 {
    constructor() ERC20("Usdc", "USDC") {
        _mint(msg.sender, 500000 * 10**18);
    }
}
