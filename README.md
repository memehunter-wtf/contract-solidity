# MemeHunter Smart Contracts

MemeHunter is a revolutionary Meme Coin Launchpool, created to offer a more secure and rewarding environment for both token developers and meme coin enthusiasts. Our contracts solve the most pressing problems in the meme coin ecosystem, ensuring long-term success and fairness for all participants.

## What is MemeHunter?

MemeHunter improves the current meme coin ecosystem by addressing the limitations of existing liquidity pools and "pump-and-dump" schemes. It introduces the following key features:

### Token Developer Vesting
Ensures that developers are committed to their projects long-term by establishing custom vesting schedules for their tokens.

### Trading Fee Sharing
Enables developers to earn a share of trading fees, fostering sustainable project growth.

### Revenue Resharing
Distributes a portion of the project’s revenue back to the community, rewarding users for their participation.

These features provide a safer, more transparent environment, promoting trust between token developers and the community.

## Problems We Solved

MemeHunter solves three critical issues in meme coin projects:

1. **Honeypot**: Scams where users buy tokens but are unable to sell them.
2. **Rug Pull**: Developers suddenly withdrawing liquidity, leaving investors with worthless tokens.
3. **Dev Dumping Supply**: Developers dumping tokens to cash out, leaving the community at a loss.

While many launchpools provide smart contracts and burned liquidity pool tokens, they still fail to protect investors from developers who dump on them. MemeHunter solves this by allowing reputable developers to establish vesting schedules for their tokens, thus increasing investor confidence.

## How Does It Work?

MemeHunter ensures fairness by implementing coin vesting schedules and revenue-sharing mechanisms. When a developer’s token hits Uniswap from the Liquidity Pool (LP), the ETH earned is split among MemeHunter, $bullets Token Generation Event (TGE), and the token developer.

In addition, LP rewards (tokens earned) are distributed to users in exchange for their bullet Points, incentivizing community participation and engagement.

For more information on how liquidity pools and bullet Points work, please see the relevant sections of this repository.

## Why Developers Should Launch With MemeHunter

Most token developers dump their tokens on users shortly after launch, with 99.9% doing so within the first hour. MemeHunter solves this by vesting tokens over time, preventing the developer from dumping, while still allowing them to benefit from trading fees and revenue sharing. This creates a fairer and more sustainable ecosystem for both developers and investors.

---

## Getting Started

### Prerequisites

To work with MemeHunter's smart contracts, you'll need the following:

- Node.js
- Hardhat or Truffle framework for smart contract development
- A supported Ethereum wallet (MetaMask, etc.)

### Installing

1. Clone the repository:

    ```bash
    git clone git@github.com:memehunter-wtf/contract-solidity.git
    ```

### Running Tests

To run the smart contract tests, you can use hardhat or remix:

```bash
npx hardhat test
