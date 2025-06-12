# Changelog - AuctionContract

## Second Submission – June 2025

### Fixes and Improvements

-  **Bid Validation Fixed:** Corrected logic to ensure new bids are at least 5% higher than the current highest bid.
-  **Auction Time Extension:** Implemented automatic 10-minute extension when bids are placed within the final 10 minutes.
-  **Partial Refunds:** Added 'withdrawPartial()' allowing users to recover all previous bids except their latest.
-  **Emergency Withdraw:** Introduced 'emergencyWithdraw()' for the contract owner to recover all funds in case of emergency.
-  **Improved Withdrawals:** Enhanced 'withdraw()' logic to handle pending returns more securely after auction ends.
-  **New Helper Functions:** Added 'getBidderCount()' and improved 'getAllBids()' to allow better tracking of participant history.


### Documentation

-  **README Overhaul:** Complete rewrite of the README with detailed instructions for deployment, testing, and usage.
-  **Contract Link:** Included a direct link to the deployed contract on the Sepolia testnet.
-  **Usage Instructions:** Step-by-step guidance on compiling, deploying, and interacting with the contract via Remix and MetaMask.
