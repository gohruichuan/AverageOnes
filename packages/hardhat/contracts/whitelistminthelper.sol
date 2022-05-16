pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./WhitelistHelper.sol";

contract WhiteListMintHelper is WhitelistHelper {

  using Counters for Counters.Counter;
  Counters.Counter internal _tokenIds;

  uint mintPurchaseFee = 0.01 ether;

  constructor(bytes32[] memory assetsForSale) public ERC721("YourCollectible", "YCB") {
    _setBaseURI("https://ipfs.io/ipfs/");

    // @dev Not sure if this is still required? There is another addSaleItems method below that is exposed to the owner to add more in the future.
    for(uint i=0;i<assetsForSale.length;i++){
      forSale[assetsForSale[i]] = true;
    }
  }

  // This marks an item in IPFS as "forsale"
  mapping (bytes32 => bool) internal forSale;
  // This lets you look up a token by the uri (assuming there is only one of each uri for now)
  mapping (bytes32 => uint) internal uriToTokenId;

  modifier isForSale(string tokenURI) {
    require(forSale[toURIHash(tokenURI)], "NOT FOR SALE");
    _;
  }

  modifier metMintPurchaseFee() {
    require(msg.value >= mintPurchaseFee, "INSUFFICIENT ETHER");
    _;
  }

  function _decreaseMintCountOfMinterFromWhitelistAfterMinting() internal {
    _whitelist[msg.sender] = _whitelist[msg.sender].sub(1);
  }

  function setMintPurchaseFee(uint memory _fee) external onlyOwner {
    mintPurchaseFee = _fee;
  }

  function addSaleItem(string memory tokenURI) external onlyOwner {
    populateItemForSale(tokenURI);
  }

  function addSaleItems(string[] memory tokenURIs) external onlyOwner {
    for(uint i=0;i<tokenURIs.length;i++){
      populateItemForSale(tokenURIs[i]);
    }
  }

  function populateItemForSale(string tokenURI) private {
    forSale[toURIHash(tokenURI)] = true;
  }

}