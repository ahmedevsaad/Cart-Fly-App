/// Forwarding warehouse addresses shown on the country-lockers screen.
/// Content is verbatim from CartFly Redesign frames 07-11.
class WarehouseAddress {
  const WarehouseAddress({
    required this.code,
    required this.countryLabel,
    required this.recipient,
    required this.address,
    required this.city,
  });

  final String code;
  final String countryLabel;
  final String recipient;
  final String address;
  final String city;

  /// Full formatted address for clipboard copy.
  String get fullText =>
      'Recipient: $recipient\nAddress: $address\nCity: $city';
}

const warehouseAddresses = <WarehouseAddress>[
  WarehouseAddress(
    code: 'cn',
    countryLabel: 'China',
    recipient: 'CartFly · SARA-2048',
    address: "No. 12, Bao'an Logistics Park",
    city: 'Shenzhen · 518101',
  ),
  WarehouseAddress(
    code: 'us',
    countryLabel: 'USA',
    recipient: 'CartFly · SARA-2048',
    address: '8 Newark Way, Unit SARA-2048',
    city: 'Newark, Delaware · 19711',
  ),
  WarehouseAddress(
    code: 'ae',
    countryLabel: 'United Arab Emirates',
    recipient: 'CartFly · SARA-2048',
    address: 'Warehouse 6, Dubai Logistics City',
    city: 'Dubai',
  ),
  WarehouseAddress(
    code: 'eg',
    countryLabel: 'Egypt',
    recipient: 'CartFly · SARA-2048',
    address: '14 El-Horreya Rd, Nasr City',
    city: 'Cairo',
  ),
  WarehouseAddress(
    code: 'sa',
    countryLabel: 'Saudi Arabia',
    recipient: 'CartFly · SARA-2048',
    address: 'King Fahd Rd Depot 9',
    city: 'Riyadh · 11564',
  ),
];

WarehouseAddress addressByCode(String code) =>
    warehouseAddresses.firstWhere((a) => a.code == code);
