import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pos_labs_demo/core/blocs/location/location_bloc.dart';
import 'package:pos_labs_demo/core/models/models.dart';
import 'package:pos_labs_demo/core/services/location_service.dart';

class MockLocationService extends Mock implements LocationService {}

void main() {
  MockLocationService _locationService;
  Location mockLocation = Location(latitude: 34.052235, longitude: -118.243683);

  setUp(() {
    _locationService = MockLocationService();
  });

  group('LocationStarted', () {
    blocTest(
      '| Success',
      skip: 0,
      build: () async {
        when(_locationService.getUserLocation())
            .thenAnswer((_) async => mockLocation);
        return LocationBloc(locationService: _locationService);
      },
      act: (LocationBloc bloc) async {
        bloc.add(LocationStarted());
      },
      expect: [
        LocationLoading(),
        LocationLoaded(userLocation: mockLocation),
      ],
    );

    blocTest(
      '| Failure',
      skip: 0,
      build: () async {
        when(_locationService.getUserLocation())
            .thenThrow(LocationException.unknown());
        return LocationBloc(locationService: _locationService);
      },
      act: (LocationBloc bloc) async {
        bloc.add(LocationStarted());
      },
      expect: [
        LocationLoading(),
        LocationFailure.unknown(),
      ],
    );
  });
}
