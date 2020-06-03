import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pos_labs_demo/core/blocs/push_notifications/push_notifications_bloc.dart';
import 'package:pos_labs_demo/core/services/push_notifications_service.dart';

class MockPushNotificationsService extends Mock
    implements PushNotificationsService {}

final Map<String, dynamic> mockNotification = {};

void main() {
  MockPushNotificationsService _pushNotifications;

  setUp(() {
    _pushNotifications = MockPushNotificationsService();
  });

  group('PushNotificationsRequest', () {
    blocTest(
      '| Success',
      skip: 0,
      build: () async {
        when(_pushNotifications.requestPushNotification())
            .thenAnswer((_) async => null);
        return PushNotificationsBloc(
            pushNotificationsService: _pushNotifications);
      },
      act: (PushNotificationsBloc bloc) async {
        bloc.add(PushNotificationsRequest());
      },
      expect: [
        PushNotificationsInitial(),
        PushNotificationLoading(),
        PushNotificationsInitial(),
      ],
    );

    blocTest(
      '| Exception',
      skip: 0,
      build: () async {
        when(_pushNotifications.requestPushNotification())
            .thenThrow(Exception());
        return PushNotificationsBloc(
            pushNotificationsService: _pushNotifications);
      },
      act: (PushNotificationsBloc bloc) async {
        bloc.add(PushNotificationsRequest());
      },
      expect: [
        PushNotificationsInitial(),
        PushNotificationLoading(),
        PushNotificationsInitial(),
      ],
    );
  });

  group('PushNotificationReceived', () {
    blocTest(
      '| Success',
      skip: 0,
      build: () async {
        return PushNotificationsBloc(
            pushNotificationsService: _pushNotifications);
      },
      act: (PushNotificationsBloc bloc) async {
        bloc.add(PushNotificationReceived(mockNotification));
      },
      expect: [
        PushNotificationsInitial(),
        PushNotificationLoaded(mockNotification),
      ],
    );
  });
}
