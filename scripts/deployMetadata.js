// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

const main = async () => {
  //Import contracts to deploy
  const MechaoMetadata = await hre.ethers.getContractFactory("MechaoMetadata");
  const mechaoMetadata = await MechaoMetadata.deploy();
  await mechaoMetadata.deployed();
  console.log("mechao Metadata Contract deployed to:", mechaoMetadata.address);
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
