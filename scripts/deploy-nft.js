const hre = require("hardhat");

const contractAddress = "0xF3c6749c46768E0fd1DCDEF71be5026E2dCE214f";

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

//Deploying crypto devs contract
async function main() {
  const nftContract = await hre.ethers.deployContract("CryptoDevs", [
    contractAddress,
  ]);
  
  //Wait for the contract to deploy
  await nftContract.waitForDeployment()

  console.log("NFT contract deployed at: ", nftContract.target)

  await sleep(30*1000)

  await hre.run("verify:verify",{
    address: nftContract.target,
    constructorArguments: [contractAddress],
  })
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });