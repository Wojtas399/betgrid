import 'package:injectable/injectable.dart';

import 'bets_state.dart';

@injectable
class BetsGpStatusService {
  const BetsGpStatusService();

  GrandPrixStatus defineStatusForGp({
    required DateTime gpStartDateTime,
    required DateTime gpEndDateTime,
    required DateTime now,
  }) {
    final DateTime nowDate = DateTime(
      now.year,
      now.month,
      now.day,
    );
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
      return const GrandPrixStatusOngoing();
    }
    if (now.isAfter(gpEndDate)) {
      return const GrandPrixStatusFinished();
    }
    return const GrandPrixStatusUpcoming();
  }
}
