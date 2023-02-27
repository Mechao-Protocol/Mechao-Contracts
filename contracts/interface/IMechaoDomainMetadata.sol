// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface IMechaoDomainMetadata {

  function getMetadata(string calldata _domainName, string calldata _tld, uint _tokenId) external view returns(string memory);


}