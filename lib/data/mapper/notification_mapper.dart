import 'package:firebase_messaging/firebase_messaging.dart';

import '../../model/notification.dart';

class NotificationMapper {
  Notification mapFromFirebaseMessage(RemoteMessage message) {
    final Map<String, dynamic> dataJson = message.data;
    final String type = dataJson['type'];

    if (type == 'season_gp_bet') {
      return SeasonGpBetNotification(
        season: int.parse(dataJson['season']),
        seasonGrandPrixId: dataJson['season_gp_id'],
      );
    }

    throw Exception('Unknown notification type: $type');
  }
}
