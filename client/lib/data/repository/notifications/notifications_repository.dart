import '../../../model/notification.dart';

abstract interface class NotificationsRepository {
  Stream<Notification> getOpenedNotification();

  Future<void> initialize();
}
