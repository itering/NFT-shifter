pragma solidity ^0.4.24;

import "@evolutionland/common/contracts/interfaces/ISettingsRegistry.sol";
import "@evolutionland/common/contracts/interfaces/IInterstellarEncoderV3.sol";
import "@evolutionland/common/contracts/DSAuth.sol";
import "./interfaces/IMintableNFT.sol";

contract DarwiniaITOBase is DSAuth {

    uint8 public constant DARWINIA_OBJECT_ID = 254;  // Darwinia

    uint16 public constant ITERING_PRODUCER_ID = 258;   // From Darwinia

    uint128 public nftCounter = 0;


    // TODO 1: Register Object ID and Object Class on InterstellarEncoderV3

    // TODO 2: Add this contract to the whitelist of ObjectOwnershipAuthorityV2
    
    // TODO 3: Deploy Itering NFT Contract.

    ISettingsRegistry public registry;

    address public nftAddress;

    event NFTMinted(address _operator, uint256 _tokenId, address _owner, uint256 _mark);
    event NFTBurned(address _operator, address _owner, uint256 _tokenId);

    constructor (ISettingsRegistry _registry, address _nftAddress) public {
        registry = _registry;
        nftAddress = _nftAddress;
    }


    function mintObject(address _user, uint256 _mark) public auth{
        require(nftCounter < 340282366920938463463374607431768211455, "overflow");

        nftCounter += 1;

        // bytes32 public constant CONTRACT_INTERSTELLAR_ENCODER = "CONTRACT_INTERSTELLAR_ENCODER";
        // 0x434f4e54524143545f494e5445525354454c4c41525f454e434f444552000000
        uint256 tokenId = IInterstellarEncoderV3(registry.addressOf(0x434f4e54524143545f494e5445525354454c4c41525f454e434f444552000000)).encodeTokenIdForOuterObjectContract(
            address(this), nftAddress, nftAddress, nftCounter, ITERING_PRODUCER_ID, 0);

        IMintableNFT(nftAddress).mint(_user, tokenId);

        emit NFTMinted(msg.sender, tokenId, _user, _mark);
    }

    function burnObject(address _user, uint256 _tokenId) public auth{
        IMintableNFT(nftAddress).burn(_user, _tokenId);

        emit NFTBurned(msg.sender, _user, _tokenId);
    }
}
