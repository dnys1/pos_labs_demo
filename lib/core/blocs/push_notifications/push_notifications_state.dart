part of 'push_notifications_bloc.dart';

abstract class PushNotificationsState extends Equatable {
  const PushNotificationsState();

  @override
  List<Object> get props => [];
}

/// The initial and base-case state for push notifications.
class PushNotificationsInitial extends PushNotificationsState {}

/// A push notification has been requested -- sending request to server.
class PushNotificationLoading extends PushNotificationsState {}

/// A notification is received and the data is loaded.
class PushNotificationLoaded extends PushNotificationsState {
  /// The data attached to the notification.
  final Map<String, dynamic> data;

  const PushNotificationLoaded(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() {
    return 'PushNotificationLoaded { data: $data }';
  }
}
