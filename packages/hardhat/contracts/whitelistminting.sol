pragma solidity ^0.8.0;

import "./WhitelistMintHelper.sol";

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract WhitelistMinting is WhitelistHelper {

  function mintItem(string memory tokenURI) 
    public 
    allowedToMint(msg.sender) 
    isForSale(tokenURI)
    returns (uint)
  {
      uint id = _updateInternalState();
      _mint(msg.sender, id);
      _setTokenURI(id, tokenURI);

      return id;
  }

  function _updateInternalState() private returns (uint) {
    // @dev Increment has to occur first
    _tokenIds.increment();
    // @dev Current id must only be retrieved after counter increment from above.
    uint256 id = _tokenIds.current();
    bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));
    forSale[uriHash]=false;
    uriToTokenId[uriHash] = id;
    _decreaseMintCountOfMinterFromWhitelistAfterMinting();
    return id;
  }

}
