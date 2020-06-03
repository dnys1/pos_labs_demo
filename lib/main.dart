import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

import 'core/blocs/login/login_bloc.dart';
import 'core/blocs/location/location_bloc.dart';
import 'core/services/auth_service.dart';
import 'core/services/local_auth_service.dart';
import 'core/services/location_service.dart';
import 'ui/views/views.dart';

void main() {
  GoogleMap.init('AIzaSyDyPsb5fqeIYph4LwKh9VnZEId20inMHC4');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(POSLabsDemo());
}

class POSLabsDemo extends StatelessWidget {
  final AuthService _authService;
  final LocationService _locationService;

  POSLabsDemo({
    AuthService authService,
    LocationService locationService,
  })  : _authService =
            authService ?? AuthService(localAuth: LocalAuthService()),
        _locationService = locationService ?? LocationService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            auth: _authService,
          )..add(LoginStarted()),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(
            locationService: _locationService,
          )..add(LocationStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'POS Labs Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => LoginView(),
          '/map': (context) => MapView(),
        },
      ),
    );
  }
}
