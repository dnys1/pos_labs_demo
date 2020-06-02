import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/blocs/login/login_bloc.dart';
import 'core/services/auth_service.dart';
import 'core/services/local_auth_service.dart';
import 'ui/views/views.dart';

void main() {
  runApp(POSLabsDemo());
}

class POSLabsDemo extends StatelessWidget {
  final AuthService _authService;

  POSLabsDemo({
    AuthService authService,
  }) : _authService = authService ?? AuthService(localAuth: LocalAuthService());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            auth: _authService,
          )..add(AppLoaded()),
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
