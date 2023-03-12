require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');
const infuraKey = process.env.INFURA_KEY;
const mnemonic = process.env.MNEMONIC;

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraKey}`),
      network_id: 4,
      gas: 8000000,
      gasPrice: 5000000000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
    mainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://mainnet.infura.io/v3/${infuraKey}`),
      network_id: 1,
      gas: 8000000,
      gasPrice: 5000000000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },
  compilers: {
    solc: {
      version: '0.8.9',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
