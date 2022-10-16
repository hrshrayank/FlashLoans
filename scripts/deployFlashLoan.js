
const hre = require("hardhat");

async function main() {

  const FlashLoan = await hre.ethers.getContractFactory("FlashLoan");
  const flashLoan = await FlashLoan.deploy("0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D");

  await flashLoan.deployed();

  console.log("Flash Loan deployed:", flashLoan.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
