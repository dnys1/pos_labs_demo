import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';

class PushNotificationsService {
  static final Logger _logger = Logger('PushNotificationsService');
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static const _serverToken =
      'AAAANrVZdZw:APA91bE7BwzTYudqrWX77MZIcj17SwO2jTIzyBTOrHb2hJzqftfYQdJARAHrk-Hfh-RVhK04f2Yqjj3RJ_de8oiT83EpISLnW3pz028lkrPeo4_8AT9FDdtxDzk5PeJEIYbtKmfYS0gw';

  /// Use a [StreamController] to send messages to the app.
  StreamController _notificationsController =
      StreamController<Map<String, dynamic>>();

  /// The stream of push notifications
  Stream<Map<String, dynamic>> get notificationsStream =>
      _notificationsController.stream;

  /// Cache the user's FCM token
  String _token;

  /// Called on dispose of [PushNotificationsService].
  void dispose() {
    _notificationsController.close();
  }

  /// Configure push notifications for this device.
  Future<void> configure() async {
    _logger.finer('configure');
    bool requestNotificationPermissionResult = await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: false,
      ),
    );
    _logger.finer('configure: requestNotificationPermissionResult $requestNotificationPermissionResult');
    _firebaseMessaging.configure(
      onMessage: _onMessage,
    );
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _logger.finer('configure: tokenRefresh $token');
      _token = token;
    });
    _token = await _firebaseMessaging.getToken();
    _logger.finer('configure: token $_token');
  }

  /// Fires when a notification is received and the application is open and awake.
  Future<void> _onMessage(Map<dynamic, dynamic> message) async {
    _notificationsController.add(message);
    _logger.finer('_onMessage: message $message');
  }

  /// Request a push notification from the Firebase server.
  Future<void> requestPushNotification() async {
    _logger.finer('requestPushNotification');
    if (_token == null) {
      await configure();
    }

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await _firebaseMessaging.getToken(),
        },
      ),
    );
  }
}
