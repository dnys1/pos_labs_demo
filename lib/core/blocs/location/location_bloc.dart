import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../services/location_service.dart';

part 'location_event.dart';
part 'location_state.dart';

/// Handles requests for the user's location
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  static final Logger _logger = Logger('LocationBloc');

  LocationService _locationService;

  LocationBloc({@required LocationService locationService}) {
    assert(locationService != null, 'LocationService must be provided');
    _locationService = locationService;
  }

  @override
  LocationState get initialState => LocationLoading();

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is LocationStarted) {
      yield* _mapLocationStartedToState();
    }
  }

  /// Load the user's location using [LocationService]
  Stream<LocationState> _mapLocationStartedToState() async* {
    yield LocationLoading();
    _logger.fine('_mapLocationStartedToState: Loading user location');

    try {
      Location userLocation = await _locationService.getUserLocation();
      yield LocationLoaded(userLocation: userLocation);
      _logger.fine('_mapLocationStartedToState: User location successfully loaded');
    } on LocationException catch (e) {
      yield LocationFailure(exception: e);
      _logger.severe('_mapLocationStartedToState: $e');
    } catch (e) {
      yield LocationFailure.unknown();
      _logger.severe('_mapLocationStartedToState: $e');
    }
  }
}
