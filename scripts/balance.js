

async function main() {
const { ethereum } = window;
      
       const getContractInstance = async () => {
    if (typeof window !== undefined) {
      if (ethereum) {
        // const accounts = await ethereum.request({
        //   method: "eth_requestAccounts",
        // });
        // await setAccount(accounts);
        // const alchemyProvider = new ethers.providers.AlchemyProvider(
        //   "Network.MATIC_MUMBAI",
        //   "oXGi1fNe-zcHhhYzvLykg4tGFs2jiDyQ"
        // );
        const accounts = await ethereum.request({
          method: "eth_requestAccounts",
        });

        // const provider = new ethers.providers.JsonRpcProvider(
        //   "https://polygon-mumbai.g.alchemy.com/v2/oXGi1fNe-zcHhhYzvLykg4tGFs2jiDyQ"
        // );

        const provider = new ethers.providers.Web3Provider(ethereum);
        console.log("Provider", provider);
        const signer = await provider.getSigner();
        console.log("Signers", signer);

        const contract = new ethers.Contract(contractAddress, abi, signer);
        console.log("Contract", contract);
        const address = await signer.getAddress();
        console.log("Connected to MetaMask with address:", address);
        //   console.log("Accounts:", accounts);
        if (accounts.length != 0) {
          //   await setCustomer(accounts[0]);
          await setInstance(insuranceContract);
          await setConnected(true);
        }
        console.log("Instance", accounts, contract, provider, signer);

        try {
          const options = {
            gasPrice: ethers.utils.parseUnits("50", "gwei"),
            gasLimit: 1000000,
          };
          const cid = "abcdfef";
          const result = await contract.addToken(cid);
          const receipt = await result.wait();

          console.log(`Transaction confirmed: ${receipt.transactionHash}`);
          // Check receipt.status to see if the transaction was successful
          if (receipt.status === 1) {
            setPurchased(true);
            setPaid(true);

            console.log("Transaction successful!");
            await swal("Token minted!", `Token ID:${data.userId}`, "success");
          } else {
            await swal("Transaction failed!", "", "error");
            setLoading(false);

            //   console.log("Transaction failed!");
          }
        } catch (error) {
          console.error("Token add failed", error.msg);
        }

        // await setInstance(insuranceContract);
        // createToken();
        // await setId();
      }
    }
  };

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


