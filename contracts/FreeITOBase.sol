pragma solidity ^0.4.24;

import "@evolutionland/common/contracts/interfaces/ISettingsRegistry.sol";
import "@evolutionland/common/contracts/interfaces/IInterstellarEncoderV3.sol";
import "@evolutionland/common/contracts//DSAuth.sol";
import "@evolutionland/common/contracts/SettingIds.sol";
import "./interfaces/IMintableNFT.sol";

contract FreeITOBase is DSAuth, SettingIds {

    uint8 public constant UNKNOWN_OBJECT_ID = 255;  // Other

    uint16 public constant ITERING_PRODUCER_ID = 257;   // From Itering

    uint128 public nftCounter = 0;


    // TODO 1: Register Object ID and Object Class on InterstellarEncoderV3

    // TODO 2: Add this contract to the whitelist of ObjectOwnershipAuthorityV2
    
    // TODO 3: Deploy Itering NFT Contract.

    ISettingsRegistry public registry;

    address public nftAddress;

    event UnknownNFTMinted(address _operator, uint256 _tokenId, address _owner, uint256 _mark);

    constructor (ISettingsRegistry _registry, address _nftAddress) public {
        registry = _registry;
        nftAddress = _nftAddress;
    }


    function mintUnknownObject(address _user, uint256 _mark) public {
        require(nftCounter < 340282366920938463463374607431768211455, "overflow");

        nftCounter += 1;

        uint256 tokenId = IInterstellarEncoderV3(registry.addressOf(CONTRACT_INTERSTELLAR_ENCODER)).encodeTokenIdForOuterObjectContract(
            address(this), nftAddress, nftAddress, nftCounter, ITERING_PRODUCER_ID, 0);

        IMintableNFT(nftAddress).mint(_user, tokenId);

        emit UnknownNFTMinted(msg.sender, tokenId, _user, _mark);
    }
}
