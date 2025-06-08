// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AuctionContract {
    //Adress of the auction owner
    address public owner;

    //Timestamp when the auction ends
    uint public auctionEndTime;

    //Constants for auction rules


    //Time extension if a bid comes late
    uint public constant EXTENSION_TIME = 10 minutes;

    //105% = must be 5% higher than the current bid
    uint public constant MIN_BID_INCREMENT = 105;

    // 2% Commission
    uint public constant FEE_PERCENTAGE = 2; 

    // Current highest bid and bidder
    address public highestBidder;
    uint public highestBid;

    // Mapping of pending returns (for refunds)
    mapping(address => uint) public pendingReturns;

    // Mapping to store bid history for partial refunds
    mapping(address => uint[]) public bidHistory;


    //Flag to check if auction has ended
    bool public auctionEnded;


    //Event emitted when a new bid is placed
    event NewBid(address bidder, uint amount);

    //Event emitted when the auction ends
    event AuctionEnded(address winner, uint amount);


    // Constructor initializes the auction with a given duration
    constructor(uint _durationMinutes) {
        owner = msg.sender;
        auctionEndTime = block.timestamp + (_durationMinutes * 1 minutes);
    }

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }


    // Modifier: allows only before the auction ends 
    modifier onlyBeforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction already ended");
        _;
    }


    // Modifier: allows only after the auction ends
    modifier onlyAfterEnd() {
        require(block.timestamp >= auctionEndTime, "Auction still active");
        _;
    }


    
    // Function to place a new bid
    function placeBid() public payable onlyBeforeEnd {
        require(msg.value > 0, "Bid must be greater than zero");

        //Calculate minimum required bid (5% higher than current)
        uint minBid = (highestBid * MIN_BID_INCREMENT) / 100;
        require(msg.value >= minBid, "Bid must be at least 5% higher than current");

        //Save bidder's bid for potential partial refund
        bidHistory[msg.sender].push(msg.value);

        //Store the previous highest bid to refund later
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }


        //Update highest bid
        highestBid = msg.value;
        highestBidder = msg.sender;

        
        //Extend auction time if less than 10 minutes remain
        if (auctionEndTime - block.timestamp <= 10 minutes) {
            auctionEndTime += EXTENSION_TIME;
        }

        emit NewBid(msg.sender, msg.value);
    }



    //Ends the auction and emits the result.
    //Can only be called by the owner and after the auction has finished
    function endAuction() public onlyOwner onlyAfterEnd {

        require(!auctionEnded, "Auction already finalized");
        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);

    }

    function withdraw() public {

        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }



    //Partial refund of previous bids
    function withdrawPartial() public {
        uint[] storage bids = bidHistory[msg.sender];
        require(bids.length > 1, "No previous bids to refund");

        //Total up all previous bids except the last one
        uint refundable = 0;
        for (uint i = 0; i < bids.length - 1; i++) {
            refundable += bids[i];
        }

        require(refundable > 0, "No funds to refund");

        //Clear previous bids to avoid double refund
        uint lastBid = bids[bids.length - 1];
        bidHistory[msg.sender] = [lastBid];

        payable(msg.sender).transfer(refundable);
    }



    //Returns the address of the highest bidder and the winning bid amount.
    //Can only be called after the auction has ended.
    function getWinner() public view onlyAfterEnd returns (address, uint) {
        return (highestBidder, highestBid);
    }


    //Returns an array with all bid amounts submitted by a specific bidder.
    //Useful for tracking a participant's bidding history and validating partial refunds.
    function getAllBids(address bidder) public view returns (uint[] memory) {
        return bidHistory[bidder];
    }


    //Allow owner to withdraw final amount minus 2% fee
    function withdrawFinalAmount() public onlyOwner onlyAfterEnd {
        require(auctionEnded, "Auction must be ended first");

        uint fee = (highestBid * FEE_PERCENTAGE) / 100;
        uint payout = highestBid - fee;

        //Reset to prevent re-entrancy
        highestBid = 0;
        payable(owner).transfer(payout);
    }
}




