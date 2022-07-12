
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

// smart contract address 0x626950595e5bf87e2a4857de36d939262098c259