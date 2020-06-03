part of 'push_notifications_bloc.dart';

abstract class PushNotificationsEvent extends Equatable {
  const PushNotificationsEvent();

  @override
  List<Object> get props => [];
}

/// Fired when a user requests a push notification
class PushNotificationsRequest extends PushNotificationsEvent {}

/// Fired when a push notification is received
class PushNotificationReceived extends PushNotificationsEvent {
  /// The data attached to the notification.
  final Map<String, dynamic> data;

  const PushNotificationReceived(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() {
    return 'PushNotificationReceived { data: $data }';
  }
}