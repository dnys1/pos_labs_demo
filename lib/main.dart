import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

import 'core/blocs/delegate.dart';
import 'core/blocs/login/login_bloc.dart';
import 'core/blocs/location/location_bloc.dart';
import 'core/blocs/push_notifications/push_notifications_bloc.dart';
import 'core/services/auth_service.dart';
import 'core/services/local_auth_service.dart';
import 'core/services/location_service.dart';
import 'core/services/push_notifications_service.dart';
import 'ui/views/views.dart';

void main() {
  // Initialize Google Map services (for Directions API)
  GoogleMap.init('AIzaSyDyPsb5fqeIYph4LwKh9VnZEId20inMHC4');

  // Initialize the BlocDelegate
  BlocSupervisor.delegate = CustomBlocDelegate();

  runApp(POSLabsDemo());
}

class POSLabsDemo extends StatelessWidget {
  final AuthService _authService;
  final LocationService _locationService;
  final PushNotificationsService _pushNotificationsService;

  /// Optionally set the initial route.
  final String initialRoute;

  POSLabsDemo({
    AuthService authService,
    LocationService locationService,
    PushNotificationsService pushNotificationsService,
    this.initialRoute = '/',
  })  : _authService =
            authService ?? AuthService(localAuth: LocalAuthService()),
        _locationService = locationService ?? LocationService(),
        _pushNotificationsService =
            pushNotificationsService ?? PushNotificationsService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Labs Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(
                    auth: _authService,
                  )..add(LoginStarted()),
                ),
                BlocProvider<PushNotificationsBloc>(
                  create: (context) => PushNotificationsBloc(
                    pushNotificationsService: _pushNotificationsService,
                  ),
                ),
              ],
              child: LoginView(),
            ),
        '/map': (context) => BlocProvider<LocationBloc>(
              create: (context) => LocationBloc(
                locationService: _locationService,
              )..add(LocationStarted()),
              child: MapView(),
            ),
      },
    );
  }
}
