import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/enums/biometric_type.dart';
import '../../core/blocs/login/login_bloc.dart';
import '../../core/blocs/push_notifications/push_notifications_bloc.dart';
import '../keys.dart';
import '../widgets/widgets.dart';

class LoginView extends StatelessWidget {
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.of(context).pushNamed('/map');

              // Wait 'til Navigator navigates to the next route, then
              // reset the view for if users navigate back to this page.
              //
              // Adding this event to the Bloc before the Navigator transitions
              // fully will cause the initial page to flash for a few frames during
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
                    key: Keys.loginWithFacebookButton,
                    child: Text('Login with Facebook'),
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context)
                          .add(LoginInitiated(method: LoginMethod.Facebook));
                    },
                  ),
                  if (Platform.isIOS &&
                      state.biometricType != BiometricType.None) ...[
                    SizedBox(height: 20),
                    RaisedButton(
                      key: Keys.loginWithBiometricsButton,
                      child:
                          Text('Login with ${state.biometricType.string} ID'),
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginInitiated(method: LoginMethod.Local));
                      },
                    ),
                  ],
                  SizedBox(height: 20),
                  BlocConsumer<PushNotificationsBloc, PushNotificationsState>(
                    listener: (context, state) {
                      // Show a SnackBar when a push notification is received
                      if (state is PushNotificationLoaded) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 5),
                          content: Text('Push notification received'),
                          action: SnackBarAction(
                            label: 'Show data',
                            onPressed: () {
                              showDialog(
                                context: context,
                                child: PushNotificationsDialog(state.data),
                              );
                            },
                          ),
                        ));
                      }
                    },
                    builder: (context, state) {
                      bool buttonEnabled;
                      if (state is PushNotificationsInitial ||
                          state is PushNotificationLoaded) {
                        buttonEnabled = true;
                      } else if (state is PushNotificationLoading) {
                        buttonEnabled = false;
                      } else {
                        throw UnimplementedError(
                            'Invalid PushNotificationsState: $state');
                      }
                      return RaisedButton(
                        key: Keys.requestPushNotificationButton,
                        child: Text('Request Push Notification'),
                        onPressed: buttonEnabled
                            ? () {
                                BlocProvider.of<PushNotificationsBloc>(context)
                                    .add(PushNotificationsRequest());
                              }
                            : null,
                      );
                    },
                  ),
                ],
              );
            } else if (state is LoginFailure) {
              return ExceptionView(
                state.exception,
                tryAgainCallback: () {
                  BlocProvider.of<LoginBloc>(context).add(LoginCleared());
                },
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
