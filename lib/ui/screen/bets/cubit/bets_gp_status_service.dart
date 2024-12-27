import 'package:injectable/injectable.dart';

import '../../../../model/grand_prix.dart';
import 'bets_state.dart';

@injectable
class BetsGpStatusService {
  const BetsGpStatusService();

  GrandPrixStatus defineStatusForGp({
    required GrandPrix gp,
    required DateTime now,
  }) {
    final DateTime nowDate = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final DateTime gpStartDate = DateTime(
      gp.startDate.year,
      gp.startDate.month,
      gp.startDate.day,
    );
    final DateTime gpEndDate = DateTime(
      gp.endDate.year,
      gp.endDate.month,
      gp.endDate.day,
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
