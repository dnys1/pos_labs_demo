import 'package:location/location.dart' as location;

import '../models/models.dart';

class LocationService {
  static final location.Location _location = location.Location();

  Future<Location> getUserLocation() async {
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        throw LocationException(
            message: 'Please enable location services for this demo.');
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        throw LocationException(
            message: 'Please enable location services for this demo.');
      }
    }

    location.LocationData _locationData = await _location.getLocation();

    return Location(
      latitude: _locationData.latitude,
      longitude: _locationData.longitude,
    );
  }
}
