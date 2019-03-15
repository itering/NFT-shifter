const IteringNFT = artifacts.require("IteringNFT");
const FreeITOBase = artifacts.require("FreeITOBase");
const MintAndBurnAuthority = artifacts.require("MintAndBurnAuthority");
const InterstellarEncoderV3 = artifacts.require("InterstellarEncoderV3");

var fs = require('fs');
var contracts = JSON.parse(fs.readFileSync('./kovan_address.json', 'utf8'));


const conf  = {
    interstellarEncoderV3_address: "0x0700fa0c70ada58ad708e7bf93d032f1fd9a5150",
    registry_address: "0xd8b7a3f6076872c2c37fb4d5cbfeb5bf45826ed7",
    unknown_objectId: 255,
    itoContract_id: 3

}

module.exports = async function(deployer, network) {

    if(network != "kovan") {
        return;
    }

  deployer.deploy(IteringNFT).then(async() => {
    await deployer.deploy(FreeITOBase, contracts["SettingsRegistry"], IteringNFT.address);
  }).then(async() => {
      await deployer.deploy(MintAndBurnAuthority, [FreeITOBase.address]);
  }).then(async() => {
      // set authority
      let iteringNft = await IteringNFT.deployed();
      await iteringNft.setAuthority(MintAndBurnAuthority.address);

      let encoderV3 = await InterstellarEncoderV3.at(contracts["InterstellarEncoderV3"]);
      await encoderV3.registerNewObjectClass(FreeITOBase.address, conf.unknown_objectId);
      await encoderV3.registerNewOwnershipContract(IteringNFT.address, conf.itoContract_id);


  })

};
