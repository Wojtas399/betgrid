import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../model/notification.dart';
import '../../mapper/notification_mapper.dart';
import 'notifications_repository.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationsRepositoryImpl.instance.showNotification(message);
}

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationMapper _notificationMapper = NotificationMapper();

  NotificationsRepositoryImpl._();

  static final NotificationsRepositoryImpl instance =
      NotificationsRepositoryImpl._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isLocalNotificationsInitialized = false;

  @override
  Stream<Notification> getOpenedNotification() async* {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      yield _notificationMapper.mapFromFirebaseMessage(initialMessage);
    }

    await for (RemoteMessage message in FirebaseMessaging.onMessageOpenedApp) {
      yield _notificationMapper.mapFromFirebaseMessage(message);
    }
  }

  @override
  Future<void> initialize() async {
    _setupNotifications();

    await _requestPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for high importance notifications.',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupNotifications() async {
    if (_isLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for high importance notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const initializationSettingsIos = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isLocalNotificationsInitialized = true;
  }

  Future<void> _requestPermission() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
  }
}
