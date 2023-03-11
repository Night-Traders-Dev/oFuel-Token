// Initialize Web3
const web3 = new Web3(window.ethereum);

// Get contract instance
const contractAddress = "0x2826A8Da0F23a8e59AB0723d556f456586aef5ea";
const contractAbi = [
  // Replace this with the ABI for your smart contract
];
const oFuelContract = new web3.eth.Contract(contractAbi, contractAddress);

// Get the current account
let currentAccount = null;
web3.eth.getAccounts().then(function (accounts) {
  currentAccount = accounts[0];
});

// Update the account if it changes
window.ethereum.on("accountsChanged", function (accounts) {
  currentAccount = accounts[0];
});

// Connect the buttons to the contract functions
const mintButton = document.getElementById("mint-button");
mintButton.onclick = function () {
  const amount = document.getElementById("mint-amount").value;
  oFuelContract.methods.mint(currentAccount, amount).send({ from: currentAccount })
    .then(function (result) {
      alert("Mint successful!");
    })
    .catch(function (error) {
      alert("Mint failed: " + error.message);
    });
};

const transferButton = document.getElementById("transfer-button");
transferButton.onclick = function () {
  const to = document.getElementById("transfer-to").value;
  const amount = document.getElementById("transfer-amount").value;
  oFuelContract.methods.transfer(to, amount).send({ from: currentAccount })
    .then(function (result) {
      alert("Transfer successful!");
    })
    .catch(function (error) {
      alert("Transfer failed: " + error.message);
    });
};

const balanceButton = document.getElementById("balance-button");
balanceButton.onclick = function () {
  const address = document.getElementById("balance-address").value;
  oFuelContract.methods.balanceOf(address).call()
    .then(function (balance) {
      alert("Balance: " + balance);
    })
    .catch(function (error) {
      alert("Failed to get balance: " + error.message);
    });
};
