//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import {FlashLoanSimpleReceiverBase} from "/home/shrayank/FlashLoans/node_modules/@aave/core-v3/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import {IPoolAddressesProvider} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "https://github.com/aave/aave-v3-core/blob/master/contracts/dependencies/openzeppelin/contracts/IERC20.sol";


contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(address _addressProvider) 
    FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(message.sender);
    }

    function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
    ) external override returns (bool){
    //we have borrowed funds
    //custom logic
    uint256 amountOwned = amount + premium;
    IERC20(asset).approve(address(POOL),amountOwned);
    return true;    
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        uint16 referralCode = 0;
        bytes memory params = "";

        POOL.flashLoanSimple(receiverAddress,asset,amount,params,referralCode);
    }

    function getBalance(address _tokenAddress) external view returns(uint256) {
        return IERc20(_tokenAddress).balanceof(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC token = IERC20(_tokenAddress);
        token.transfer(msg.sender,token.balance(address(this)));
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only Owner can call this function");
        _;
    }

    receive() external payable{}

}