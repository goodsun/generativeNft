require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100  // 低い値にしてサイズ最適化優先
      },
      viaIR: true  // 追加の最適化
    }
  },
  networks: {
    hardhat: {
      chainId: 31337
    },
    bonsoleil: {
      url: "https://dev2.bon-soleil.com/rpc",
      chainId: 21201,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 20000000000, // 20 gwei
      gas: 6000000
    }
  }
};