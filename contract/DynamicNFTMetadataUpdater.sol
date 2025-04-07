// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DynamicNFT {
    string public name = "DynamicNFT";
    string public symbol = "DNFT";
    uint256 public tokenCounter;

    address public owner;

    // Token owner mapping
    mapping(uint256 => address) public owners;

    // Token metadata URI mapping
    mapping(uint256 => string) private tokenURIs;

    // Event for minting
    event Minted(address indexed to, uint256 tokenId, string tokenURI);
    
    // Event for metadata update
    event MetadataUpdated(uint256 tokenId, string newTokenURI);

    constructor() {
        owner = msg.sender;
        tokenCounter = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(msg.sender == owners[tokenId], "Not token owner");
        _;
    }

    // Mint a new NFT
    function mintNFT(address recipient, string memory _tokenURI) public onlyOwner returns (uint256) {
        uint256 tokenId = tokenCounter;
        owners[tokenId] = recipient;
        tokenURIs[tokenId] = _tokenURI;
        tokenCounter++;
        emit Minted(recipient, tokenId, _tokenURI);
        return tokenId;
    }

    // Update metadata URI
    function updateMetadata(uint256 tokenId, string memory _newTokenURI) public onlyOwner {
        require(owners[tokenId] != address(0), "Token does not exist");
        tokenURIs[tokenId] = _newTokenURI;
        emit MetadataUpdated(tokenId, _newTokenURI);
    }

    // Get metadata URI
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(owners[tokenId] != address(0), "Token does not exist");
        return tokenURIs[tokenId];
    }

    // Get token owner
    function ownerOf(uint256 tokenId) public view returns (address) {
        return owners[tokenId];
    }
}

