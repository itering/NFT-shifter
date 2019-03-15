pragma solidity ^0.4.24;

import "@evolutionland/common/contracts/interfaces/ISettingsRegistry.sol";
import "@evolutionland/common/contracts/interfaces/IInterstellarEncoderV3.sol";
import "@evolutionland/common/contracts//DSAuth.sol";
import "@evolutionland/common/contracts/SettingIds.sol";
import "./interfaces/IMintableNFT.sol";



contract UnknownNFT is DSAuth, SettingIds {

    uint8 public constant OBJECT_ID = 255;

    uint16 public constant PRODUCER_ID = 255;

    uint128 public nftCounter = 0;


    // TODO 1: Register Object ID and Object Class on InterstellarEncoderV3

    // TODO 2: Add this contract to the whitelist of ObjectOwnershipAuthorityV2

    ISettingsRegistry public registry;

    event UnknownNFTMinted(address _operator, uint256 _tokenId, address _owner, uint256 _mark);

    constructor (ISettingsRegistry _registry) public {
        registry = _registry;
    }


    function mintUnknownObject(address _user, uint256 _mark) public {
        require(nftCounter < 340282366920938463463374607431768211455, "overflow");

        nftCounter += 1;

        address tokenAddress = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);

        uint256 tokenId = IInterstellarEncoderV3(registry.addressOf(CONTRACT_INTERSTELLAR_ENCODER)).encodeTokenIdForOuterObjectContract(
            address(this), tokenAddress, tokenAddress, nftCounter, PRODUCER_ID, 0);

        IMintableNFT(tokenAddress).mint(_user, tokenId);

        emit UnknownNFTMinted(msg.sender, tokenId, _user, _mark);
    }
}
