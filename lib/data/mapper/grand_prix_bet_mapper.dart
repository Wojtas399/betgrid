import 'package:injectable/injectable.dart';

import '../../model/grand_prix_bet.dart';
import '../firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';

@injectable
class GrandPrixBetMapper {
  GrandPrixBet mapFromDto(GrandPrixBetDto grandPrixBetDto) => GrandPrixBet(
        id: grandPrixBetDto.id,
        playerId: grandPrixBetDto.playerId,
        grandPrixId: grandPrixBetDto.grandPrixId,
        qualiStandingsByDriverIds: grandPrixBetDto.qualiStandingsByDriverIds,
        p1DriverId: grandPrixBetDto.p1DriverId,
        p2DriverId: grandPrixBetDto.p2DriverId,
        p3DriverId: grandPrixBetDto.p3DriverId,
        p10DriverId: grandPrixBetDto.p10DriverId,
        fastestLapDriverId: grandPrixBetDto.fastestLapDriverId,
        dnfDriverIds: grandPrixBetDto.dnfDriverIds,
        willBeSafetyCar: grandPrixBetDto.willBeSafetyCar,
        willBeRedFlag: grandPrixBetDto.willBeRedFlag,
      );

  GrandPrixBetDto mapToDto(GrandPrixBet grandPrixBet) => GrandPrixBetDto(
        id: grandPrixBet.id,
        playerId: grandPrixBet.playerId,
        grandPrixId: grandPrixBet.grandPrixId,
        qualiStandingsByDriverIds: grandPrixBet.qualiStandingsByDriverIds,
        p1DriverId: grandPrixBet.p1DriverId,
        p2DriverId: grandPrixBet.p2DriverId,
        p3DriverId: grandPrixBet.p3DriverId,
        p10DriverId: grandPrixBet.p10DriverId,
        fastestLapDriverId: grandPrixBet.fastestLapDriverId,
        dnfDriverIds: grandPrixBet.dnfDriverIds,
        willBeSafetyCar: grandPrixBet.willBeSafetyCar,
        willBeRedFlag: grandPrixBet.willBeRedFlag,
      );
}
