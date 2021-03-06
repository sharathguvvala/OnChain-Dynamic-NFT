// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNFT is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenIDs;
    mapping(uint256 => uint256) public tokenIdsToLevels;

    constructor() ERC721("OnChainDynamicNFT", "ODN") {}

    function generateNFT(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdsToLevels[tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "OnChain Dyamic NFT #',
            tokenId.toString(),
            '",',
            '"description": "Dynamic NFT",',
            '"image": "',
            generateNFT(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        tokenIDs.increment();
        uint256 newItemId = tokenIDs.current();
        _safeMint(msg.sender, newItemId);
        tokenIdsToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function upgrade(uint256 tokenId) public {
        require(_exists(tokenId));
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this NFT to upgrade it!"
        );
        uint256 currentLevel = tokenIdsToLevels[tokenId];
        tokenIdsToLevels[tokenId] = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
