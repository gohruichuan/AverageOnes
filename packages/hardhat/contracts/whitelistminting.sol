pragma solidity ^0.8.0;

import "./WhitelistMintHelper.sol";

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract WhitelistMinting is WhitelistHelper {

  function mintItem(string memory tokenURI) 
    public 
    allowedToMint
    isForSale(tokenURI)
    returns (uint)
  {
      uint id = _getNewTokenId();
      _mint(msg.sender, id);
      _setTokenURI(id, tokenURI);
      _updateInternalStateAfterMinting();
      return id;
  }

  function _getNewTokenId() private returns (uint) {
    // @dev Increment has to occur first
    _tokenIds.increment();
    // @dev Current id must only be retrieved after counter increment from above.
    return _tokenIds.current();
  }

  function _updateInternalStateAfterMinting(string tokenURI) private {
    bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));
    forSale[uriHash] = false;
    uriToTokenId[uriHash] = id;
    _decreaseMintCountOfMinterFromWhitelistAfterMinting();
  }

}
