const tokenAddress = '0x...'; // replace with the ERC1155 token contract address
const tokenSymbol = 'TOKEN'; // replace with the token symbol
const tokenDecimals = 18; // replace with the number of decimal places the token uses
const tokenImage = 'https://...'; // replace with the URL of the token image

const tokenData = {
    type: 'ERC1155',
    options: {
        address: tokenAddress,
        symbol: tokenSymbol,
        decimals: tokenDecimals,
        image: tokenImage
    }
};

window.ethereum.request({
    method: 'wallet_watchAsset',
    params: tokenData
}).catch(console.error);