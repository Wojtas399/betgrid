import '../../../model/grand_prix_bet.dart';

abstract interface class GrandPrixBetRepository {
  Stream<List<GrandPrixBet>> getGrandPrixBetsForPlayersAndSeasonGrandPrixes({
    required List<String> idsOfPlayers,
    required List<String> idsOfSeasonGrandPrixes,
  });

  Stream<GrandPrixBet?> getGrandPrixBetForPlayerAndSeasonGrandPrix({
    required String playerId,
    required String seasonGrandPrixId,
  });

  Future<void> addGrandPrixBet({
    required String playerId,
    required String seasonGrandPrixId,
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
