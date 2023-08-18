// SPDX-License-Identifier: MIT  //arbitrage
pragma solidity ^0.8.0;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract SimpleFlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner; // whoever is requesting this smart contract

    constructor(address _addressprovider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressprovider))
    {
        owner = payable(msg.sender); // whoever deploys the contract is the owner
    }

    function flashLoanRequest(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoan(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function arbitrageUSDC(address _token, uint256 _amount) private returns (bool) {
        uint256 arbitrageAmount = _amount / 5;
        IERC20 token = IERC20(_token);
        return token.transfer(owner, arbitrageAmount);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        bool status = arbitrageUSDC(asset, amount);
        uint256 totalAmountPay = amount + premium;
        IERC20(asset).approve(address(POOL), totalAmountPay); // Approve assets to be transferred to this pool
        return status;
    }

    receive() external payable {}
}



