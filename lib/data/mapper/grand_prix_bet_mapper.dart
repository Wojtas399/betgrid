import '../../firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import '../../model/grand_prix_bet.dart';

GrandPrixBet mapGrandPrixBetFromDto(GrandPrixBetDto grandPrixBetDto) =>
    GrandPrixBet(
      id: grandPrixBetDto.id,
      grandPrixId: grandPrixBetDto.grandPrixId,
      qualiStandingsByDriverIds: grandPrixBetDto.qualiStandingsByDriverIds,
      p1DriverId: grandPrixBetDto.p1DriverId,
      p2DriverId: grandPrixBetDto.p2DriverId,
      p3DriverId: grandPrixBetDto.p3DriverId,
      p10DriverId: grandPrixBetDto.p10DriverId,
      fastestLapDriverId: grandPrixBetDto.fastestLapDriverId,
      willBeDnf: grandPrixBetDto.willBeDnf,
      willBeSafetyCar: grandPrixBetDto.willBeSafetyCar,
      willBeRedFlag: grandPrixBetDto.willBeRedFlag,
    );

GrandPrixBetDto mapGrandPrixBetToDto(GrandPrixBet grandPrixBet) =>
    GrandPrixBetDto(
      id: grandPrixBet.id,
      grandPrixId: grandPrixBet.grandPrixId,
      qualiStandingsByDriverIds: grandPrixBet.qualiStandingsByDriverIds,
      p1DriverId: grandPrixBet.p1DriverId,
      p2DriverId: grandPrixBet.p2DriverId,
      p3DriverId: grandPrixBet.p3DriverId,
      p10DriverId: grandPrixBet.p10DriverId,
      fastestLapDriverId: grandPrixBet.fastestLapDriverId,
      willBeDnf: grandPrixBet.willBeDnf,
      willBeSafetyCar: grandPrixBet.willBeSafetyCar,
      willBeRedFlag: grandPrixBet.willBeRedFlag,
    );
