import 'package:latlong2/latlong.dart';

enum LockerType { mall, metro, plaza, store }

class Locker {
  const Locker({
    required this.name,
    required this.spot,
    required this.coord,
    this.type = LockerType.mall,
  });
  final String name;
  final String spot;
  final LatLng coord;
  final LockerType type;
}

class CityLockers {
  const CityLockers(this.city, this.lockers);
  final String city;
  final List<Locker> lockers;
}

class CountryLockers {
  const CountryLockers({
    required this.code,
    required this.displayName,
    required this.center,
    required this.zoom,
    required this.cities,
  });
  final String code;
  final String displayName;
  final LatLng center;
  final double zoom;
  final List<CityLockers> cities;
}
