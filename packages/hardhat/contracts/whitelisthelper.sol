pragma solidity ^0.8.0;

import "./basecontracthelper.sol";

contract WhitelistHelper is BaseContractHelper {

  using SafeMath8 for uint8;

  // Status to check if whitelist is active
  bool private _whitelistActive = false;
  // Whitelisted address to number of tokens allowed for minting
  mapping(address => uint8) internal _whitelist;

  modifier allowedToMint() {
      require(_whitelistActive, "WHITELIST NOT ACTIVE");
      require(_whitelist[msg.sender] > 0, "PURCHASE NOT ALLOWED");
      _;
  }

  function isWhitelisted() external view returns (bool) {
      return _whitelist[msg.sender] > 0;
  }

  function setWhitelistActive() external onlyOwner {
      _whitelistActive = true;
  }

  function setWhitelistInactive() external onlyOwner {
      _whitelistActive = false;
  }

  function setWhitelist(address[] calldata addresses, uint8 mintCountAllowed) external onlyOwner {
    for (uint i=0; i<addresses.length; i++) {
      _whitelist[addresses[i]] = mintCountAllowed;
    }
  }

}