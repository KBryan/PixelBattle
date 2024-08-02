# PixelBattle
Welcome to this tutorial, where we will dive into blockchain game development using Solidity, the programming language for Ethereum smart contracts. This tutorial is designed for beginners in Solidity and game development on the blockchain. This contract needs to be audited. It has not been checked for security problems and is more of an introduction to blockchain game mechanics. All contracts deployed to the mainnet need to be audited to ensure the safety of your users.

Understanding the Smart Contract
Our focus will be on a simple game structured through a Solidity smart contract called PixelBattle. This game allows up to four players to deposit Ethereum into a shared pot, with the owner having the authority to start and end the game and declare a winner who receives the total prize. Do you want to see this tutorial? Give this article a clap, and I’ll add it.

The Contract Setup
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract PixelBattle {
    ...
}
SPDX-License-Identifier: This line specifies the license under which this contract is released. Here, it’s MIT.
pragma solidity ^0.8.22: Specifies the Solidity compiler version.
State Variables and Events
Inside PixelBattle, we have several state variables and events:

mapping (address => uint) private balances;
address public owner;
address[4] private players;
uint private playerCount;
bool private gameStarted;
bool private gameEnded;

event LogDepositMade(address indexed accountAddress, uint amount);
event LogGameEnded(address indexed winner, uint amount);
balances: A mapping to track the balance of each player.
owner: The address of the game's owner.
players: An array to store up to four players.
playerCount: A counter for the number of players.
gameStarted and gameEnded: Booleans will track the game's status.
LogDepositMade and LogGameEnded: Events to log critical actions.
Now, let’s break this down a little.

1. mapping (address => uint) private balances;

- This line declares a private state variable named balances, which is a mapping.

- A mapping in Solidity is like a hash table or dictionary in other languages. It maps keys to values.

- Here, the key is an address, and the value is an uint (unsigned integer, meaning it can only be a non-negative number).

- address is a special type in Solidity for storing Ethereum addresses.

- This mapping keeps track of each address's balance (in ether, for example). It's private, so it can only be accessed and modified by the contract.

2. address public owner;

- This is a state variable named owner of type address.

- It's declared public, meaning Solidity automatically generates a getter function. This allows other contracts and clients to read its value but not modify it directly.

3. address[4] private players;

- This line declares a private state variable players, which is a fixed-size array of address elements.

- The array size is 4, meaning it can contain the addresses of up to 4 players.

4. uint private playerCount;

- This declares a private state variable playerCount of type uint.

- It's likely used to track how many players are in the game.

5. bool private gameStarted;

- This is a boolean (true/false) state variable named gameStarted.

- It's private, meaning it can only be accessed within the contract.

- It's likely used to track whether the game has started.

6. bool private gameEnded;

- Similarly, gameEnded is a boolean state variable used to indicate whether the game has ended.

7. event LogDepositMade(address indexed accountAddress, uint amount);

- This line declares an event named LogDepositMade.

- Events in Solidity are a way for contracts to communicate that something has happened to the blockchain, which can be listened for in the user interface.

- This particular event is fired when a deposit is made. It includes an indexed parameter accountAddress, which helps filter the logs for this specific address, and a regular parameter amount, the amount of ether deposited.

8. event LogGameEnded(address indexed winner, uint amount);

- This is another event, LogGameEnded, indicating the end of the game.

- It includes the winner's address (as an indexed parameter) and the amount won.

The Constructor
    constructor() {
        owner = msg.sender;
        playerCount = 0;
        gameStarted = false;
        gameEnded = false;
    }
The constructor sets the contract deployer as the owner and initializes the game state.

Game Management Functions
startGame
function startGame() public {
    require(msg.sender == owner, "Only owner can start the game");
    require(!gameStarted, "Game already started");
    gameStarted = true;
    gameEnded = false;
    playerCount = 0;
}
startGame is called by the owner to start a new game, ensuring that no game is currently running.

Okay, now we will also break this down.

deposit
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
Players use deposit to join the game by sending exactly 0.08 Ether. It checks if the game has started, is incomplete, and the player still needs to join.

endGameAndPayWinner
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
This function allows the owner to end the game, declare a winner, and transfer the total prize to the winner’s address. It also resets the game state.

Utility Function
balance
    function balance() public view returns (uint) {
        return balances[msg.sender];
    }
balance Let players check their deposited balance in the game.


