pragma solidity ^0.4.24;

contract IMintableNFT {
    function mint(address _to, uint256 _encodedTokenId) public;

    function burn(address _to, uint256 _encodedTokenId) public;
}