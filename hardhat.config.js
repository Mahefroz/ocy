require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
const { API_URL, PRIVATE_KEY, API_KEY, API_KEY_ETHERSCAN } = process.env;

module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: {},
    polygon: {
      url: "https://polygon-rpc.com/",
      accounts: ["23a7522460cc336bf6b1a022c2fb19d684716e77dec7d2d67dca974dbd1135e9"],
    },
  },
  etherscan: {
    apiKey:"MDQAQKFEPWG1ABJ6NA2D8KU4IZBYICC1IN",
  },
};


// module.exports = {
//   solidity: "0.8.0",
//   defaultNetwork: "polygon_mumbai",
//   networks: {
//     hardhat: {},
//     polygon_mumbai: {
//       url: "https://polygon-mumbai.g.alchemy.com/v2/oXGi1fNe-zcHhhYzvLykg4tGFs2jiDyQ",
//       accounts: ["d4b23211147482b911d1e657f89fe2be5207d53e9181bbd10514db90c72bfda5"],
//     },
//   },
//   etherscan: {
//     apiKey: API_KEY,
//   },
// };

// require("@nomicfoundation/hardhat-toolbox");

// /** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.17",
//   networks: {
//     localhost: {
//       live: false,
//       saveDeployments: true,
//       tags: ["local"],
//     },
//   },
// };
