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
    List<String?> qualiStandingsBySeasonDriverIds = const [],
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String> dnfSeasonDriverIds = const [],
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  });

  Future<void> updateGrandPrixBet({
    required String playerId,
    required String grandPrixBetId,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? willBeSafetyCar,
    bool? willBeRedFlag,
  });
}
