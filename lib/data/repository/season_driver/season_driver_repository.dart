import '../../../model/season_driver.dart';

abstract interface class SeasonDriverRepository {
  Stream<List<SeasonDriver>> getAllSeasonDriversFromSeason(int season);

  Stream<SeasonDriver?> getSeasonDriverByDriverIdAndSeason({
    required String driverId,
    required int season,
  });
}
