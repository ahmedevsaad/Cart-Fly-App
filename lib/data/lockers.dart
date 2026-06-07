import 'package:latlong2/latlong.dart';
import 'models/locker.dart';

const _eg = CountryLockers(
  code: 'eg',
  displayName: 'Egypt',
  center: LatLng(27.0, 30.0),
  zoom: 5.5,
  cities: [
    CityLockers('Cairo', [
      Locker(
          name: 'New Cairo',
          spot: 'Cairo Festival City Mall',
          coord: LatLng(30.0286, 31.4076)),
      Locker(
          name: 'Nasr City',
          spot: 'City Stars Mall',
          coord: LatLng(30.0726, 31.3464)),
      Locker(
          name: 'Downtown',
          spot: 'Sadat Metro Station',
          coord: LatLng(30.0444, 31.2357),
          type: LockerType.metro),
    ]),
    CityLockers('Giza', [
      Locker(
          name: '6th of October',
          spot: 'Mall of Egypt',
          coord: LatLng(29.9712, 30.9707)),
      Locker(
          name: 'Sheikh Zayed',
          spot: 'Arkan Plaza',
          coord: LatLng(30.0501, 30.9728),
          type: LockerType.plaza),
      Locker(
          name: 'Dokki',
          spot: 'Dokki Metro Station',
          coord: LatLng(30.0388, 31.2122),
          type: LockerType.metro),
    ]),
    CityLockers('Alexandria', [
      Locker(
          name: 'Smouha',
          spot: 'Green Plaza Mall',
          coord: LatLng(31.2156, 29.9438)),
      Locker(
          name: 'San Stefano',
          spot: 'San Stefano Grand Plaza',
          coord: LatLng(31.2380, 29.9580)),
      Locker(
          name: 'Raml Station',
          spot: 'Raml Tram Station',
          coord: LatLng(31.1995, 29.8964),
          type: LockerType.metro),
    ]),
  ],
);

const _sa = CountryLockers(
  code: 'sa',
  displayName: 'Saudi Arabia',
  center: LatLng(24.0, 45.0),
  zoom: 5.0,
  cities: [
    CityLockers('Riyadh', [
      Locker(
          name: 'King Fahd',
          spot: 'Kingdom Centre',
          coord: LatLng(24.7115, 46.6747)),
      Locker(
          name: 'Olaya',
          spot: 'Riyadh Park Mall',
          coord: LatLng(24.7588, 46.6326)),
    ]),
    CityLockers('Jeddah', [
      Locker(
          name: 'Corniche',
          spot: 'Red Sea Mall',
          coord: LatLng(21.6259, 39.0992)),
      Locker(
          name: 'Tahlia',
          spot: 'Le Prestige Mall',
          coord: LatLng(21.5724, 39.1407)),
    ]),
    CityLockers('Dammam', [
      Locker(
          name: 'Khobar',
          spot: 'Mall of Dhahran',
          coord: LatLng(26.3010, 50.1502)),
      Locker(
          name: 'Al Olaya',
          spot: 'City Centre Dammam',
          coord: LatLng(26.4282, 50.0850)),
    ]),
  ],
);

const _ae = CountryLockers(
  code: 'ae',
  displayName: 'UAE',
  center: LatLng(24.4, 54.5),
  zoom: 7.0,
  cities: [
    CityLockers('Dubai', [
      Locker(
          name: 'Downtown',
          spot: 'Dubai Mall',
          coord: LatLng(25.1972, 55.2796)),
      Locker(
          name: 'Dubai Marina',
          spot: 'Marina Mall',
          coord: LatLng(25.0772, 55.1410)),
      Locker(
          name: 'Mall of the Emirates',
          spot: 'MoE',
          coord: LatLng(25.1180, 55.2003)),
    ]),
    CityLockers('Abu Dhabi', [
      Locker(
          name: 'Yas Island',
          spot: 'Yas Mall',
          coord: LatLng(24.4884, 54.6075)),
      Locker(
          name: 'Khalifa City',
          spot: 'Etihad Plaza',
          coord: LatLng(24.4150, 54.5854),
          type: LockerType.plaza),
      Locker(
          name: 'Abu Dhabi Mall',
          spot: 'Abu Dhabi Mall Area',
          coord: LatLng(24.4881, 54.3691)),
    ]),
    CityLockers('Sharjah', [
      Locker(
          name: 'Al Majaz',
          spot: 'Al Majaz Waterfront',
          coord: LatLng(25.3300, 55.3870)),
      Locker(
          name: 'City Centre',
          spot: 'City Centre Sharjah',
          coord: LatLng(25.3326, 55.4209)),
    ]),
  ],
);

const _us = CountryLockers(
  code: 'us',
  displayName: 'USA',
  center: LatLng(39.5, -98.0),
  zoom: 3.5,
  cities: [
    CityLockers('New York', [
      Locker(
          name: 'Manhattan',
          spot: 'Hudson Yards',
          coord: LatLng(40.7540, -74.0014)),
    ]),
    CityLockers('Los Angeles', [
      Locker(
          name: 'Downtown LA',
          spot: 'The Bloc',
          coord: LatLng(34.0470, -118.2569)),
    ]),
    CityLockers('Miami', [
      Locker(
          name: 'Brickell',
          spot: 'Brickell City Centre',
          coord: LatLng(25.7656, -80.1918)),
    ]),
  ],
);

const _cn = CountryLockers(
  code: 'cn',
  displayName: 'China',
  center: LatLng(34.0, 105.0),
  zoom: 4.0,
  cities: [
    CityLockers('Beijing', [
      Locker(
          name: 'Chaoyang',
          spot: 'Sanlitun',
          coord: LatLng(39.9385, 116.4474)),
      Locker(
          name: 'Haidian',
          spot: 'Beijing Railway Station',
          coord: LatLng(39.9027, 116.4280),
          type: LockerType.metro),
    ]),
    CityLockers('Shanghai', [
      Locker(
          name: 'Pudong',
          spot: 'IFC Mall',
          coord: LatLng(31.2384, 121.5008)),
      Locker(
          name: "Jing'an",
          spot: "Jing'an Temple",
          coord: LatLng(31.2247, 121.4456)),
    ]),
    CityLockers('Guangzhou', [
      Locker(
          name: 'Tianhe',
          spot: 'TaiKoo Hui',
          coord: LatLng(23.1351, 113.3219)),
      Locker(
          name: 'Yuexiu',
          spot: 'Guangzhou East Railway Station',
          coord: LatLng(23.1488, 113.3305),
          type: LockerType.metro),
    ]),
  ],
);

const countryLockers = <CountryLockers>[_eg, _sa, _ae, _us, _cn];

CountryLockers lockersByCode(String code) =>
    countryLockers.firstWhere((c) => c.code == code);
