import '../../model/notification.dart';

class NotificationMapper {
  Notification mapFromJson(Map<String, dynamic> dataJson) {
    final String? type = dataJson['type'];

    if (type == 'season_gp_bet') {
      return SeasonGpBetNotification(
        season: int.parse(dataJson['season']),
        seasonGrandPrixId: dataJson['season_gp_id'],
      );
    }

    return const EmptyNotification();
  }
}
