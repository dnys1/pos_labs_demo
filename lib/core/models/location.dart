import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

const _northAmericaSW =
    Location(latitude: -58.1534856445, longitude: -169.4908630848);
const _northAmericaNE =
    Location(latitude: 71.6462726265, longitude: -28.5143005848);

/// An object representing a location (latitude/longitude).
class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({
    @required this.latitude,
    @required this.longitude,
  })  : assert(
          latitude >= -90 && latitude <= 90,
          'Invalid latitude: $latitude',
        ),
        assert(
          longitude >= -180 && longitude <= 180,
          'Invalid longitude: $longitude',
        );

  String toDirectionsRequestString() => '$latitude,$longitude';

  /// Provides a rough estimate of whether the given location
  /// is within North America or not.
  bool get locationInNorthAmerica {
    return longitude >= _northAmericaSW.longitude &&
        longitude <= _northAmericaNE.longitude &&
        latitude >= _northAmericaSW.latitude &&
        latitude <= _northAmericaNE.latitude;
  }

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() {
    return 'Location { lat: $latitude, long: $longitude }';
  }
}
