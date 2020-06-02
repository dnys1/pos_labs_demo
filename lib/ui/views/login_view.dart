import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/biometric_type.dart';
import '../../core/blocs/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.of(context).pushNamed('/map');

              // Wait til Navigator navigates to the next route, then
              // reset the view for if users navigate back to this page.
              //
              // Adding the event to the Bloc before the Navigator transitions
              // fully causes the initial page to flash for a second during
              // transition. This doesn't look great.
              Future.delayed(const Duration(milliseconds: 500)).then((_) {
                BlocProvider.of<LoginBloc>(context).add(LoginCleared());
              });
            }
          },
          builder: (context, state) {
            if (state is LoginLoading || state is LoginSuccess) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LoginInitial) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                    child: Text('Login with Facebook'),
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context)
                          .add(LoginInitiated(method: LoginMethod.Facebook));
                    },
                  ),
                  if (Platform.isIOS && state.biometricType != BiometricType.None) ...[
                    SizedBox(height: 20),
                    RaisedButton(
                      child:
                          Text('Login with ${state.biometricType.string} ID'),
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginInitiated(method: LoginMethod.Local));
                      },
                    ),
                  ],
                ],
              );
            } else if (state is LoginFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(state.exception.message, textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text('Try Again'),
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context).add(LoginCleared());
                    },
                  ),
                ],
              );
            } else {
              throw UnimplementedError('$state is not a valid LoginState');
            }
          },
        ),
      ),
    );
  }
}
