# AuctionContract - Module 2 Final Project

This repository contains the smart contract code for an auction deployed on the Sepolia testnet.

## Description

- Each new bid must be **at least 5% higher** than the current highest.
- If a bid is placed in the last **10 minutes**, the auction extends by **10 more minutes**.
- After the auction ends, the owner can withdraw the winning amount (minus a **2% fee**) and losing bidders can claim their refunds.
- Includes features for **partial withdrawals** and **emergency fund recovery**.


## Contract Deployment

Deployed on Sepolia testnet at:  
https://sepolia.etherscan.io/verifyContract-solc?a=0x49f4a824460C014818606EAAa01c91736E7b5084&c=v0.8.30%2bcommit.73712a01&lictype=3


## Functions

- ### 'placeBid()'
  
    - **Description**: Allows users to place a bid in the auction. The bid must be at least 5% higher than the highest bid. If a bid is placed in the last 10     minutes, the auction time is extended by an additional 10 minutes.

    - **Parameters**:

            msg.value: The bid value in ether (the amount sent with the transaction).

    - **Modifiers**:

            onlyBeforeEnd: Only allows users to place a bid before the auction ends.

    - **Return**:

            Does not return a value. Only emits the NewBid event.

    - **Events**:

            NewBid: Emitted when a new valid bid is placed.

      
    
- ### 'endAuction()'
  
    - **Description**: Ends the auction. Once it ends, no more bids can be placed. This function can only be called by the contract owner after the auction time has expired.

    - **Parameters**: None

    - **Modifiers**

            onlyOwner: Can only be called by the contract owner.
      
            onlyAfterEnd: Can only be called after the auction has ended.

    - **Return**: None. Emits the AuctionEnded event.

    - **Events**:

            AuctionEnded: Emitted when the auction ends. Includes the winner's address and the winning bid amount.
      
  
- ### 'withdraw()'
  
    - **Description**: Allows unsuccessful bidders to withdraw their funds deposited in the contract after the auction ends.

    - **Parameters**: None

    - **Modifiers**: None
      
    - **Return**:

            Returns no value. The transaction transfers the amount to the user's address.

    - **Events**: None

  
- ### 'withdrawPartial()'
    - **Description**: Allows bidders to withdraw a portion of their previous bids, excluding the last valid bid. This enables partial refunds during the auction.

    - **Parameters**: None

    - **Modifiers**: None

    - **Return**:
      
            Returns no value. The transaction transfers the refunded amount to the bidder.

    - **Events**: None
 
      
- ### 'getWinner()': 
    - **Description**: Returns the winning bidder's address and their bid amount. This function can only be called after the auction ends.

    - **Parameters**: None

    - **Modifiers**:

            onlyAfterEnd: Can only be called after the auction ends.

    - **Return**:

            address: Winning bidder's address.

            uint: Winning bid amount.

    - **Events**: None

- ### 'getAllBids(address bidder)'

    - **Description**: Returns a list of all bids placed by a specific bidder. This is useful for tracking a participant's bidding history and validating partial refunds.
    - **Parameters**:

            address bidder: The address of the bidder whose bidding history you want to view.

    - **Modifiers**: None

    - **Return**:

            uint[]: An array of all bids placed by the bidder.

    - **Events**: None
      
 
 - ### 'getBidderCount()'
   
    - **Description**: Returns the total number of bidders who have placed at least one bid in the auction.

    - **Parameters**: None

    - **Modifiers**: None

    - **Return**:

             uint: The total number of bidders.

    - **Events**: None
 
      
  

## Events

- `**NewBid**': Emitted whenever a new valid bid is placed. It includes the address of the bidder and the bid amount.

- '**AuctionEnded**': Emitted once the auction is finalized, indicating the winner's address and the final winning bid amount.



## Constants

- **MIN_BID_INCREMENT**: The minimum bid increment percentage. (105% = 5% higher than the current bid)

- **EXTENSION_TIME**: Time added to the auction if a bid is placed within the last 10 minutes.

- **FEE_PERCENTAGE**: The percentage fee deducted from the final winning bid. (2%)
  



## How to Use

1. **Open Remix IDE**

   - Go to [https://remix.ethereum.org](https://remix.ethereum.org).
   - Create a new file named `AuctionContract.sol`.
   - Copy and paste the contents of this repository’s `AuctionContract.sol` into the file.

2. **Compile the Contract**

   - Go to the **"Solidity Compiler"** tab.
   - Select compiler version **0.8.20** (or `^0.8.20`) to match the pragma in the contract.
   - Click **"Compile AuctionContract.sol"**.

3. **Deploy the Contract**

   - Go to the **"Deploy & Run Transactions"** tab.
   - In "Environment", select **"Injected Provider - MetaMask"** (make sure MetaMask is connected to the **Sepolia testnet**).
   - In the **constructor input**, enter the auction duration in **minutes** (e.g., `60` for a 60-minute auction).
   - Click **"Deploy"**.
   - Approve the transaction in MetaMask.

4. **Interact with the Contract**

   - Use the following public functions during and after the auction:

     - 'placeBid()' → Place a new bid (must be at least 5% higher than the current one).
     - 'withdrawPartial()' → Withdraw previous bids except the latest one (optional, during the auction).
     - 'endAuction()' → End the auction (only after time has expired and only by the owner).
     - 'refundAllNonWinners()' → Refund all non-winning bidders (owner only, after auction ends).
     - 'withdraw()' → Manually withdraw funds if not refunded automatically.
     - 'withdrawFinalAmount()' → Owner withdraws the winning bid minus 2% fee.
     - 'emergencyWithdraw()' → Emergency function to recover all ETH (only if something goes wrong).
     - 'getAllBids(address)' → View a bidder’s complete bidding history.
     - 'getWinner()' → View winner and final bid (after auction ends).

5. **Test the contract**

   - Place bids from multiple accounts in MetaMask.
   - Use 'getBidderCount()' to verify how many bidders participated.
   - After auction ends, use 'getWinner()' to check the result and test withdrawal logic.


## Requirements

- Solidity ^0.8.0.
- Remix IDE (https://remix.ethereum.org/).
- MetaMask wallet connected to Sepolia testnet.
- This project is licensed under the MIT License



---

## Made by: Ivana Papaño ##
