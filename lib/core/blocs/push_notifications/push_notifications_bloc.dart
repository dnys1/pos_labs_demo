import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../services/push_notifications_service.dart';

part 'push_notifications_event.dart';
part 'push_notifications_state.dart';

/// Handles push notifications configuration and requests.
class PushNotificationsBloc
    extends Bloc<PushNotificationsEvent, PushNotificationsState> {
  PushNotificationsService _pushNotificationsService;

  PushNotificationsBloc(
      {@required PushNotificationsService pushNotificationsService}) {
    assert(pushNotificationsService != null,
        'PushNotificationsService must be provided');
    _pushNotificationsService = pushNotificationsService;

    // Listen to the stream of notifications and add them to the bloc
    _pushNotificationsService.notificationsStream.listen((Map<String, dynamic> notification) {
      add(PushNotificationReceived(notification));
    });
  }

  @override
  PushNotificationsState get initialState => PushNotificationsInitial();
  
  @override
  Future<void> close() {
    _pushNotificationsService.dispose();
    return super.close();
  }

  @override
  Stream<PushNotificationsState> mapEventToState(
    PushNotificationsEvent event,
  ) async* {
    if (event is PushNotificationsRequest) {
      yield* _mapPushNotificationsRequestToState();
    } else if (event is PushNotificationReceived) {
      yield PushNotificationLoaded(event.data);
    }
  }

  /// Requests a push notification using [PushNotificationsService]
  Stream<PushNotificationsState> _mapPushNotificationsRequestToState() async* {
    yield PushNotificationLoading();

    try {
      await _pushNotificationsService.requestPushNotification();
    } catch (e) {
      print('Error requesting push notifications: $e');
    } finally {
      yield PushNotificationsInitial();
    }
  }
}
