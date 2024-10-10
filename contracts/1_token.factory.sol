// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

//                                                             88                                                               
//                                                             88                                   ,d                          
//                                                             88                                   88                          
// 88,dPYba,,adPYba,   ,adPPYba, 88,dPYba,,adPYba,   ,adPPYba, 88,dPPYba,  88       88 8b,dPPYba, MM88MMM ,adPPYba, 8b,dPPYba,  
// 88P'   "88"    "8a a8P_____88 88P'   "88"    "8a a8P_____88 88P'    "8a 88       88 88P'   `"8a  88   a8P_____88 88P'   "Y8  
// 88      88      88 8PP""""""" 88      88      88 8PP""""""" 88       88 88       88 88       88  88   8PP""""""" 88          
// 88      88      88 "8b,   ,aa 88      88      88 "8b,   ,aa 88       88 "8a,   ,a88 88       88  88,  "8b,   ,aa 88          
// 88      88      88  `"Ybbd8"' 88      88      88  `"Ybbd8"' 88       88  `"YbbdP'Y8 88       88  "Y888 `"Ybbd8"' 88

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./1_token.sol";

contract MemeHunterTokenFactory is Ownable {
    constructor()
    Ownable(msg.sender) {}

    event TokenCreated(address indexed coinAddress);
    function createToken(
        string memory name,
        string memory ticker,
        uint256 supply
    ) external payable returns (address) {
        require(msg.value >= 0.001 ether, "insufficient fee");

        if (msg.value > 0.001 ether) {
            (bool sent, ) = payable(owner()).call{value: msg.value - 0.0009 ether}("");
            require(sent, "failed to send ETH");
        }

        MemeHunterToken t = new MemeHunterToken(name, ticker, supply);
        t.addCanTransfer(address(this));
        t.addCanTransfer(msg.sender);
        t.addCanTransfer(owner());
        t.transfer(owner(), t.supply());
        t.transferOwnership(owner());

        emit TokenCreated(address(t));
        return address(t);
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "insufficient contract balance");
        payable(owner()).transfer(amount);
    }

    receive() external payable {}
}
