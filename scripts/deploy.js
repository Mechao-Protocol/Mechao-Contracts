// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  //Import contracts to deploy
  const MechaoDomainFactory = await hre.ethers.getContractFactory(
    "MechaoDomainFactoryV2"
  );


  const MechaoDomainHub = await hre.ethers.getContractFactory(
    "MechaoDomainHub"
  );

  const MechaoDomainResolver = await hre.ethers.getContractFactory(
    "MechaoDomainResolver"
  );


  const ForbiddenTlds = await hre.ethers.getContractFactory("ForbiddenTldsV2");

  const metadataAddress = "0x652182af1c9114d6D01CceA127cc3EaFebCCFD9F";

  const royaltyAddress = "0xaF93083C3c81e7070c520bfe72CD0B96FA916cd0";

  const mechaoHub = await MechaoDomainHub.deploy(metadataAddress);
  await mechaoHub.deployed();
  const hubAddress = mechaoHub.address;

  const mechaoResolver = await upgrades.deployProxy(MechaoDomainResolver);
  await mechaoResolver.deployed();

  const resolverAddress = mechaoResolver.address;

  console.log("resolver Address:", resolverAddress);

  await mechaoResolver.addHubAddress(hubAddress, { gasLimit: 1000000 });

  const forbiddenTlds = await ForbiddenTlds.deploy(hubAddress);
  await forbiddenTlds.deployed();
  const forbiddenTldsAddress = forbiddenTlds.address;

  const mechaoFactory = await MechaoDomainFactory.deploy(
    0,
    forbiddenTldsAddress,
    metadataAddress,
    hubAddress,
    royaltyAddress
  );
  await mechaoFactory.deployed();
  const factoryAddress = mechaoFactory.address;

  await mechaoResolver.addFactoryAddress(factoryAddress);

  await forbiddenTlds.addFactoryAddress(factoryAddress);

  const init = await mechaoHub.init(
    mechaoFactory.address,
    forbiddenTldsAddress
  );
  await init.wait();

  const toogle = await mechaoFactory.toggleBuyingTlds();
  await toogle.wait();

  console.log("mechaoDomainHub deployed to: ", hubAddress);
  console.log("mechaoDomainFactory deployed to: ", factoryAddress);
  console.log("forbiddenTlds deployed to: ", forbiddenTldsAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
