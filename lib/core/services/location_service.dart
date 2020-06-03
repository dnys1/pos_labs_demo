import 'package:location/location.dart' as location;
import 'package:logging/logging.dart';

import '../models/models.dart';

class LocationService {
  static final Logger _logger = Logger('LocationService');
  static final location.Location _location = location.Location();

  Future<Location> getUserLocation() async {
    _logger.finer('getUserLocation');
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    _logger.finer('getUserLocation: serviceEnabled $_serviceEnabled');
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      _logger.finer('getUserLocation: serviceEnabled (post-request) $_serviceEnabled');
      if (!_serviceEnabled) {
        throw LocationException(
            message: 'Please enable location services for this demo.');
      }
    }

    _permissionGranted = await _location.hasPermission();
    _logger.finer('getUserLocation: permissionGranted $_permissionGranted');
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      _logger.finer('getUserLocation: permissionGranted (post-request) $_permissionGranted');
      if (_permissionGranted != location.PermissionStatus.granted) {
        throw LocationException(
            message: 'Please enable location services for this demo.');
      }
    }

    location.LocationData _locationData = await _location.getLocation();
    _logger.finer('getUserLocation: locationData', _locationData);

    final userLocation = Location(
      latitude: _locationData.latitude,
      longitude: _locationData.longitude,
    );
    _logger.finer('getUserLocation: userLocation $userLocation');

    return userLocation;
  }
}
