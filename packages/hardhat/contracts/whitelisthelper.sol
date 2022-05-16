pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract WhitelistHelper is ERC721 {

  using SafeMath8 for uint8;

  // Status to check if whitelist is active
  bool private _whitelistActive = false;
  // Whitelisted address to number of tokens allowed for minting
  mapping(address => uint8) internal _whitelist;

  modifier allowedToMint(address minter) {
      require(_whitelistActive, "WHITELIST NOT ACTIVE");
      require(_whitelist[minter] > 0, "PURCHASE NOT ALLOWED");
      _;
  }

  function toggleWhitelistActive() external onlyOwner {
      _whitelistActive = !_whitelistActive;
  }

  function setWhitelist(address[] calldata addresses, uint8 mintCountAllowed) external onlyOwner {
    for (uint i=0; i<addresses.length; i++) {
      _whitelist[addresses[i]] = mintCountAllowed;
    }
  }

}