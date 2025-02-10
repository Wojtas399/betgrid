import 'package:betgrid_shared/firebase/model/season_grand_prix_bet_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/season_grand_prix_bet.dart';

@injectable
class SeasonGrandPrixBetMapper {
  SeasonGrandPrixBet mapFromDto(SeasonGrandPrixBetDto dto) =>
      SeasonGrandPrixBet(
        id: dto.id,
        season: dto.season,
        playerId: dto.playerId,
        seasonGrandPrixId: dto.seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds: dto.qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: dto.p1SeasonDriverId,
        p2SeasonDriverId: dto.p2SeasonDriverId,
        p3SeasonDriverId: dto.p3SeasonDriverId,
        p10SeasonDriverId: dto.p10SeasonDriverId,
        fastestLapSeasonDriverId: dto.fastestLapSeasonDriverId,
        dnfSeasonDriverIds: dto.dnfSeasonDriverIds,
        willBeSafetyCar: dto.willBeSafetyCar,
        willBeRedFlag: dto.willBeRedFlag,
      );
}
