pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BaseContractHelper is ERC721 {

    function toURIHash(string uri) internal pure returns (bytes32){
        return keccak256(abi.encodePacked(uri));
    }

}

