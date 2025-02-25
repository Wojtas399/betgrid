import '../../../model/season_grand_prix_bet.dart';

abstract interface class SeasonGrandPrixBetRepository {
  Stream<SeasonGrandPrixBet?> getBySeasonGrandPrixId({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
  });

  Future<void> add({
    required String playerId,
    required int season,
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

  Future<void> update({
    required String playerId,
    required int season,
    required String seasonGrandPrixId,
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
