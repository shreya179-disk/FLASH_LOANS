
// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0; //simpleloan

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract simpleflashloan is FlashLoanSimpleReceiverBase{
    address payable owner; //whoevever is requesting for this smart contract

 constructor(address _addressprovider)
    FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressprovider))
    {    
    }
 function FlashloanRequest(address _token, uint256 amount)  public {
    address receiverAddress = address(this);
    address asset = _token;
    uint256 amount =  _amount;
    bytes memory params = "";
    uint16 referralCode = 0;

    POOL.flashLoan( //pool comes from ipooladdressprovider.it requests flashloan from this pool
        receiverAddress,
        asset,
        amount,
        params,
        referralCode
    );
 }
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        uint256 totalAmountPay = amount + premium;
        IERC20(asset).approve(address(POOL), totalAmountPay); // Approve assets to be transferred to this pool
        return true;
    }

    receive() external payable {}
}  
  
