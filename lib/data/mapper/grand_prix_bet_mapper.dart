import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet.dart';
import '../firebase/model/grand_prix_bet_dto.dart';

@injectable
class GrandPrixBetMapper {
  GrandPrixBet mapFromDto(GrandPrixBetDto grandPrixBetDto) => GrandPrixBet(
        id: grandPrixBetDto.id,
        playerId: grandPrixBetDto.playerId,
        grandPrixId: grandPrixBetDto.grandPrixId,
        qualiStandingsBySeasonDriverIds:
            grandPrixBetDto.qualiStandingsByDriverIds,
        p1SeasonDriverId: grandPrixBetDto.p1DriverId,
        p2SeasonDriverId: grandPrixBetDto.p2DriverId,
        p3SeasonDriverId: grandPrixBetDto.p3DriverId,
        p10SeasonDriverId: grandPrixBetDto.p10DriverId,
        fastestLapSeasonDriverId: grandPrixBetDto.fastestLapDriverId,
        dnfSeasonDriverIds: grandPrixBetDto.dnfDriverIds,
        willBeSafetyCar: grandPrixBetDto.willBeSafetyCar,
        willBeRedFlag: grandPrixBetDto.willBeRedFlag,
      );

  GrandPrixBetDto mapToDto(GrandPrixBet grandPrixBet) => GrandPrixBetDto(
        id: grandPrixBet.id,
        playerId: grandPrixBet.playerId,
        grandPrixId: grandPrixBet.grandPrixId,
        qualiStandingsByDriverIds: grandPrixBet.qualiStandingsBySeasonDriverIds,
        p1DriverId: grandPrixBet.p1SeasonDriverId,
        p2DriverId: grandPrixBet.p2SeasonDriverId,
        p3DriverId: grandPrixBet.p3SeasonDriverId,
        p10DriverId: grandPrixBet.p10SeasonDriverId,
        fastestLapDriverId: grandPrixBet.fastestLapSeasonDriverId,
        dnfDriverIds: grandPrixBet.dnfSeasonDriverIds,
        willBeSafetyCar: grandPrixBet.willBeSafetyCar,
        willBeRedFlag: grandPrixBet.willBeRedFlag,
      );
}
