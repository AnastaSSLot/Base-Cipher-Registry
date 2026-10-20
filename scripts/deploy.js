const hre = require("hardhat");
async function main() {
  const RegistryData = await hre.ethers.getContractFactory("CipherRegistry");
  const registry = await RegistryData.deploy();
  await registry.deployed();
  console.log("Cipher Registry deployed to:", registry.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
