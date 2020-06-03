part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

/// Fired when the app loads and/or the user's location
/// is re-requested in-app (perhaps when Try Again is called)
class LocationStarted extends LocationEvent {}
