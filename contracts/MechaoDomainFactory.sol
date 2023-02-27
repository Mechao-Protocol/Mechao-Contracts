// // SPDX-License-Identifier: GPL-3.0-or-later
// pragma solidity ^0.8.4;

// //import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "./MechaoDomain.sol";
// import {IMechaoDomainHub} from "./interface/IMechaoDomainHub.sol";
// import "@openzeppelin/contracts/utils/Context.sol";

// /// @title Mechao Domain Factory
// /// @author Oluwaseun-S
// /// @notice Factory contract dynamically new domain contracts.
// contract MechaoDomainFactory is Context {

//   string[] public tlds; 
//   mapping (string => address) public tldNamesAddresses; // mapping of TLD names to their addresses

//     address mechaoDomainHub;

//   event TldCreated(address indexed user, address indexed owner, string tldName, address tldAddress);
//   event ChangeTldPrice(address indexed user, uint256 tldPrice);

//   modifier onlyHubAdmin{
//     _isHubAdmain();
//     _;
//   }

//     IMechaoDomainHub domainHub;
//   constructor(address _mechaoDomainHub) {
//     mechaoDomainHub = _mechaoDomainHub;
//     IMechaoDomainHub newDomainHub = IMechaoDomainHub(_mechaoDomainHub);
//     domainHub = newDomainHub;
//   }

//   function getTldsArray() public view returns(string[] memory) {
//     return tlds;
//   }

//   function _validTldName(string memory _name) view internal returns(bool) {
//     return domainHub.validTldName(_name, address(this));
//   }

//   /// @notice Create a new top-level domain contract (ERC-721).
//   /// @param _name Enter TLD name starting with a dot and make sure letters are in lowercase form.
//   /// @return TLD contract address
//   function createTld(
//     string memory _name,
//     string memory _symbol,
//     address _tldOwner,
//     uint256 _domainPrice,
//     bool _buyingEnabled
//   ) external payable returns(address) {
//     (uint price,, address metadataAddress, bool buyingEnabled,) = domainHub.getFactoryDetails(address(this));
//     (address royaltyAddress, ) = domainHub.getRoyaltyDetails(address(this));
//     require (royaltyAddress != address(0), "Tld Payment reciver: address(0)");
//     require(buyingEnabled == true, "Buying TLDs disabled");
//     require(msg.value >= price, "Value below price");
    
//     (bool sent, ) = payable(royaltyAddress).call{value: address(this).balance}("");
//     require(sent, "Failed to send TLD payment");

//     return _createTld(
//       _name, 
//       _symbol, 
//       _tldOwner, 
//       _domainPrice, 
//       _buyingEnabled,
//       metadataAddress
//     );

//   }


//   function _createTld(
//     string memory _nameRaw,
//     string memory _symbol,
//     address _tldOwner,
//     uint256 _domainPrice,
//     bool _buyingEnabled,
//     address _metadataAddress
//   ) internal returns(address) {
//     string memory _name = strings.lower(_nameRaw);

//     require (_validTldName(_name) == false, "Not a valid TLD name");

//     MechaoDomain tld = new MechaoDomain(
//       _name, 
//       _symbol, 
//       _tldOwner, 
//       _domainPrice, 
//       _buyingEnabled,
//       address(this),
//       _metadataAddress
//     );

//     domainHub.addForbiddenTld(address(tld), address(this));
//     tldNamesAddresses[_name] = address(tld); // store TLD name and address into mapping
//     tlds.push(_name); // store TLD name into array

//     emit TldCreated(_msgSender(), _tldOwner, _name, address(tld));

//     return address(tld);
//   }

//   /// @notice Factory owner can create a new TLD for a specified address for free
//   /// @param _name Enter TLD name starting with a dot and make sure letters are in lowercase form.
//   /// @return TLD contract address
//   function ownerCreateTld(
//     string memory _name,
//     string memory _symbol,
//     address _tldOwner,
//     uint256 _domainPrice,
//     bool _buyingEnabled
//   ) external returns(address) {
//     _isHubAdmain();
//    (,, address metadataAddress,,) = domainHub.getFactoryDetails(address(this));
//     return _createTld(
//       _name, 
//       _symbol, 
//       _tldOwner, 
//       _domainPrice, 
//       _buyingEnabled,
//       metadataAddress
//     );

//   }

//     function getRoyaltyDetails() external view returns (address, uint){
//         (address addr, uint percentage) = domainHub.getRoyaltyDetails(address(this));
//         return(addr, percentage);
//     }

//     function _isHubAdmain() internal {
//         require(domainHub.checkHubAdmin(_msgSender()), "Not Hub Admin");
//     }

// }



