### AuctionContract - Module 2 Final Project 

### This repository contains the smart contract code for an auction deployed on the Sepolia testnet.
Description This smart contract implements an auction with bids increasing by at least 5%, supports partial refunds, and extends auction time for last-minute bids. 
It charges a 2% fee on the final winning bid.

### Deployment Deployed on Sepolia testnet at:
https://sepolia.etherscan.io/verifyContract-solc?a=0xe36433FD78dD32d61d283aDA82B4176b058D0F3a&c=v0.8.30%2bcommit.73712a01&lictype=3 


### Functions 

### 'placeBid()': Allows users to place a new bid. The bid must be at least 5% higher than the current highest bid. 
The function also handles refunding the previous highest bidder and extends the auction time if a bid is placed in the last 10 minutes. 

### 'endAuction()': Can only be called by the owner after the auction time ends. 
It finalizes the auction, preventing further bids, and emits an event with the winner's address and winning bid. 

### 'withdraw()': Allows users who did not win to withdraw their refundable deposits safely. 

### 'withdrawPartial()': Allows bidders to partially refund their previous bids except for their latest valid bid.
This enables users to get back funds from earlier bids during the auction.

### 'getWinner()': Returns the address of the winning bidder and the amount of the winning bid. Only callable after the auction has ended.

### 'getAllBids(address bidder)': Returns a list of all bids placed by a specific bidder address. 

### Events 

'NewBid': Emitted whenever a new valid bid is placed. It includes the address of the bidder and the bid amount.
'AuctionEnded': Emitted once the auction is finalized, indicating the winner's address and the final winning bid amount. 

### How to Use 

- 1. Open the 'AuctionContract.sol' file in Remix. 
- 2. Compile the contract with Solidity compiler version. 
- 3. Deploy the contract on the Sepolia testnet providing the auction duration in minutes. 
- 4. Use the public functions to place bids, withdraw funds, and check the auction status.

### Requirements 

- Solidity ^0.8.0.
- Remix IDE (https://remix.ethereum.org/).
- MetaMask wallet connected to Sepolia testnet. 
- This project is licensed under the MIT License 


---

Made by: Ivana Papaño
