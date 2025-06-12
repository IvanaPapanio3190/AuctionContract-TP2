// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AuctionContract {

    //Adress of the auction owner
    address public owner;

    //Timestamp when the auction ends
    uint public auctionEndTime;

    //Highest bid placed in the auction
    uint public highestBid;

    //Address of the user who placed the highest bid
    address public highestBidder;

    //Indicates whether the auction has been finalized
    bool public auctionEnded;

    //Constants

    //105% = must be 5% higher than the current bid
    uint public constant MIN_BID_INCREMENT = 105; 
    //Time extension if a bid comes late
    uint public constant EXTENSION_TIME = 10 minutes;
    //2% Commission
    uint public constant FEE_PERCENTAGE = 2;

    //Track all bidders for refunding later
    address[] public bidders;

    //Mapping to store bid history for partial refunds
    mapping(address => uint[]) public bidHistory;

    //Mapping of pending returns (for refunds)
    mapping(address => uint) public pendingReturns;

    // Events

    //Event emitted when a new bid is placed
    event NewBid(address indexed bidder, uint amount);

    //Event emitted when the auction ends
    event AuctionEnded(address indexed winner, uint amount);

    // Modifiers

    //Restricts function access to the contract owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    //Modifier: allows only before the auction ends 
    modifier onlyBeforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction ended");
        _;
    }

    //Modifier: allows only after the auction ends
    modifier onlyAfterEnd() {
        require(block.timestamp >= auctionEndTime, "Auction active");
        _;
    }

    //Constructor initializes the auction with given duration in minutes
    constructor(uint _durationMinutes) {
        owner = msg.sender;
        auctionEndTime = block.timestamp + (_durationMinutes * 1 minutes);
    }

    //Function to place a new bid
    function placeBid() public payable onlyBeforeEnd {
        require(msg.value > 0, "Zero bid");

        //Calculate minimum required bid (5% higher than current)
        uint minBid = (highestBid * MIN_BID_INCREMENT) / 100;
        require(msg.value >= minBid, "Bid < 5% higher");

        //Save bidder only once
        if (bidHistory[msg.sender].length == 0) {
            bidders.push(msg.sender);
        }

        //Save bidder's bid for potential partial refund
        bidHistory[msg.sender].push(msg.value);

        //Store the previous highest bid to refund later
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }


        //Update highest bid
        highestBidder = msg.sender;
        highestBid = msg.value;

        // Extend time if less than 10 min remaining
        if (auctionEndTime - block.timestamp <= 10 minutes) {
            auctionEndTime += EXTENSION_TIME;
        }

        emit NewBid(msg.sender, msg.value);
    }

    //Ends auction and emit final result
    function endAuction() public onlyOwner onlyAfterEnd {
        require(!auctionEnded, "Already ended");
        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
    }

    //Refund all non-winning bidders using a loop
    function refundAllNonWinners() public onlyOwner onlyAfterEnd {
        uint length = bidders.length;
        for (uint i = 0; i < length; i++) {
            address bidder = bidders[i];
            if (bidder != highestBidder) {
                uint amount = pendingReturns[bidder];
                if (amount > 0) {
                    pendingReturns[bidder] = 0;
                    payable(bidder).transfer(amount);
                }
            }
        }
    }

    //Allows bidders to manually withdraw their pending returns
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    //Withdraw previous bids except the latest one (partial refund)
    function withdrawPartial() public {
        uint[] storage bids = bidHistory[msg.sender];
        uint len = bids.length;
        require(len > 1, "No old bids");

        uint refundable = 0;
        for (uint i = 0; i < len - 1; i++) {
            refundable += bids[i];
        }

        require(refundable > 0, "Nothing to refund");

        //Clear previous bids to avoid double refund
        uint lastBid = bids[len - 1];
        bidHistory[msg.sender] = [lastBid];

        payable(msg.sender).transfer(refundable);
    }

    //Owner withdraws final amount minus 2% fee
    function withdrawFinalAmount() public onlyOwner onlyAfterEnd {
        require(auctionEnded, "Auction not ended");

        uint fee = (highestBid * FEE_PERCENTAGE) / 100;
        uint payout = highestBid - fee;

        // Protect against reentrancy
        highestBid = 0; 
        payable(owner).transfer(payout);
    }

    //Emergency withdrawal in case of stuck funds
    function emergencyWithdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
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

    //Get total number of bidders
    function getBidderCount() public view returns (uint) {
        return bidders.length;
    }
}

