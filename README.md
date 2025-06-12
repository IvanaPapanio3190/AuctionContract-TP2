# AuctionContract - Module 2 Final Project

This repository contains the smart contract code for an auction deployed on the Sepolia testnet.

## Description

This smart contract implements an auction with bids increasing by at least 5%, supports partial refunds, and extends auction time for last-minute bids. 
It charges a 2% fee on the final winning bid.


## Deployment

Deployed on Sepolia testnet at:  
https://sepolia.etherscan.io/verifyContract-solc?a=0x49f4a824460C014818606EAAa01c91736E7b5084&c=v0.8.30%2bcommit.73712a01&lictype=3


## Functions

- '**placeBid()**'
  
    - **Description**: Allows users to place a bid in the auction. The bid must be at least 5% higher than the highest bid. If a bid is placed in the last 10     minutes, the auction time is extended by an additional 10 minutes.

    - **Parameters**:

        msg.value: The bid value in wei (the amount sent with the transaction).

    - **Modifiers**:

        onlyBeforeEnd: Only allows users to place a bid before the auction ends.

    - **Return**:

        Does not return a value. Only emits the NewBid event.

    - **Events**:

        NewBid: Emitted when a new valid bid is placed.

      
    
- '**endAuction()**'
  
    - **Description**: Ends the auction. Once it ends, no more bids can be placed. This function can only be called by the contract owner after the auction time has expired.

    - **Parameters**: None

    - **Modifiers**

       onlyOwner: Can only be called by the contract owner.

       onlyAfterEnd: Can only be called after the auction has ended.

    - **Return**: None. Emits the AuctionEnded event.

    - **Events**:
        AuctionEnded: Emitted when the auction ends. Includes the winner's address and the winning bid amount.
      
  
- '**withdraw()**'
  
    - **Description**: Allows unsuccessful bidders to withdraw their funds deposited in the contract after the auction ends.

    - **Parameters**: None

    - **Modifiers**: None
      
    - **Return**:

        Returns no value. The transaction transfers the amount to the user's address.

    - **Events**: None

  
- '**withdrawPartial()**'
    - **Description**: Allows bidders to withdraw a portion of their previous bids, excluding the last valid bid. This enables partial refunds during the auction.

    - **Parameters**: None

    - **Modifiers**: None

    - **Return**:
        Returns no value. The transaction transfers the refunded amount to the bidder.

    - **Events**: None
 
      
- '**getWinner()**': 
    - **Description**: Returns the winning bidder's address and their bid amount. This function can only be called after the auction ends.

    - **Parameters**: None

    - **Modifiers**:

        onlyAfterEnd: Can only be called after the auction ends.

    - **Return**:

        address: Winning bidder's address.

        uint: Winning bid amount.

    - **Events**: None

- '**getAllBids(address bidder)**': Returns a list of all bids placed by a specific bidder address.
  

## Events

- `**NewBid**': Emitted whenever a new valid bid is placed. It includes the address of the bidder and the bid amount.

- '**AuctionEnded**': Emitted once the auction is finalized, indicating the winner's address and the final winning bid amount.
  

## How to Use

**1**. Open the 'AuctionContract.sol' file in Remix.

**2**. Compile the contract with Solidity compiler version .

**3**. Deploy the contract on the Sepolia testnet providing the auction duration in minutes.

**4**. Use the public functions to place bids, withdraw funds, and check the auction status.


## Requirements

- Solidity ^0.8.0.
- Remix IDE (https://remix.ethereum.org/).
- MetaMask wallet connected to Sepolia testnet.
- This project is licensed under the MIT License



---

## Made by: Ivana Papaño ##
