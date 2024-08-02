// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract PixelBattle {
    mapping (address => uint) private balances;
    address public owner;
    address[4] private players;
    uint private playerCount;
    bool private gameStarted;
    bool private gameEnded;

    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogGameEnded(address indexed winner, uint amount);

    constructor() {
        owner = msg.sender;
        playerCount = 0;
        gameStarted = false;
        gameEnded = false;
    }

    function startGame() public {
        require(msg.sender == owner, "Only owner can start the game");
        require(!gameStarted, "Game already started");
        gameStarted = true;
        gameEnded = false;
        playerCount = 0;
    }

    function deposit() public payable returns (uint) {
        require(gameStarted, "Game has not started");
        require(!gameEnded, "Game has ended");
        require(msg.value == 0.08 ether, "Deposit must be exactly 0.08 ETH");
        require(playerCount < 4, "Game is full");

        for(uint i = 0; i < playerCount; i++) {
            require(players[i] != msg.sender, "Player already joined");
        }

        balances[msg.sender] += msg.value;
        players[playerCount] = msg.sender;
        playerCount++;

        emit LogDepositMade(msg.sender, msg.value);

        return balances[msg.sender];
    }

    function endGameAndPayWinner(address winner) public {
        require(msg.sender == owner, "Only owner can end the game");
        require(gameStarted, "Game has not started");
        require(!gameEnded, "Game has already ended");
        require(playerCount == 4, "Game is not full yet");

        uint totalPrize = address(this).balance;
        payable(winner).transfer(totalPrize);
        emit LogGameEnded(winner, totalPrize);

        // Reset the game
        for(uint i = 0; i < playerCount; i++) {
            balances[players[i]] = 0;
        }
        gameEnded = true;
        gameStarted = false;
    }

    function balance() public view returns (uint) {
        return balances[msg.sender];
    }
}
