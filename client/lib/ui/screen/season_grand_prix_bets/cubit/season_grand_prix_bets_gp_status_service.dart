import 'package:injectable/injectable.dart';

import 'season_grand_prix_bets_state.dart';

@injectable
class SeasonGrandPrixBetsGpStatusService {
  const SeasonGrandPrixBetsGpStatusService();

  SeasonGrandPrixStatus defineStatusForGp({
    required DateTime gpStartDateTime,
    required DateTime gpEndDateTime,
    required DateTime now,
  }) {
    final DateTime nowDate = DateTime(now.year, now.month, now.day);
    final DateTime gpStartDate = DateTime(
      gpStartDateTime.year,
      gpStartDateTime.month,
      gpStartDateTime.day,
    );
    final DateTime gpEndDate = DateTime(
      gpEndDateTime.year,
      gpEndDateTime.month,
      gpEndDateTime.day,
    );
    if (nowDate.isAtSameMomentAs(gpStartDate) ||
        nowDate.isAtSameMomentAs(gpEndDate) ||
        (nowDate.isAfter(gpStartDate) && nowDate.isBefore(gpEndDate))) {
      return const SeasonGrandPrixStatusOngoing();
    }
    if (now.isAfter(gpEndDate)) {
      return const SeasonGrandPrixStatusFinished();
    }
    return const SeasonGrandPrixStatusUpcoming();
  }
}
