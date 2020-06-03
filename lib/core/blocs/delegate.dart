import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBlocDelegate implements BlocDelegate {
  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print('Error: $error');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    print('Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Transition: $transition');
  }

}