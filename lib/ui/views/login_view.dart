import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/blocs/login/login_bloc.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushNamed('/map');

            // Reset the view if users were to navigate back to this page.
            BlocProvider.of<LoginBloc>(context).add(LoginCleared());
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
                FlatButton(
                  child: Text('Login with Facebook'),
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context)
                        .add(LoginInitiated(method: LoginMethod.Facebook));
                  },
                ),
                SizedBox(height: 20),
                FlatButton(
                  child: Text('Login with Touch ID'),
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context)
                        .add(LoginInitiated(method: LoginMethod.Local));
                  },
                ),
              ],
            );
          } else if (state is LoginFailure) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
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
                  FlatButton(
                    child: Text('Try Again'),
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context).add(LoginCleared());
                    },
                  ),
                ],
              ),
            );
          } else {
            throw UnimplementedError('$state is not a valid LoginState');
          }
        },
      ),
    );
  }
}
