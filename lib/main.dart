import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/blocs/login/login_bloc.dart';
import 'core/services/auth_service.dart';
import 'core/services/local_auth_service.dart';
import 'ui/views/views.dart';

void main() {
  final app = MultiBlocProvider(
    providers: [
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          auth: AuthService(localAuth: LocalAuthService()),
        )..add(AppLoaded()),
      ),
    ],
    child: MyApp(),
  );

  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Labs Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => LoginView(),
        '/map': (context) => MapView(),
      },
    );
  }
}
