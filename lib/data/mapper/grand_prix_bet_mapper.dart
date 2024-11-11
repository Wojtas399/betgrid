import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet.dart';
import '../firebase/model/grand_prix_bet_dto.dart';

@injectable
class GrandPrixBetMapper {
  GrandPrixBet mapFromDto(GrandPrixBetDto grandPrixBetDto) => GrandPrixBet(
        id: grandPrixBetDto.id,
        playerId: grandPrixBetDto.playerId,
        seasonGrandPrixId: grandPrixBetDto.grandPrixId,
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

  GrandPrixBetDto mapToDto(GrandPrixBet grandPrixBet) => GrandPrixBetDto(
        id: grandPrixBet.id,
        playerId: grandPrixBet.playerId,
        grandPrixId: grandPrixBet.seasonGrandPrixId,
        qualiStandingsBySeasonDriverIds:
            grandPrixBet.qualiStandingsBySeasonDriverIds,
        p1SeasonDriverId: grandPrixBet.p1SeasonDriverId,
        p2SeasonDriverId: grandPrixBet.p2SeasonDriverId,
        p3SeasonDriverId: grandPrixBet.p3SeasonDriverId,
        p10SeasonDriverId: grandPrixBet.p10SeasonDriverId,
        fastestLapSeasonDriverId: grandPrixBet.fastestLapSeasonDriverId,
        dnfSeasonDriverIds: grandPrixBet.dnfSeasonDriverIds,
        willBeSafetyCar: grandPrixBet.willBeSafetyCar,
        willBeRedFlag: grandPrixBet.willBeRedFlag,
      );
}
