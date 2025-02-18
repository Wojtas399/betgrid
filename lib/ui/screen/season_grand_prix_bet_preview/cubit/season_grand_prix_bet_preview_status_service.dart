import 'package:injectable/injectable.dart';

import 'season_grand_prix_bet_preview_state.dart';

@injectable
class SeasonGrandPrixBetPreviewStatusService {
  BetStatus selectStatusBasedOnPoints(double? points) => switch (points) {
    null => BetStatus.pending,
    0 => BetStatus.loss,
    > 0 => BetStatus.win,
    _ =>
      throw '[SeasonGrandPrixBetPreviewStatusService] Points cannot be negative',
  };
}
