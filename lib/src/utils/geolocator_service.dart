import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';

class GeolocatorService {
  final _currentLocation = BehaviorSubject<LatLng>.seeded(LatLng(0, 0));
  bool _serviceEnabled;
  Location location = new Location();

  setCurrentLocation(LatLng latLng) {
    _currentLocation.add(latLng);
  }

  Stream<LatLng> get getCurrentLocation$ => _currentLocation.stream;
  LatLng get getCurrentLocation => _currentLocation.value;

  Future<Position> getCurrentPosition() async {
    await validatePermission();
    //desiredAccuracy: LocationAccuracy.high
    return Geolocator().getCurrentPosition();
  }

  validatePermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }
}

final geolocatorService = GeolocatorService();
