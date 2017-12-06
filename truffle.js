// require('babel-register');
// require('babel-polyfill');

require('dotenv').config();
const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-wallet-provider");
const Wallet = require('ethereumjs-wallet');

//var mainNetPrivateKey = new Buffer(process.env["MAINNET_PRIVATE_KEY"], "hex")
//var mainNetWallet = Wallet.fromPrivateKey(mainNetPrivateKey);
//var mainNetProvider = new WalletProvider(mainNetWallet, "https://mainnet.infura.io/");
//
//var ropstenPrivateKey = new Buffer(process.env["ROPSTEN_PRIVATE_KEY"], "hex")
//var ropstenWallet = Wallet.fromPrivateKey(ropstenPrivateKey);
//var ropstenProvider = new WalletProvider(ropstenWallet, "https://ropsten.infura.io/");

var rinkebyPrivateKey = new Buffer(process.env["RINKEBY_PRIVATE_KEY"], "hex")
var rinkebyWallet = Wallet.fromPrivateKey(rinkebyPrivateKey);
var rinkebyProvider = new WalletProvider(rinkebyWallet, "https://rinkeby.infura.io/");

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8757,
            network_id: "*",
            gas: 6500000
        },
        rinkeby0: {
            host: "localhost",
            port: 8545,
            network_id: 4,
            gas: 6500000,
            from: "0x48ecad263eb6042fc84aA037A2F11832c9AA757A"
        },
//        ropsten: {
//          provider: ropstenProvider,
//          // You can get the current gasLimit by running
//          // truffle deploy --network rinkeby
//          // truffle(rinkeby)> web3.eth.getBlock("pending", (error, result) =>
//          //   console.log(result.gasLimit))
//          gas: 4600000,
//          gasPrice: web3.toWei("20", "gwei"),
//          network_id: "3",
//        },
        rinkeby: {
          provider: rinkebyProvider,
          // You can get the current gasLimit by running
          // truffle deploy --network rinkeby
          // truffle(rinkeby)> web3.eth.getBlock("pending", (error, result) =>
          //   console.log(result.gasLimit))
          gas: 6500000,
          gasPrice: web3.toWei("20", "gwei"),
          network_id: "4",
        },
//        mainnet: {
//          provider: mainNetProvider,
//          gas: 4600000,
//          gasPrice: web3.toWei("20", "gwei"),
//          network_id: "1",
//        },
        coverage: {
            host: "localhost",
            port: 8555,
            network_id: "*",
            gas: 0xffffffff
        },
    }
};
