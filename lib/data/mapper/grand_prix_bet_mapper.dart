import 'package:betgrid_shared/firebase/model/grand_prix_bet_dto.dart';
import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet.dart';

@injectable
class GrandPrixBetMapper {
  GrandPrixBet mapFromDto(GrandPrixBetDto grandPrixBetDto) => GrandPrixBet(
        id: grandPrixBetDto.id,
        season: grandPrixBetDto.season,
        playerId: grandPrixBetDto.playerId,
        seasonGrandPrixId: grandPrixBetDto.seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds:
            grandPrixBetDto.qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: grandPrixBetDto.p1SeasonDriverId,
        p2SeasonDriverId: grandPrixBetDto.p2SeasonDriverId,
        p3SeasonDriverId: grandPrixBetDto.p3SeasonDriverId,
        p10SeasonDriverId: grandPrixBetDto.p10SeasonDriverId,
        fastestLapSeasonDriverId: grandPrixBetDto.fastestLapSeasonDriverId,
        dnfSeasonDriverIds: grandPrixBetDto.dnfSeasonDriverIds,
        willBeSafetyCar: grandPrixBetDto.willBeSafetyCar,
        willBeRedFlag: grandPrixBetDto.willBeRedFlag,
      );
}
