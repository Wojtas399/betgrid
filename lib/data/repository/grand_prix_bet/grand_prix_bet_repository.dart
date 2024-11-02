import '../../../model/grand_prix_bet.dart';

abstract interface class GrandPrixBetRepository {
  Stream<List<GrandPrixBet>> getGrandPrixBetsForPlayersAndGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfGrandPrixes,
  });

  Stream<GrandPrixBet?> getGrandPrixBetForPlayerAndGrandPrix({
    required String playerId,
    required String grandPrixId,
  });

  Future<void> addGrandPrixBet({
    required String playerId,
    required String grandPrixId,
    List<String?> qualiStandingsByDriverIds = const [],
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String> dnfDriverIds = const [],
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  });

  Future<void> updateGrandPrixBet({
    required String playerId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsByDriverIds,
    String? p1DriverId,
    String? p2DriverId,
    String? p3DriverId,
    String? p10DriverId,
    String? fastestLapDriverId,
    List<String>? dnfDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  });
}
