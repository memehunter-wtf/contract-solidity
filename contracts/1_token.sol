// SPDX-License-Identifier: MIT
//                                                             88                                                               
//                                                             88                                   ,d                          
//                                                             88                                   88                          
// 88,dPYba,,adPYba,   ,adPPYba, 88,dPYba,,adPYba,   ,adPPYba, 88,dPPYba,  88       88 8b,dPPYba, MM88MMM ,adPPYba, 8b,dPPYba,  
// 88P'   "88"    "8a a8P_____88 88P'   "88"    "8a a8P_____88 88P'    "8a 88       88 88P'   `"8a  88   a8P_____88 88P'   "Y8  
// 88      88      88 8PP""""""" 88      88      88 8PP""""""" 88       88 88       88 88       88  88   8PP""""""" 88          
// 88      88      88 "8b,   ,aa 88      88      88 "8b,   ,aa 88       88 "8a,   ,a88 88       88  88,  "8b,   ,aa 88          
// 88      88      88  `"Ybbd8"' 88      88      88  `"Ybbd8"' 88       88  `"YbbdP'Y8 88       88  "Y888 `"Ybbd8"' 88

pragma solidity  ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MemeHunterToken is ERC20 {
    uint256 public supply;

    constructor(
        // address owner,
        string memory name,
        string memory ticker,
        uint256 _supply
    )
    ERC20(name, ticker)
    {
        _mint(msg.sender, _supply);
        supply = _supply;
    }
    
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }

    bool private checkCanTransfer = true;
    mapping (address => bool) private canTransfers;
    modifier canTransfer() {
        if (checkCanTransfer) {
            require(canTransfers[msg.sender] == true, "not allowed");
        }
        _;
    }

    function addCanTransfer(address inp) external  {
        canTransfers[inp] = true;
    }

    function removeCanTransfer(address inp) external  {
        canTransfers[inp] = false;
    }

    function disableCheckCanTransfer() external  {
        checkCanTransfer = false;
    }

    function transfer(address to, uint256 value) public virtual override canTransfer returns(bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

}