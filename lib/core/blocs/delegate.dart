import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class CustomBlocDelegate implements BlocDelegate {
  static final Logger _logger = Logger('BlocDelegate');

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    _logger.severe('[${bloc.runtimeType}] $error', error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    _logger.fine('[${bloc.runtimeType}] $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    _logger.fine('[${bloc.runtimeType}] $transition');
  }

}