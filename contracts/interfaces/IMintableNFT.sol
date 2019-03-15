pragma solidity ^0.4.24;

contract IMintableNFT {
    function mint(address _to, uint256 _encodedTokenId) public returns (uint256 _tokenId);

    function burn(address _to, uint256 _encodedTokenId) public returns (uint256 _tokenId);
}