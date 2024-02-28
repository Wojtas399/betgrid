import '../../firebase/model/grand_prix_bet_dto/grand_prix_bet_dto.dart';
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
      dnfDriverIds: grandPrixBetDto.dnfDriverIds,
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
      dnfDriverIds: grandPrixBet.dnfDriverIds,
      willBeSafetyCar: grandPrixBet.willBeSafetyCar,
      willBeRedFlag: grandPrixBet.willBeRedFlag,
    );
