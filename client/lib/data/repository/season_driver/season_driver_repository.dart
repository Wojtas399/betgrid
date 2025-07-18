import '../../../model/season_driver.dart';

abstract interface class SeasonDriverRepository {
  Stream<List<SeasonDriver>> getAllFromSeason(int season);

  Stream<SeasonDriver?> getById({
    required int season,
    required String seasonDriverId,
  });

  Stream<List<SeasonDriver>> getBySeasonTeamId({
    required int season,
    required String seasonTeamId,
  });
}
