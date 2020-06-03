import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

import '../../core/models/location.dart';
import '../../core/blocs/location/location_bloc.dart';
import '../widgets/widgets.dart';

/// A view for demo'ing Google Maps
class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final GlobalKey<GoogleMapStateBase> _mapKey = GlobalKey<GoogleMapStateBase>();

  /// The user's current location.
  Location _userLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // If this view is loaded after the bloc has finished loading
    // the user's location, the trigger in `listener` of BlocConsumer
    // will not be called. This allows the correct state to be set in
    // that case.
    final state = BlocProvider.of<LocationBloc>(context).state;
    if (state is LocationLoaded) {
      _userLocation = state.userLocation;
    }
  }

  /// Adds a route to Los Angeles from the user's current location.
  Future<void> _addRoute() async {
    GoogleMap.of(_mapKey).clearMarkers();

    /// Change the directions to display based off
    /// the user's location, since routing to a location
    /// which cannot be accessed by roads will result
    /// in a blank map.
    String destination;
    if (_userLocation.locationInNorthAmerica) {
      destination = 'Los Angeles, CA';
    } else {
      destination = 'London, England';
    }

    GoogleMap.of(_mapKey).addDirection(
      _userLocation.toDirectionsRequestString(),
      destination,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoaded) {
          setState(() {
            _userLocation = state.userLocation;
          });
        }
      },
      builder: (context, state) {
        Widget body;

        if (state is LocationLoading) {
          body = Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LocationLoaded) {
          GeoCoord userLocation = GeoCoord(
            state.userLocation.latitude,
            state.userLocation.longitude,
          );
          body = GoogleMap(
            key: _mapKey,
            mapType: MapType.roadmap,
            initialPosition: userLocation,
            markers: {Marker(userLocation)},
            mobilePreferences: MobileMapPreferences(
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
            ),
          );
        } else if (state is LocationFailure) {
          body = ExceptionView(
            state.exception,
            tryAgainCallback: () {
              BlocProvider.of<LocationBloc>(context).add(LocationStarted());
            },
          );
        } else {
          throw UnimplementedError('Invalid LocationState: $state');
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Maps Demo'),
          ),
          body: body,
          floatingActionButton: state is LocationLoaded
              ? FloatingActionButton.extended(
                  onPressed: _userLocation != null ? _addRoute : null,
                  label: Text('Route to Los Angeles!'),
                  icon: Icon(Icons.directions),
                )
              : null,
        );
      },
    );
  }
}
