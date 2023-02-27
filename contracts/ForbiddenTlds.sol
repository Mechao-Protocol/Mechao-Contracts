// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import {IMechaoDomainHub} from "./interface/IMechaoDomainHub.sol";

contract ForbiddenTlds is Context {
  /// this contract is used to store the list of forbidden TLDs 

  mapping (string => bool) public forbidden; // forbidden TLDs
  mapping (address => bool) public factoryAddresses; // list of TLD factories that are allowed to add forbidden TLDs
  address mechaoDomainHub;

  event ForbiddenTldAdded(address indexed sender, string indexed tldName);
  event ForbiddenTldRemoved(address indexed sender, string indexed tldName);

  event FactoryAddressAdded(address indexed sender, address indexed fAddress);
  event FactoryAddressRemoved(address indexed sender, address indexed fAddress);

   modifier onlyHubAdmin{
    _isHubAdmain();
    _;
  }

  constructor(address _mechaoDomainHub) {
    forbidden[".eth"] = true;
    forbidden[".net"] = true;
    forbidden[".xyz"] = true;
    forbidden[".com"] = true;
    forbidden[".org"] = true;
    mechaoDomainHub = _mechaoDomainHub;
  }

  // PUBLIC
  function isTldForbidden(string memory _name) public view returns (bool) {
    return forbidden[_name];
  }

  // FACTORY
  function addForbiddenTld(string memory _name) external onlyHubAdmin {
    forbidden[_name] = true;
    emit ForbiddenTldAdded(msg.sender, _name);
  }

  // OWNER
  function adminAddForbiddenTld(string memory _name) external onlyHubAdmin {
    forbidden[_name] = true;
    emit ForbiddenTldAdded(msg.sender, _name);
  }

  function removeForbiddenTld(string memory _name) external onlyHubAdmin {
    forbidden[_name] = false;
    emit ForbiddenTldRemoved(msg.sender, _name);
  }

  function addFactoryAddress(address _fAddr) external onlyHubAdmin {
    factoryAddresses[_fAddr] = true;
    emit FactoryAddressAdded(msg.sender, _fAddr);
  }

  function removeFactoryAddress(address _fAddr) external onlyHubAdmin {
    factoryAddresses[_fAddr] = false;
    emit FactoryAddressRemoved(msg.sender, _fAddr);
  }

  function _isHubAdmain() internal {
    require(IMechaoDomainHub(mechaoDomainHub).checkHubAdmin(_msgSender()), "Not Hub Admin");
  }
}
