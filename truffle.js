require('babel-register');
require('babel-polyfill');
const Provider = require('./helpers/Provider');
const ProviderRopsten = Provider.createRopstenNetwork("itype here your private key from owner address");
const ProviderMain = Provider.createMainNetwork("type here your private key from owner address");
const ProviderTestRpc = Provider.createTestRpcNetwork("c727c3c7b6f4428c63b21f2c8fcbe98f04bdd04646f8bccc51fdddd437043ebe");

module.exports = {
    networks: {
        ropsten: ProviderRopsten.getNetwork(),
        mainnet: ProviderMain.getNetwork(),
        testrpc: ProviderTestRpc.getNetwork(),
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*",
            gas: 6000000
        },
        coverage: {
            host: "localhost",
            port: 8555,
            network_id: "*",
            gas: 0xffffffff
        }
    }
};
