const IteringNFT = artifacts.require("IteringNFT");
const DarwiniaITOBase = artifacts.require("DarwiniaITOBase");
const MintAndBurnAuthority = artifacts.require("MintAndBurnAuthority");
const InterstellarEncoderV3 = artifacts.require("InterstellarEncoderV3");

var fs = require('fs');
var contracts = JSON.parse(fs.readFileSync('./kovan_address.json', 'utf8'));


const conf  = {
    interstellarEncoderV3_address: "0x6Be8f8d0aDB016b1EB09FA4AADdD65F43af5Ada9",
    registry_address: "0x6982702995b053A21389219c1BFc0b188eB5a372",
    freeITOBase_address: "0xcEc27B639fd1b0195bE8c2D3635714819F97FcCA",
    iteringNFT_address: "0x22E1D12c5706715A9Ac22b88a5a10D6C1369601C",
    darwinia_objectId: 254,
    itoContract_id: 3
}

module.exports = async function(deployer, network) {

    if(network != "ropsten") {
        return;
    }

    deployer.deploy(DarwiniaITOBase, contracts["SettingsRegistry"], conf.iteringNFT_address).then(async() => {
      await deployer.deploy(MintAndBurnAuthority, [freeITOBase_address, DarwiniaITOBase.address]);
  }).then(async() => {
      // set authority
      let iteringNft = await IteringNFT.at(conf.iteringNFT_address);
      await iteringNft.setAuthority(MintAndBurnAuthority.address);

      let encoderV3 = await InterstellarEncoderV3.at(contracts["InterstellarEncoderV3"]);
      await encoderV3.registerNewObjectClass(DarwiniaITOBase.address, conf.darwinia_objectId);
  })

};
