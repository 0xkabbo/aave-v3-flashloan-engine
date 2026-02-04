// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/**
 * @title FlashLoanSimple
 * @dev Contract to execute a single-asset flash loan on Aave V3.
 */
contract FlashLoanSimple is FlashLoanSimpleReceiverBase {
    address payable public owner;

    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) 
    {
        owner = payable(msg.sender);
    }

    /**
     * @notice Initiates the flash loan.
     * @param asset The address of the token to borrow (e.g., USDC).
     * @param amount The amount to borrow.
     */
    function requestFlashLoan(address asset, uint256 amount) public {
        address receiverAddress = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    /**
     * @dev Aave calls this function after transferring the flash loan amount.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // ARBITRAGE OR LIQUIDATION LOGIC GOES HERE
        // Example: Swap borrowed asset for another on Uniswap and swap back
        
        uint256 amountToReturn = amount + premium;
        require(
            IERC20(asset).balanceOf(address(this)) >= amountToReturn,
            "Insufficient funds to repay with premium"
        );

        IERC20(asset).approve(address(POOL), amountToReturn);
        return true;
    }

    function withdraw(address asset) external {
        require(msg.sender == owner, "Only owner");
        IERC20(asset).transfer(owner, IERC20(asset).balanceOf(address(this)));
    }

    receive() external payable {}
}
