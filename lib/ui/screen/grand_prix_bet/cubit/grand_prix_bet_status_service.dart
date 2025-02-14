import 'package:injectable/injectable.dart';

import 'grand_prix_bet_state.dart';

@injectable
class GrandPrixBetStatusService {
  BetStatus selectStatusBasedOnPoints(double? points) => switch (points) {
    null => BetStatus.pending,
    0 => BetStatus.loss,
    > 0 => BetStatus.win,
    _ => throw '[GrandPrixBetStatusService] Points cannot be negative',
  };
}
