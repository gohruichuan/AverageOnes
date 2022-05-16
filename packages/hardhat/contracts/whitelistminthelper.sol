pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./WhitelistHelper.sol";

contract WhiteListMintHelper is WhitelistHelper {

  using Counters for Counters.Counter;
  Counters.Counter internal _tokenIds;

  uint mintPurchaseFee = 0.01 ether;

  constructor(bytes32[] memory assetsForSale) public ERC721("YourCollectible", "YCB") {
    _setBaseURI("https://ipfs.io/ipfs/");
    for(uint256 i=0;i<assetsForSale.length;i++){
      forSale[assetsForSale[i]] = true;
    }
  }

  // This marks an item in IPFS as "forsale"
  mapping (bytes32 => bool) internal forSale;
  // This lets you look up a token by the uri (assuming there is only one of each uri for now)
  mapping (bytes32 => uint256) internal uriToTokenId;

  modifier isForSale(string tokenURI) {
    bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));
    require(forSale[uriHash], "NOT FOR SALE");
    _;
  }

  modifier metMintPurchaseFee() {
    require(msg.value >= mintPurchaseFee, "INSUFFICIENT ETHER");
    _;
  }

  function _decreaseMintCountOfMinterFromWhitelistAfterMinting() internal {
    _whitelist[msg.sender] = _whitelist[msg.sender].sub(1);
  }

  function setMintPurchaseFee(uint _fee) external onlyOwner {
    mintPurchaseFee = _fee;
  }

}