import '../../firebase/model/grand_prix_bet/grand_prix_bet_dto.dart';
import '../../model/grand_prix_bet.dart';

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
