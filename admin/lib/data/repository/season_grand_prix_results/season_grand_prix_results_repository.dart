import '../../../model/season_grand_prix_results.dart';

abstract interface class SeasonGrandPrixResultsRepository {
  Stream<SeasonGrandPrixResults?> getBySeasonGrandPrixId({
    required int season,
    required String seasonGrandPrixId,
  });

  Future<void> add({
    required int season,
    required String seasonGrandPrixId,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  });

  Future<void> update({
    required String id,
    required int season,
    List<String?>? qualiStandingsBySeasonDriverIds,
    String? p1SeasonDriverId,
    String? p2SeasonDriverId,
    String? p3SeasonDriverId,
    String? p10SeasonDriverId,
    String? fastestLapSeasonDriverId,
    List<String>? dnfSeasonDriverIds,
    bool? wasThereSafetyCar,
    bool? wasThereRedFlag,
  });
}
