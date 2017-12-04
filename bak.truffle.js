require('babel-register');
require('babel-polyfill');
const Provider = require('./helpers/Provider');
const ProviderRopsten = Provider.createRopstenNetwork("itype here your private key from owner address");
const ProviderMain = Provider.createMainNetwork("type here your private key from owner address");
const ProviderTestRpc = Provider.createTestRpcNetwork("ea1b400b9288bec42db66009a8e4fbe7d07b4d34e94fc888b523c7dc15d1d131");
const ProviderRinkeby = Provider.createRinkebyNetwork("68688354ba9a942cb3145b6e624b3a9d147c8eb061be78eccc5e0777e77032af");

module.exports = {
    networks: {
        ropsten: ProviderRopsten.getNetwork(),
        mainnet: ProviderMain.getNetwork(),
        testrpc: ProviderTestRpc.getNetwork(),
        rinkeby: ProviderRinkeby.getNetwork(),
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*",
            gas: 4700000
        },
        coverage: {
            host: "localhost",
            port: 8555,
            network_id: "*",
            gas: 0xffffffff
        },
    }
};
