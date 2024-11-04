import '../../../model/season_driver.dart';

abstract interface class SeasonDriverRepository {
  Stream<List<SeasonDriver>> getAllSeasonDriversFromSeason(int season);

  Stream<SeasonDriver?> getSeasonDriverById(String id);
}
