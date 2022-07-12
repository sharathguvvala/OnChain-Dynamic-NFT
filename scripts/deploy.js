
const hre = require("hardhat");

async function main() {

  const contract = await hre.ethers.getContractFactory("DynamicNFT");
  const contractDeployed = await contract.deploy();

  await contractDeployed.deployed();

  console.log("Dynamic NFT Smart Contract deployed to:", contractDeployed.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
