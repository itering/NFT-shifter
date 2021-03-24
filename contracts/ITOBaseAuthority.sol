pragma solidity ^0.4.24;

import "@evolutionland/common/contracts//DSAuth.sol";

contract ITOBaseAuthority is DSAuth {

    mapping (address => bool) public allowList;

    constructor(address[] _allowlists) public {
        for (uint i = 0; i < _allowlists.length; i ++) {
            allowList[_allowlists[i]] = true;
        }
    }

    function canCall(
        address _src, address _dst, bytes4 _sig
    ) public view returns (bool) {
        return ( allowList[_src] && _sig == bytes4(keccak256("mintObject(address,uint256)")) ) ||
        ( allowList[_src] && _sig == bytes4(keccak256("mintObject(address,uint16,uint256)")) ) ||
        ( allowList[_src] && _sig == bytes4(keccak256("burnObject(address,uint256)")) );
    }

    function addAllowAddress(address allowAddress) public onlyOwner{
        allowList[allowAddress] = true;
    }

    function removeAllowAddress(address allowAddress) public onlyOwner{
        allowList[allowAddress] = false;
    }
}
