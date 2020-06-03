part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

/// Loading the user's current location
class LocationLoading extends LocationState {}

/// Loaded the user's current location
class LocationLoaded extends LocationState {
  /// The user's current location
  final Location userLocation;

  const LocationLoaded({@required this.userLocation});

  @override
  List<Object> get props => [userLocation];

  @override
  String toString() {
    return 'LocationLoaded { location: $userLocation }';
  }
}

/// Failure loading the user's current location
class LocationFailure extends LocationState {
  final LocationException exception;

  const LocationFailure({@required this.exception});

  factory LocationFailure.unknown() =>
      LocationFailure(exception: LocationException.unknown());

  @override
  List<Object> get props => [exception];

  @override
  String toString() {
    return 'LocationFailure { exception: $exception }';
  }
}
