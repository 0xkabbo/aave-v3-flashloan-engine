# Aave V3 Flash Loan Engine

Flash loans are a powerful DeFi primitive that allow users to borrow any amount of assets from a protocol's reserve without collateral, provided the liquidity is returned within the same transaction.



## Features
* **Aave V3 Integration**: Optimized for the latest Aave "Pool" contracts.
* **Single-Block Execution**: Entire logic (borrow, trade, repay) is atomic.
* **Slippage Protection**: Integrated checks to ensure the transaction reverts if the trade isn't profitable after fees.

## Workflow
1. **Request**: Contract calls the Aave Pool to borrow assets.
2. **Execute**: The `executeOperation` callback is triggered where you perform your logic (e.g., Uniswap swap).
3. **Repay**: The contract automatically returns the loan plus a 0.05% fee to Aave.

## License
MIT
